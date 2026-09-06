---
name: flutter-clean-arch
description: Implement or modify a feature following this project's clean-architecture layers — entity, repo interface, usecase, model, remote datasource, repo impl, freezed cubit + state, DI. Use whenever adding or changing an API endpoint, usecase, repository method, or cubit under lib/src/, or when scaffolding a new feature folder.
---

# Flutter Clean Architecture Skill

You are a Flutter Clean Architecture expert assistant. Your role is to help developers implement features following the clean architecture pattern used in this project.

## Architecture Overview

This project follows **Clean Architecture** with three layers:
- **Domain Layer**: Core business logic (entities, repository interfaces, use cases)
- **Data Layer**: External interfaces (models, datasources, repository implementations)
- **Presentation Layer**: UI (cubits, states, views, widgets)

Dependencies flow: Presentation → Domain ← Data

## Your Responsibilities

When asked to implement a feature, you MUST:

1. **Follow the exact layer structure**:
   ```
   lib/src/{feature_name}/
   ├── data/
   │   ├── datasources/
   │   ├── models/
   │   └── repositories/
   ├── domain/
   │   ├── entities/
   │   │   └── extensions/   ← helpers on this feature's entities/enums
   │   ├── repositories/
   │   └── usecases/
   └── presentation/
       ├── app/
       ├── view/
       └── widgets/
   ```

2. **Create files in this exact order**:
   - Step 1: Domain entities
   - Step 2: Domain repository interface
   - Step 3: Domain use cases
   - Step 4: Data models (extend entities)
   - Step 5: Data remote datasource (with NetworkCallHandler mixin)
   - Step 6: Data repository implementation (with ErrorHandler mixin)
   - Step 7: Presentation cubit state (with Freezed)
   - Step 8: Presentation cubit (emit the full `Failure`; the view renders it)
   - Step 9: Run build_runner
   - Step 10: Dependency injection setup
   - Step 11: Views and widgets

3. **Use the correct patterns**:
   - All repo methods return `ResultFuture<T>` (which is `Future<Either<Failure, T>>`)
   - Use cases extend `UsecaseWithParams<ReturnType, ParamsType>` or `UsecaseWithoutParams<ReturnType>`
   - Data sources use `handleNetworkCall<T>()` for all API calls
   - Repository implementations use `handleRepoCall()` for all datasource calls
   - Cubits use `fold()` to handle Either results
   - States use `@freezed` for immutability
   - Each Cubit has ONE use case for ONE function

4. **Follow naming conventions**:
   - Files: snake_case (`user_model.dart`, `auth_repo.dart`)
   - Classes: PascalCase with suffixes (`UserModel`, `AuthRepo`, `LoginUsecase`, `LoginCubit`)
   - Variables: camelCase, private with `_` prefix
   - Methods: camelCase, action-oriented

5. **Error Handling**:
   - ALWAYS emit the full `Failure` object in the `failed` state — never just a message string
   - Cubits are logic layer: NEVER call `showToast`, `getFailureMessage`, or any UI-related code inside a cubit
   - Toast/message display belongs in the view layer inside a `BlocListener`, using the `FailureExtension`:
     ```dart
     BlocListener<{CubitName}Cubit, {CubitName}State>(
       listener: (context, state) {
         if (state is _failedState) {
           final message = state.failure.getFailureMessage(context);
           // show toast, snackbar, dialog, etc.
         }
       },
     )
     ```
   - `getFailureMessage(context)` is defined in `lib/core/config/extentions/failure_extension.dart` — it returns the backend's own message (plus `errors`) for `GeneralFailure` and a localized generic line for every other failure type, with null-safe locale fallback
   - Emit loading state BEFORE async operations
   - Handle all states: initial, loading, success, failed

6. **Critical Rules**:
   - NEVER create custom form validators - ALWAYS use `TextFormValidation` from `lib/core/utils/form_validations.dart`
   - NEVER use `Localizations.localeOf(context)` - ALWAYS use `AppLocalizations.of(context)?.localeName == 'en'`
   - NEVER pass headers manually to Dio calls — `AuthInterceptor` automatically injects `Authorization: Bearer <token>` and `language` on every request; base URL is set globally via `BaseOptions` in `_mainInit()`
   - ALWAYS extract API data using `NetworkConstants.dataParam`
   - Models extend entities, never duplicate
   - One use case = one action
   - Cubits orchestrate, they don't contain business logic if needed business logic we make a helper class in domain folder

## Templates Reference

### Domain Entity
```dart
class {EntityName} {
  final int id;
  final String name;

  {EntityName}({required this.id, required this.name});
}
```

#### Entities with per-language fields

When the API returns a value in both languages — `{field}En` and `{field}Ar` — keep both
fields, and add a getter on the entity that resolves them. **Never branch on the language in
the UI**: that duplicates the rule at every call site and makes it untestable without a
widget.

```dart
class {EntityName} {
  final String? pdfUrlEn;
  final String? pdfUrlAr;
  final String? imageUrlEn;
  final String? imageUrlAr;

  String? pdfUrl({required bool isEn}) =>
      _pick(en: pdfUrlEn, ar: pdfUrlAr, isEn: isEn);

  String? imageUrl({required bool isEn}) =>
      _pick(en: imageUrlEn, ar: imageUrlAr, isEn: isEn);

  /// Prefer the active language, fall back to the other.
  static String? _pick({
    String? en,
    String? ar,
    required bool isEn,
  }) => isEn ? en ?? ar : ar ?? en;
}
```

Rules:

- **Resolution order:** active language first, then the other language. Content is often
  published in one language before the other, so the fallback is deliberate, not defensive.
- **Both null → return `null`.** Don't substitute an empty string or a placeholder. The
  caller decides what "missing" means — usually hiding the section rather than rendering a
  dead control.
- **One `_pick` helper** once the entity has more than one such pair, so the fallback policy
  lives in exactly one expression and can't drift between fields.
- **Document the policy once, on `_pick`.** The getters' names already say what they return;
  a doc comment on each one just restates the code.
- **Keep the entity Flutter-free.** Take `bool isEn`, not `BuildContext`. Callers pass
  `context.isEn` (from `core/config/extentions/context_extension.dart`) at the widget
  boundary.
- **Named parameter,** never positional — `pdfUrl(true)` is unreadable at the call site.
- Non-nullable pairs use the same shape without the `??` fallback.

`bool isEn` is the codebase idiom (`context.isEn`, `groupBrands(isEn:)`) and the app ships
exactly two locales. If a third language is ever added, replace the bool with an enum in
these getters — that is the only place the change needs to reach.

Reference implementation: `lib/src/products/domain/entities/product.dart` (`name(isEn:)`
over `nameEn` / `nameAr` via `LocalizedText.pick`).

### Entity Extensions

Anything computed *from* an entity or one of its enums — a localized label, a status
colour or icon, a derived count, a formatted display string — is an extension, not a
method on the entity and not inline in a widget. It lives beside the entity:

```
lib/src/{feature}/domain/entities/
├── {entity_name}.dart
└── extensions/
    └── {entity_name}_extension.dart      ← extension {EntityName}X on {EntityName}
```

- One file per extended type, named `<Type>X`.
- The entity file stays Flutter-free. The extension file may import `Colours`, `Media`,
  `AppLocalizations` and `flutter/material.dart` — that is its job.
- App-wide extensions on Dart/Flutter/`core/` types (`BuildContext`, `DateTime`, `String`,
  `num`, `Failure`) stay in `lib/core/config/extentions/`. `core/` never imports from
  `lib/src/`, so an entity extension can never go there.
- Widgets call the extension: `order.status.label(text)`, `category.totalChildrenCount`.

### Domain Repository Interface
```dart
import 'package:app_starter/core/config/typedefs.dart';

abstract class {FeatureName}Repo {
  ResultFuture<List<{EntityName}>> getAll();
  ResultFuture<{EntityName}> getById({required String id});
  ResultFuture<String> create({required {EntityName}Request request});
  ResultFuture<void> update({required String id, required {EntityName}Request request});
  ResultFuture<void> delete({required String id});
}
```

### Domain Use Case (Without Params)
```dart
import 'package:app_starter/core/config/typedefs.dart';
import 'package:app_starter/core/config/usecase.dart';

class {ActionName}Usecase extends UsecaseWithoutParams<List<{EntityName}>> {
  const {ActionName}Usecase(this._repo);
  final {FeatureName}Repo _repo;

  @override
  ResultFuture<List<{EntityName}>> call() => _repo.getAll();
}
```

### Domain Use Case (With Params)
```dart
import 'package:app_starter/core/config/typedefs.dart';
import 'package:app_starter/core/config/usecase.dart';

class {ActionName}Usecase extends UsecaseWithParams<ReturnType, ParamsTypeRequest> {
  const {ActionName}Usecase(this._repo);
  final {FeatureName}Repo _repo;

  @override
  ResultFuture<ReturnType> call(ParamsTypeRequest params) =>
      _repo.{methodName}(param: params);
}

class ParamsTypeRequest {
  final String param1;
  final String param2;

  ParamsTypeRequest({required this.param1, required this.param2});
}
```

### Data Model
```dart
import 'package:app_starter/src/{feature}/domain/entities/{entity_name}.dart';

class {EntityName}Model extends {EntityName} {
  {EntityName}Model({required super.id, required super.name});

  factory {EntityName}Model.fromJson(Map<String, dynamic> json) =>
      {EntityName}Model(
        id: json["id"],
        name: json["name"] ?? "",
      );
}
```

### Data Remote DataSource
The interface and implementation live in **separate files**:
- `{feature_name}_remote_datasrc.dart` — abstract interface only
- `{feature_name}_remote_datasrc_impl.dart` — implementation only, imports the interface file

**Interface (`{feature_name}_remote_datasrc.dart`):**
```dart
abstract interface class {FeatureName}RemoteDataSrc {
  Future<List<{EntityName}>> getAll();
}
```

**Implementation (`{feature_name}_remote_datasrc_impl.dart`):**
```dart
import 'package:dio/dio.dart';
import 'package:app_starter/core/constants/network_constants.dart';
import 'package:app_starter/core/mixins/network_handler.dart';
import '{feature_name}_remote_datasrc.dart';

class {FeatureName}RemoteDataSrcImpl
    with NetworkCallHandler
    implements {FeatureName}RemoteDataSrc {
  const {FeatureName}RemoteDataSrcImpl(this._dio);
  final Dio _dio;

  @override
  Future<List<{EntityName}>> getAll() =>
      handleNetworkCall<List<{EntityName}>>(
        call: () => _dio.get('/{endpoint}'),
        onSuccess: (response) {
          final data = response.data[NetworkConstants.dataParam] as List;
          return data.map((item) => {EntityName}Model.fromJson(item)).toList();
        },
      );
}
```

> The same naming rule applies to any datasource: the concrete class file always ends with `_impl.dart`.

### Data Repository Implementation
```dart
import 'package:app_starter/core/mixins/error_handler.dart';
import 'package:app_starter/core/config/typedefs.dart';

class {FeatureName}RepoImpl with ErrorHandler implements {FeatureName}Repo {
  const {FeatureName}RepoImpl(this._remoteDataSource);
  final {FeatureName}RemoteDataSrc _remoteDataSource;

  @override
  ResultFuture<List<{EntityName}>> getAll() async {
    return handleRepoCall(() => _remoteDataSource.getAll());
  }
}
```

### Presentation Cubit State
```dart
part of '{cubit_name}_cubit.dart';

@freezed
sealed class {CubitName}State with _${CubitName}State {
  const factory {CubitName}State.initial() = _initialState;
  const factory {CubitName}State.loading() = _loadingState;
  const factory {CubitName}State.failed({required Failure failure}) = _failedState;
  const factory {CubitName}State.success({required DataType data}) = _successState;
}
```

### Presentation Cubit
```dart
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:app_starter/core/utils/util_functions.dart';

part '{cubit_name}_state.dart';
part '{cubit_name}_cubit.freezed.dart';

class {CubitName}Cubit extends Cubit<{CubitName}State> {
  final {UsecaseName} _{usecaseName};

  {CubitName}Cubit({required {UsecaseName} {usecaseName}})
      : _{usecaseName} = {usecaseName},
        super({CubitName}State.initial());

  Future<void> {methodName}() async {
    UtilFunctions.appLog("{methodName}:");
    emit({CubitName}State.loading());

    final result = await _{usecaseName}();

    result.fold(
      (failure) => emit({CubitName}State.failed(failure: failure)),
      (data) => emit({CubitName}State.success(data: data)),
    );
  }
}
```

### Presentation View — providing a screen-scoped cubit

A cubit the screen owns is provided **above** the widget that uses it. Splitting the view in
two is what makes that possible: the public `StatelessWidget` provides, a private
`_{ViewName}Body` consumes. Providing inside the stateful widget's own `build` puts the cubit
below the `State`, so `context.read<{CubitName}Cubit>()` from `initState`, `dispose` or any
handler method throws `ProviderNotFoundException`.

```dart
class {FeatureName}View extends StatelessWidget {
  static const String path = '/{feature-name}';

  const {FeatureName}View({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<{CubitName}Cubit>(
      create: (BuildContext context) => sl<{CubitName}Cubit>(),
      child: const _{FeatureName}ViewBody(),
    );
  }
}

class _{FeatureName}ViewBody extends StatefulWidget {
  const _{FeatureName}ViewBody();

  @override
  State<_{FeatureName}ViewBody> createState() => _{FeatureName}ViewBodyState();
}

class _{FeatureName}ViewBodyState extends State<_{FeatureName}ViewBody> {
  // Controllers, form keys and local flags live here — never the cubit.

  void _submit() => context.read<{CubitName}Cubit>().{methodName}();

  @override
  Widget build(BuildContext context) {
    return BlocListener<{CubitName}Cubit, {CubitName}State>(
      listener: (BuildContext context, state) => state.whenOrNull(
        failed: (failure) => UtilFunctions.showFailedToast(
          message: failure.getFailureMessage(context),
        ),
      ),
      child: const Scaffold(),
    );
  }
}
```

Rules that follow from it:

- **`create:`, never `BlocProvider.value`.** `create:` hands the cubit's lifetime to the
  provider. `.value` is for re-providing a cubit that something else already owns — there is
  no such case in this codebase.
- **Never hold the cubit in a `State` field**, and never call `close()` on it. The provider
  closes what it created; a manual `close()` in `dispose` is a double-close waiting to happen.
  `dispose` is for controllers and `ValueNotifier`s only.
- Several cubits → `MultiBlocProvider` in the same wrapper. Several listeners →
  `MultiBlocListener` inside the body.
- Cubits that outlive the screen are already global: they come from the registries in
  `lib/core/providers/`, so do not re-provide them here.

### Dependency Injection
Registration is **generated** by `injectable`; nothing is written into
`injection_container.dart` for a feature. Annotate each class where it is declared:

```dart
// datasource impl — registered *as* its interface
@LazySingleton(as: {FeatureName}RemoteDataSrc)
class {FeatureName}RemoteDataSrcImpl with NetworkCallHandler
    implements {FeatureName}RemoteDataSrc { ... }

// repo impl — registered *as* its interface
@LazySingleton(as: {FeatureName}Repo)
class {FeatureName}RepoImpl with ErrorHandler implements {FeatureName}Repo { ... }

// usecase — concrete, one shared instance
@lazySingleton
class {ActionName}Usecase extends UsecaseWithParams<...> { ... }

// cubit — fresh instance per resolution
@injectable
class {CubitName}Cubit extends Cubit<{CubitName}State> { ... }
```

Then regenerate: `dart run build_runner build`. Constructor parameters are resolved by
type, so an interface-typed parameter (`{FeatureName}Repo`) finds the impl registered
`as:` it. Import `package:injectable/injectable.dart` in each annotated file.

## Implementation Process

When a user asks you to implement a feature, you MUST follow this multi-phase process:

### Phase 1: Planning and Documentation (REQUIRED FIRST STEP)

**BEFORE writing any code**, you MUST:

1. **Create a comprehensive implementation plan** with the following sections:
   - Feature Overview
   - API Endpoints (methods, paths, request/response structures)
   - Data Models (all entities and their fields)
   - Architecture Breakdown:
     - Domain Layer (entities, repo interface, use cases)
     - Data Layer (models, datasource, repo implementation)
     - Presentation Layer (cubits, states, views)
   - File Structure (complete list of files to be created)
   - Implementation Steps (numbered, in order)
   - Dependency Injection Setup
   - Testing Considerations

2. **Save the plan** to `docs/claude-plans/{TODAYS-DATE}-{feature-name}-implementation-plan.md`
   - Use kebab-case for the filename
   - Include the current date in the document header
   - Make the plan detailed enough that another developer could implement it

3. **Wait for user approval** before proceeding to implementation

### Phase 2: Requirements Gathering

Ask clarifying questions about:
- API endpoints (exact paths, methods, authentication)
- Data structure (all fields, types, nullable values)
- CRUD operations needed (which operations: create, read, update, delete)
- Special validations or business rules
- UI requirements (if any specific UI components needed)
- Error handling requirements

### Phase 3: Implementation (Only after plan approval)

Once the plan is approved:

1. **Create Domain Layer**:
   - Define entities (request/response objects)
   - Create repository interface with proper method signatures
   - Create use cases (one per action)

2. **Create Data Layer**:
   - Create models extending entities with fromJson
   - Create remote datasource with NetworkCallHandler
   - Create repository implementation with ErrorHandler

3. **Create Presentation Layer**:
   - Create cubit state with Freezed
   - Create cubit (no mixin — emit the full `Failure` in the failed state)
   - Run: `dart run build_runner build`

4. **Setup Dependency Injection**:
   - Annotate: `@LazySingleton(as: Interface)` on datasource and repo impls,
     `@lazySingleton` on usecases, `@injectable` on cubits
   - Run `dart run build_runner build` — `injection_container.config.dart` is regenerated;
     nothing is edited by hand

5. **Create UI**:
   - Create views with BlocProvider — the `StatelessWidget` provides, a private stateful body
     consumes (see **Presentation View**)
   - Create widgets as needed

6. **Update the plan document** with:
   - Implementation notes
   - Any deviations from the original plan
   - Known issues or TODOs

## Validation Functions Available

NEVER create custom validators. Use these from `lib/core/utils/form_validations.dart`:
- `TextFormValidation.requiredField(value, context: context)`
- `TextFormValidation.emailValidation(value, context: context)`
- `TextFormValidation.phoneValidation(value, context: context)`
- `TextFormValidation.fullNameValidation(value, context: context)`
- `TextFormValidation.passwordValidation(value, context: context)`
- `TextFormValidation.passwordConfirmationValidation(value, password, context: context)`
- `TextFormValidation.otpValidation(value, context: context)`

## Common Mistakes to Avoid

1. ❌ Creating custom validators
2. ❌ Using `Localizations.localeOf(context)`
3. ❌ Emitting a `String message` in the failed state instead of the full `Failure` object
4. ❌ Calling `showToast` or `getFailureMessage` inside a cubit — call `state.failure.getFailureMessage(context)` in a `BlocListener` in the view instead
5. ❌ Making models without extending entities
5b. ❌ Branching on `isEn` in a widget to choose between an entity's `{field}En` / `{field}Ar` — put a resolving getter on the entity instead
6. ❌ Not using mixins (NetworkCallHandler in datasources, ErrorHandler in repository impls)
7. ❌ Multiple use cases in one cubit
8. ❌ Not emitting loading state before async operations
9. ❌ Not handling all state cases (initial, loading, success, failed)
10. ❌ Forgetting to run build_runner after creating/modifying cubits
11. ❌ Providing a cubit inside the stateful widget that consumes it — it lands below the
    `State`, so `context.read` from a handler throws. Wrap with a `StatelessWidget` instead
12. ❌ `BlocProvider.value` — use `create:`; `.value` re-provides a cubit someone else owns
13. ❌ Keeping the cubit in a `State` field or calling `close()` on it in `dispose` — the
    provider owns it
14. ❌ Passing `Options(headers: ...)` to Dio calls — headers and base URL are globally configured via `AuthInterceptor` and `BaseOptions`; use relative paths only (e.g. `/api/v1/resource`)

## Plan Document Template

When creating a plan in `docs/claude-plans/{feature-name}-implementation-plan.md`, use this structure:

```markdown
# {Feature Name} - Implementation Plan

**Created**: {Current Date}
**Status**: Planning | In Progress | Completed
**Developer**: Claude AI Assistant

## 1. Feature Overview

Brief description of the feature and its purpose.

## 2. API Endpoints

### Endpoint 1: {Name}
- **Method**: GET/POST/PUT/DELETE
- **Path**: `/api/path/to/endpoint`
- **Authentication**: Required/Optional
- **Request Body**:
  ```json
  {
    "field1": "type",
    "field2": "type"
  }
  ```
- **Response**:
  ```json
  {
    "data": {
      "field1": "type",
      "field2": "type"
    }
  }
  ```

## 3. Data Models

### Entity: {EntityName}
- `id`: String - Unique identifier
- `field1`: String - Description
- `field2`: int - Description

### Request Entity: {EntityName}Request
- `field1`: String - Description
- `field2`: int - Description

## 4. Architecture Breakdown

### 4.1 Domain Layer

#### Entities
- `{entity_name}.dart` - Main entity
- `{entity_name}_request.dart` - Request entity

#### Repository Interface
- `{feature_name}_repo.dart` - Abstract repository

#### Use Cases
- `get_all_{entities}_usecase.dart` - Get all items
- `get_{entity}_by_id_usecase.dart` - Get single item
- `create_{entity}_usecase.dart` - Create item
- `update_{entity}_usecase.dart` - Update item
- `delete_{entity}_usecase.dart` - Delete item

### 4.2 Data Layer

#### Models
- `{entity_name}_model.dart` - Extends entity with fromJson

#### DataSource
- `{feature_name}_remote_datasource.dart` - API calls

#### Repository Implementation
- `{feature_name}_repo_impl.dart` - Implements domain repo

### 4.3 Presentation Layer

#### Cubits
- `get_{entities}_cubit/` - List cubit
  - `get_{entities}_cubit.dart`
  - `get_{entities}_state.dart`
  - `get_{entities}_cubit.freezed.dart` (generated)
- `create_{entity}_cubit/` - Create cubit
  - Similar structure

#### Views
- `{feature_name}_list_view.dart` - List screen
- `{feature_name}_detail_view.dart` - Detail screen
- `create_{entity}_view.dart` - Create screen

#### Widgets
- `{entity}_card.dart` - List item widget
- Custom widgets as needed

## 5. Complete File Structure

```
lib/src/{feature_name}/
├── data/
│   ├── datasources/
│   │   ├── {feature_name}_remote_datasrc.dart       ← interface
│   │   └── {feature_name}_remote_datasrc_impl.dart  ← implementation
│   ├── models/
│   │   └── {entity_name}_model.dart
│   └── repositories/
│       └── {feature_name}_repo_impl.dart
├── domain/
│   ├── entities/
│   │   ├── {entity_name}.dart
│   │   ├── {entity_name}_request.dart
│   │   └── extensions/
│   │       └── {entity_name}_extension.dart
│   ├── repositories/
│   │   └── {feature_name}_repo.dart
│   └── usecases/
│       ├── get_all_{entities}_usecase.dart
│       ├── get_{entity}_by_id_usecase.dart
│       ├── create_{entity}_usecase.dart
│       ├── update_{entity}_usecase.dart
│       └── delete_{entity}_usecase.dart
└── presentation/
    ├── app/
    │   ├── get_{entities}_cubit/
    │   │   ├── get_{entities}_cubit.dart
    │   │   └── get_{entities}_state.dart
    │   └── create_{entity}_cubit/
    │       ├── create_{entity}_cubit.dart
    │       └── create_{entity}_state.dart
    ├── view/
    │   ├── {feature_name}_list_view.dart
    │   └── create_{entity}_view.dart
    └── widgets/
        └── {entity}_card.dart
```

## 6. Implementation Steps

1. ✅ Create planning document
2. ⏳ Create domain entities
3. ⏳ Create domain repository interface
4. ⏳ Create domain use cases
5. ⏳ Create data models
6. ⏳ Create remote datasource
7. ⏳ Create repository implementation
8. ⏳ Create cubit states
9. ⏳ Create cubits
10. ⏳ Run build_runner
11. ⏳ Setup dependency injection
12. ⏳ Create views
13. ⏳ Create widgets
14. ⏳ Test feature

## 7. Dependency Injection Setup

No registration file to edit. Each class carries its own annotation and
`dart run build_runner build` writes `lib/core/services/injection_container.config.dart`:

| Layer | Annotation | Why |
|---|---|---|
| `{FeatureName}RemoteDataSrcImpl` | `@LazySingleton(as: {FeatureName}RemoteDataSrc)` | resolved by its interface |
| `{FeatureName}RepoImpl` | `@LazySingleton(as: {FeatureName}Repo)` | resolved by its interface |
| `GetAll{Entities}Usecase`, `Create{Entity}Usecase`, … | `@lazySingleton` | one shared, stateless instance |
| `{CubitName}Cubit` | `@injectable` | fresh instance per screen |
| A cubit that must outlive screens | `@lazySingleton` | only when it deliberately holds app-wide state |

Third-party types and anything needing a hand-built argument (a `Dio` with interceptors,
the list of analytics clients) go in `lib/core/services/register_module.dart` — the one
`@module`. Do not add a second module per feature.

Flavor-specific implementations: add `@Environment('dev')` / `@Environment('prod')` next to
the registration annotation; `configureDependencies()` passes `F.name` as the environment.

## 8. Testing Considerations

- Unit tests for use cases
- Unit tests for repository
- Widget tests for views
- Integration tests for complete flows

## 9. Implementation Notes

(To be filled during implementation)

## 10. Known Issues / TODOs

(To be filled during implementation)

---

**End of Plan**
```

## Response Format

When implementing a feature:

### Phase 1 Response:
1. Ask clarifying questions if needed
2. Create and save the implementation plan
3. Present a summary of the plan
4. Ask for approval to proceed

### Phase 2 Response (After Approval):
1. List all files that will be created
2. Create files in the correct order
3. Show the complete code for each file
4. Provide the dependency injection setup
5. Show the build_runner command
6. Provide example usage in a view
7. Update the plan document with implementation notes

Be thorough, follow the architecture strictly, and ensure consistency with the existing codebase.
