# Flutter Clean Architecture Guide

## Table of Contents
1. [Architecture Overview](#architecture-overview)
2. [Layer Structure](#layer-structure)
3. [Data Flow](#data-flow)
4. [Step-by-Step Feature Implementation](#step-by-step-feature-implementation)
5. [Naming Conventions](#naming-conventions)
6. [Rules and Best Practices](#rules-and-best-practices)
7. [Templates](#templates)
8. [Dependency Injection](#dependency-injection)
9. [Error Handling](#error-handling)

---

## Architecture Overview

This project follows **Clean Architecture** principles with three main layers:

```
lib/src/{feature_name}/
├── data/              # External layer (frameworks & drivers)
│   ├── datasource/    # API calls, database operations
│   ├── models/        # Data Transfer Objects (DTOs)
│   └── repo/          # Repository implementations
├── domain/            # Core business logic (framework independent)
│   ├── entity/        # Business objects
│   ├── repo/          # Repository interfaces (contracts)
│   └── usecases/      # Business use cases
└── presentation/      # UI layer
    ├── app/           # State management (Cubits)
    ├── view/          # Screens
    └── widgets/       # Reusable UI components
```

**Key Principles:**
- Domain layer is **independent** of frameworks
- Data layer **implements** domain interfaces
- Presentation layer **depends** on domain layer only
- Dependencies flow **inward** (Presentation → Domain ← Data)

---

## Layer Structure

### 1. Domain Layer (Core Business Logic)

#### **Entities**
Business objects representing core data structures. These are **plain Dart classes** with no dependencies.

**Location:** `lib/src/{feature}/domain/entity/`

**Rules:**
- No external dependencies (no JSON, no frameworks)
- May include `toJson()` if needed for requests
- May include `copyWith()` for immutability
- Should be simple and focused

**Template:**
```dart
class {EntityName} {
  final String id;
  final String name;
  // ... other properties

  {EntityName}({
    required this.id,
    required this.name,
  });

  // Optional: for request entities
  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };

  // Optional: for immutability
  {EntityName} copyWith({
    String? id,
    String? name,
  }) => {EntityName}(
    id: id ?? this.id,
    name: name ?? this.name,
  );
}
```

#### **Repository Interfaces**
Abstract contracts defining what operations are available. These use `ResultFuture<T>` which returns `Either<Failure, T>`.

**Location:** `lib/src/{feature}/domain/repo/`

**Rules:**
- Must be **abstract** classes
- All methods return `ResultFuture<T>` (which is `Future<Either<Failure, T>>`)
- Method names should be clear and action-oriented
- Use named parameters for clarity

**Template:**
```dart
import 'package:attendance/core/config/typedefs.dart';
import 'package:attendance/src/{feature}/domain/entity/{entity_name}.dart';

abstract class {FeatureName}Repo {
  ResultFuture<List<{EntityName}>> getAll();

  ResultFuture<{EntityName}> getById({required String id});

  ResultFuture<String> create({required {EntityName}Request request});

  ResultFuture<String> update({
    required String id,
    required {EntityName}Request request,
  });

  ResultFuture<String> delete({required String id});
}
```

#### **Use Cases**
Single-responsibility classes representing one business action. Each use case does **one thing**.

**Location:** `lib/src/{feature}/domain/usecases/`

**Rules:**
- Extend `UsecaseWithParams<ReturnType, ParamsType>` OR `UsecaseWithoutParams<ReturnType>`
- Constructor takes repository via dependency injection
- Override `call()` method
- Delegate to repository
- Keep use cases **small and focused**

**Template (With Params):**
```dart
import 'package:attendance/core/config/typedefs.dart';
import 'package:attendance/core/config/usecase.dart';
import 'package:attendance/src/{feature}/domain/entity/{entity_name}.dart';
import 'package:attendance/src/{feature}/domain/repo/{feature}_repo.dart';

class {ActionName}Usecase extends UsecaseWithParams<ReturnType, ParamsTypeRequest> {
  const {ActionName}Usecase(this._repo);

  final {FeatureName}Repo _repo;

  @override
  ResultFuture<ReturnType> call(ParamsTypeRequest params) =>
      _repo.{methodName}(param: params);
}

Class ParamsTypeRequest{
final String id;
final String name;
// ... other properties

ParamsTypeRequest({
required this.id,
required this.name,
});
}
```


**Template (With Params (Passing variable)):**
```dart
import 'package:attendance/core/config/typedefs.dart';
import 'package:attendance/core/config/usecase.dart';
import 'package:attendance/src/{feature}/domain/entity/{entity_name}.dart';
import 'package:attendance/src/{feature}/domain/repo/{feature}_repo.dart';

class {ActionName}Usecase extends UsecaseWithParams<ReturnType, ParamsTypeRequest> {
  const {ActionName}Usecase(this._repo);

  final {FeatureName}Repo _repo;

  @override
  ResultFuture<ReturnType> call(ParamsTypeRequest params) =>
      _repo.{methodName}(param1: params.param1, param2:param2 ... so on);
}
Class ParamsTypeRequest{
final String param1;
final String param2;
// ... other properties

ParamsTypeRequest({
required this.param1,
required this.param2,
});
}
```

**Template (Without Params):**
```dart
import 'package:attendance/core/config/typedefs.dart';
import 'package:attendance/core/config/usecase.dart';
import 'package:attendance/src/{feature}/domain/entity/{entity_name}.dart';
import 'package:attendance/src/{feature}/domain/repo/{feature}_repo.dart';

class {ActionName}Usecase extends UsecaseWithoutParams<List<{EntityName}>> {
  const {ActionName}Usecase(this._repo);

  final {FeatureName}Repo _repo;

  @override
  ResultFuture<List<{EntityName}>> call() =>
      _repo.getAll();
}
```

---

### 2. Data Layer (External Interfaces)

#### **Models**
Data Transfer Objects (DTOs) that extend entities and add serialization logic.

**Location:** `lib/src/{feature}/data/models/`

**Rules:**
- Models **extend** entities
- Include `fromJson()` factory constructor
- Handle API response structure

**Template:**
```dart
import 'package:attendance/src/{feature}/domain/entity/{entity_name}.dart';

class {EntityName}Model extends {EntityName} {
  {EntityName}Model({
    required super.id,
    required super.name,
  });

  factory {EntityName}Model.fromJson(Map<String, dynamic> json) =>
      {EntityName}Model(
        id: json["id"]?.toString() ?? "",
        name: json["name"] ?? "",
      );
}
```

#### **Remote Data Source**
Handles all API calls using Dio and the `NetworkCallHandler` mixin.

**Location:** `lib/src/{feature}/data/datasource/`

**Rules:**
- Implementation uses `NetworkCallHandler` mixin
- Must have corresponding abstract interface (defined in same file)
- Use `handleNetworkCall<T>()` for all API calls
- Get headers using `NetworkConstants.getHeaders()`
- Extract data using `NetworkConstants.dataParam`
- Use models for deserialization

**Template:**
```dart
import 'package:attendance/core/config/mixins/network_handler.dart';
import 'package:attendance/core/constants/network_constants.dart';
import 'package:attendance/src/{feature}/data/models/{entity_name}_model.dart';
import 'package:attendance/src/{feature}/domain/entity/{entity_name}.dart';
import 'package:dio/dio.dart';

class {FeatureName}RemoteDataSrcImpl
    with NetworkCallHandler
    implements {FeatureName}RemoteDataSrc {
  const {FeatureName}RemoteDataSrcImpl(this._dio);

  final Dio _dio;

  @override
  Future<List<{EntityName}>> getAll() async {
    final header = await NetworkConstants.getHeaders();

    return handleNetworkCall<List<{EntityName}>>(
      call: () => _dio.get(
        '${NetworkConstants.url}/{endpoint_path}',
        options: Options(headers: header),
      ),
      onSuccess: (response) {
        final data = response.data[NetworkConstants.dataParam] as List;
        return data
            .map((item) => {EntityName}Model.fromJson(item))
            .toList();
      },
    );
  }

  @override
  Future<{EntityName}> getById({required String id}) async {
    final header = await NetworkConstants.getHeaders();

    return handleNetworkCall<{EntityName}>(
      call: () => _dio.get(
        '${NetworkConstants.url}/{endpoint_path}/$id',
        options: Options(headers: header),
      ),
      onSuccess: (response) => {EntityName}Model.fromJson(
        response.data[NetworkConstants.dataParam],
      ),
    );
  }

  @override
  Future<String> create({required {EntityName}Request request}) async {
    final header = await NetworkConstants.getHeaders();

    return handleNetworkCall<String>(
      call: () => _dio.post(
        '${NetworkConstants.url}/{endpoint_path}',
        options: Options(headers: header),
        data: request.toJson(),
      ),
      onSuccess: (response) =>
          response.data[NetworkConstants.dataParam]["id"]?.toString() ?? "",
    );
  }

  @override
  Future<String> update({
    required String id,
    required {EntityName}Request request,
  }) async {
    final header = await NetworkConstants.getHeaders();

    return handleNetworkCall<String>(
      call: () => _dio.put(
        '${NetworkConstants.url}/{endpoint_path}/$id',
        options: Options(headers: header),
        data: request.toJson(),
      ),
      onSuccess: (response) => response.data[NetworkConstants.messageParam] ?? "",
    );
  }

  @override
  Future<String> delete({required String id}) async {
    final header = await NetworkConstants.getHeaders();

    return handleNetworkCall<String>(
      call: () => _dio.delete(
        '${NetworkConstants.url}/{endpoint_path}/$id',
        options: Options(headers: header),
      ),
      onSuccess: (response) => "",
    );
  }
}

abstract class {FeatureName}RemoteDataSrc {
  const {FeatureName}RemoteDataSrc();

  Future<List<{EntityName}>> getAll();
  Future<{EntityName}> getById({required String id});
  Future<String> create({required {EntityName}Request request});
  Future<String> update({required String id, required {EntityName}Request request});
  Future<String> delete({required String id});
}
```

#### **Repository Implementation**
Implements the domain repository interface, delegates to data source, and handles errors.

**Location:** `lib/src/{feature}/data/repo/`

**Rules:**
- Implements domain repository interface
- Uses `ErrorHandler` mixin
- Wraps all data source calls with `handleRepoCall()`
- No business logic here, just delegation

**Template:**
```dart
import 'package:attendance/core/config/mixins/error_handler.dart';
import 'package:attendance/core/config/typedefs.dart';
import 'package:attendance/src/{feature}/data/datasource/{feature}_remote_datasource.dart';
import 'package:attendance/src/{feature}/domain/entity/{entity_name}.dart';
import 'package:attendance/src/{feature}/domain/repo/{feature}_repo.dart';

class {FeatureName}RepoImpl with ErrorHandler implements {FeatureName}Repo {
  const {FeatureName}RepoImpl(this._remoteDataSource);

  final {FeatureName}RemoteDataSrc _remoteDataSource;

  @override
  ResultFuture<List<{EntityName}>> getAll() async {
    return handleRepoCall(() => _remoteDataSource.getAll());
  }

  @override
  ResultFuture<{EntityName}> getById({required String id}) async {
    return handleRepoCall(() => _remoteDataSource.getById(id: id));
  }

  @override
  ResultFuture<String> create({required {EntityName}Request request}) async {
    return handleRepoCall(() => _remoteDataSource.create(request: request));
  }

  @override
  ResultFuture<String> update({
    required String id,
    required {EntityName}Request request,
  }) async {
    return handleRepoCall(
      () => _remoteDataSource.update(id: id, request: request),
    );
  }

  @override
  ResultFuture<String> delete({required String id}) async {
    return handleRepoCall(() => _remoteDataSource.delete(id: id));
  }
}
```

---

### 3. Presentation Layer (UI)

#### **Cubit State (with Freezed)**
Immutable state classes representing different UI states.

**Location:** `lib/src/{feature}/presentation/app/{cubit_name}_cubit/`

**Rules:**
- Use `freezed` package for immutability
- Defined in separate `{cubit_name}_state.dart` file
- Part of the cubit file (`part of 'cubit_name.dart'`)
- Minimum states: `initial`, `loading`, `success`, `failed`
- Success state includes the data
- Failed state includes error message
- Use `sealed class` with `@freezed`

**Template:**
```dart
part of '{cubit_name}_cubit.dart';

@freezed
sealed class {CubitName}State with _${CubitName}State {
  const factory {CubitName}State.initial() = _initialState;

  const factory {CubitName}State.loading() = _loadingState;

  const factory {CubitName}State.failed({required String message}) =
      _failedState;

  const factory {CubitName}State.success({required DataType data}) =
      _successState;
}
```

#### **Cubit**
State management class that orchestrates use cases and emits states.

**Location:** `lib/src/{feature}/presentation/app/{cubit_name}_cubit/`

**Rules:**
- Extend `Cubit<{CubitName}State>`
- Mix in `FailurePopups` for error handling
- Inject use cases via constructor
- Initialize with `.initial()` state
- Emit `.loading()` before async operations
- Use `.fold()` on use case results to handle success/failure
- Use `showToast()` or `getFailureMessage()` for errors
- Include part statements for state and freezed files
- always include bool isEn in all params for functions that call usecases
- always call getFailureMessage function from the failurpopups class to get the error message correctly

**Template:**
```dart
import 'package:attendance/core/config/mixins/failure_popups.dart';
import 'package:attendance/core/utils/util_functions.dart';
import 'package:attendance/src/{feature}/domain/entity/{entity_name}.dart';
import 'package:attendance/src/{feature}/domain/usecases/{usecase_name}.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part '{cubit_name}_state.dart';
part '{cubit_name}_cubit.freezed.dart';

class {CubitName}Cubit extends Cubit<{CubitName}State> with FailurePopups {
  final {UsecaseName} _{usecaseName};

  {CubitName}Cubit({required {UsecaseName} {usecaseName}})
      : _{usecaseName} = {usecaseName},
        super({CubitName}State.initial());

  Future<void> {methodName}(bool isEn) async {
    UtilFunctions.appLog("{methodName}:");
    emit({CubitName}State.loading());

    // Call the use case
    final result = await _{usecaseName}();

    result.fold(
      (failure) {
        final message=getFailureMessage(failure, isEn);
        emit({CubitName}State.failed(message: message));
      },
      (data) {
        emit({CubitName}State.success(data: data));
      },
    );
  }
}
```

**Template (With Parameters):**
```dart
import 'package:attendance/core/config/mixins/failure_popups.dart';
import 'package:attendance/core/utils/util_functions.dart';
import 'package:attendance/src/{feature}/domain/entity/{entity_name}.dart';
import 'package:attendance/src/{feature}/domain/usecases/{usecase_name}.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part '{cubit_name}_state.dart';
part '{cubit_name}_cubit.freezed.dart';

class {CubitName}Cubit extends Cubit<{CubitName}State> with FailurePopups {
  final {UsecaseName} _{usecaseName};

  {CubitName}Cubit({required {UsecaseName} {usecaseName}})
      : _{usecaseName} = {usecaseName},
        super({CubitName}State.initial());

  Future<void> {methodName}({
    required ParamType1 param1,
    required ParamType2 param2,
    bool isEn = true,
  }) async {
    UtilFunctions.appLog("{methodName}: $param1, $param2");
    emit({CubitName}State.loading());

    // Create the request object
    final request = {RequestEntity}(
      param1: param1,
      param2: param2,
    );

    // Call the use case
    final result = await _{usecaseName}(request);

    result.fold(
      (failure) {
        showToast(failure, isEn);
        final message=getFailureMessage(failure, isEn);
        emit({CubitName}State.failed(message: message));
      },
      (data) {
        emit({CubitName}State.success(data: data));
      },
    );
  }
}
```

#### **Views**
Screen widgets that provide and consume cubits.

**Location:** `lib/src/{feature}/presentation/view/`

**Rules:**
- Use `BlocProvider` to provide cubit
- Use `BlocConsumer` or `BlocBuilder` to consume state
- Handle all state cases (initial, loading, success, failed)
- Keep views **declarative** and focused on UI

---

## Data Flow

```
┌─────────────────────────────────────────────────────────┐
│                         UI (View)                        │
│  User interacts → calls cubit method                    │
└───────────────────────────┬─────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────┐
│                    Cubit (State Mgmt)                    │
│  emit(loading) → call usecase → fold result            │
└───────────────────────────┬─────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────┐
│                  UseCase (Business Logic)                │
│  Calls repository method                                │
└───────────────────────────┬─────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────┐
│              Repository Interface (Contract)             │
│  Defines what operations are available                  │
└───────────────────────────┬─────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────┐
│          Repository Implementation (Data Layer)          │
│  handleRepoCall() → calls datasource                    │
└───────────────────────────┬─────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────┐
│             RemoteDataSource (API Handler)               │
│  handleNetworkCall() → makes HTTP request               │
└───────────────────────────┬─────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────┐
│                      API Response                        │
│  Returns JSON data                                       │
└───────────────────────────┬─────────────────────────────┘
                            │
        ┌───────────────────┴───────────────────┐
        │                                       │
        ▼                                       ▼
    SUCCESS                                 FAILURE
        │                                       │
        ▼                                       ▼
  Model.fromJson()                     Exception thrown
        │                                       │
        ▼                                       ▼
  Return Entity                       Caught by ErrorHandler
        │                                       │
        ▼                                       ▼
  Right(entity)                          Left(Failure)
        │                                       │
        └───────────────────┬───────────────────┘
                            │
                            ▼
                    Back to Cubit
                            │
        ┌───────────────────┴───────────────────┐
        │                                       │
        ▼                                       ▼
   emit(success)                          emit(failed)
        │                                       │
        └───────────────────┬───────────────────┘
                            │
                            ▼
                      UI Updates
```

---

## Step-by-Step Feature Implementation

### Step 1: Create Directory Structure
```
lib/src/{feature_name}/
├── data/
│   ├── datasource/
│   ├── models/
│   └── repo/
├── domain/
│   ├── entity/
│   ├── repo/
│   └── usecases/
└── presentation/
    ├── app/
    ├── view/
    └── widgets/
```

### Step 2: Domain Layer (Business Logic)

1. **Create Entities** (`domain/entity/`)
   - Define your business objects
   - Request entities (for POST/PUT)
   - Response entities (for GET)

2. **Create Repository Interface** (`domain/repo/`)
   - Define abstract class
   - Define methods returning `ResultFuture<T>`

3. **Create Use Cases** (`domain/usecases/`)
   - One file per use case
   - Extend appropriate base class
   - Inject repository
   - Delegate to repository

### Step 3: Data Layer (External Interface)

1. **Create Models** (`data/models/`)
   - Extend entities
   - Add `fromJson()` factory

2. **Create Remote Data Source** (`data/datasource/`)
   - Define abstract interface
   - Implement with `NetworkCallHandler` mixin
   - Use `handleNetworkCall<T>()` for all API calls

3. **Create Repository Implementation** (`data/repo/`)
   - Implement domain repository
   - Use `ErrorHandler` mixin
   - Wrap calls with `handleRepoCall()`

### Step 4: Presentation Layer (UI)

1. **Create Cubit State** (`presentation/app/{cubit_name}_cubit/`)
   - Create `{cubit_name}_state.dart`
   - Use freezed for immutability
   - Define: initial, loading, success, failed states

2. **Create Cubit** (`presentation/app/{cubit_name}_cubit/`)
   - Create `{cubit_name}_cubit.dart`
   - Inject use cases
   - Create methods that emit states
   - Use `fold()` on use case results

3. **Generate Freezed Code**
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. **Create Views** (`presentation/view/`)
   - Use `BlocProvider` to provide cubit
   - Use `BlocConsumer`/`BlocBuilder` for state
   - Handle all state cases

5. **Create Widgets** (`presentation/widgets/`)
   - Reusable UI components

### Step 5: Dependency Injection

Add to `lib/core/services/injection_container.main.dart`:

```dart
Future<void> _{featureName}Init() async {
  sl
    // Use Cases
    ..registerLazySingleton(() => {ActionName}Usecase(sl()))
    // Repository
    ..registerLazySingleton<{FeatureName}Repo>(
      () => {FeatureName}RepoImpl(sl()),
    )
    // Data Source
    ..registerLazySingleton<{FeatureName}RemoteDataSrc>(
      () => {FeatureName}RemoteDataSrcImpl(sl()),
    );
}
```

Then call `_{featureName}Init()` in `splashInit()`.

---

## Naming Conventions

### Files
- **Snake_case:** `{entity_name}_model.dart`, `{feature_name}_repo.dart`
- **Descriptive:** `login_usecase.dart`, `forgot_password_cubit.dart`

### Classes
- **PascalCase:** `LoginUsecase`, `AuthRepo`, `UserModel`
- **Suffixes:**
  - Entities: `User`, `LoginRequest`, `ForgotPasswordResponse`
  - Models: `UserModel`, `LoginRequestModel`
  - Repositories: `AuthRepo`, `AuthRepoImpl`
  - Data Sources: `AuthRemoteDataSrc`, `AuthRemoteDataSrcImpl`
  - Use Cases: `LoginUsecase`, `GetUserProfileUsecase`
  - Cubits: `LoginCubit`, `GetUserProfileCubit`
  - States: `LoginState`, `GetUserProfileState`

### Variables
- **camelCase:** `userName`, `isLoading`, `_remoteDataSource`
- **Private:** prefix with `_` (e.g., `_loginUsecase`)

### Methods
- **camelCase:** `login()`, `getUserProfile()`, `createLeaveRequest()`
- **Action-oriented:** `getAll()`, `getById()`, `create()`, `update()`, `delete()`

---

## Rules and Best Practices

### General Rules
1. **Separation of Concerns:** Each layer has a specific responsibility
2. **Dependency Rule:** Dependencies point inward (Presentation → Domain ← Data)
3. **Single Responsibility:** Each class/function does ONE thing
4. **Testability:** Code should be easily testable
5. **Immutability:** Use `final` and `const` where possible

### Domain Layer Rules
1. **No Framework Dependencies:** Domain should be pure Dart
2. **Interfaces Over Implementations:** Define contracts, not implementations
3. **One Use Case = One Action:** Keep use cases focused
4. **Entities Are Business Objects:** Represent core business concepts

### Data Layer Rules
1. **Models Extend Entities:** Don't duplicate, extend
2. **Error Handling at Boundaries:** Use mixins (`NetworkCallHandler`, `ErrorHandler`)
3. **Always Use handleNetworkCall:** For consistent error handling
4. **Always Use handleRepoCall:** Converts exceptions to Failures
5. **Data Source = External Interface:** Only talks to external systems

### Presentation Layer Rules
1. **Cubits Orchestrate:** They don't contain business logic
2. **States Are Immutable:** Use freezed
3. **Always Handle All States:** initial, loading, success, failed
4. **Views Are Declarative:** Keep them simple
5. **Use FailurePopups Mixin:** For consistent error messaging
6. **Emit Loading First:** Before any async operation
7. **Use fold() for Results:** Handle both success and failure paths

### Error Handling Rules
1. **Exceptions in Data Layer:** Thrown by data sources
2. **Failures in Domain Layer:** Wrapped by repository
3. **User Messages in Presentation:** Shown by cubits
4. **Use FailurePopups Mixin:** `showToast()` or `getFailureMessage()`

### Dependency Injection Rules
1. **Register in Order:** Use Cases → Repo → DataSource
2. **Use LazySingleton:** For most services
3. **Inject Dependencies:** Don't create them
4. **Use Constructor Injection:** Make dependencies explicit

---

## Templates

### Complete Feature Template

```
lib/src/user_management/
├── data/
│   ├── datasource/
│   │   └── user_remote_datasource.dart
│   ├── models/
│   │   └── user_model.dart
│   └── repo/
│       └── user_repo_impl.dart
├── domain/
│   ├── entity/
│   │   ├── user.dart
│   │   └── create_user_request.dart
│   ├── repo/
│   │   └── user_repo.dart
│   └── usecases/
│       ├── get_all_users_usecase.dart
│       ├── get_user_by_id_usecase.dart
│       ├── create_user_usecase.dart
│       ├── update_user_usecase.dart
│       └── delete_user_usecase.dart
└── presentation/
    ├── app/
    │   ├── get_users_cubit/
    │   │   ├── get_users_cubit.dart
    │   │   ├── get_users_state.dart
    │   │   └── get_users_cubit.freezed.dart
    │   └── create_user_cubit/
    │       ├── create_user_cubit.dart
    │       ├── create_user_state.dart
    │       └── create_user_cubit.freezed.dart
    ├── view/
    │   ├── users_list_view.dart
    │   └── create_user_view.dart
    └── widgets/
        └── user_card.dart
```

---

## Dependency Injection

### How It Works
1. **GetIt** is the service locator (`sl`)
2. Dependencies are registered in `injection_container.main.dart`
3. Registration happens in **reverse dependency order**:
   - Data Sources first (depend on Dio)
   - Repositories next (depend on Data Sources)
   - Use Cases last (depend on Repositories)
4. Cubits are **NOT** registered in DI container (provided via `BlocProvider`)

### Registration Pattern

```dart
Future<void> _{featureName}Init() async {
  sl
    // Use Cases (depend on repos)
    ..registerLazySingleton(() => GetAllUsersUsecase(sl()))
    ..registerLazySingleton(() => CreateUserUsecase(sl()))

    // Repository (depends on datasource)
    ..registerLazySingleton<UserRepo>(
      () => UserRepoImpl(sl()),
    )

    // Data Source (depends on Dio)
    ..registerLazySingleton<UserRemoteDataSrc>(
      () => UserRemoteDataSrcImpl(sl()),
    );
}
```

### Providing Cubits in Views

```dart
class UsersView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetUsersCubit(
        getUsersUsecase: sl<GetAllUsersUsecase>(),
      )..getUsers(), // Optionally call method on creation
      child: UsersViewBody(),
    );
  }
}
```

---

## Error Handling

### Exception Hierarchy (Data Layer)
```dart
ServerException        // API errors
NoInternetException    // No connectivity
TimeOutException       // Request timeout
GeneralException       // Validation errors from backend
FormatParserException  // JSON parsing errors
UnauthenticatedException // 401 errors
```

### Failure Hierarchy (Domain Layer)
```dart
ServerFailure
NoInternetFailure
TimeOutFailure
GeneralFailure
FormatParserFailure
UnauthenticatedFailure
```

### Error Flow
1. **API Error** → Exception thrown in DataSource
2. **Exception** → Caught by `handleRepoCall()` in Repository
3. **Converted** → Exception → Failure
4. **Returned** → `Left(Failure)` to UseCase
5. **Propagated** → To Cubit
6. **Handled** → In `.fold()` failure branch
7. **Displayed** → Using `showToast()` or `getFailureMessage()`

### Using FailurePopups Mixin

```dart
// In Cubit
result.fold(
  (failure) {
    showToast(failure, isEn); // Shows snackbar
    emit(State.failed(message: failure.message));
  },
  (data) {
    emit(State.success(data: data));
  },
);

// Or get message without showing
final errorMessage = getFailureMessage(failure, isEn);
```

---

## Example: Creating a "Leave Requests" Feature

### 1. Domain Layer

**Entity:** `lib/src/leave_requests/domain/entity/leave_request.dart`
```dart
class LeaveRequest {
  final int id;
  final String employeeName;
  final DateTime startDate;
  final DateTime endDate;
  final String status;

  LeaveRequest({
    required this.id,
    required this.employeeName,
    required this.startDate,
    required this.endDate,
    required this.status,
  });
}
```

**Repository:** `lib/src/leave_requests/domain/repo/leave_request_repo.dart`
```dart
import 'package:attendance/core/config/typedefs.dart';
import 'package:attendance/src/leave_requests/domain/entity/leave_request.dart';

abstract class LeaveRequestRepo {
  ResultFuture<List<LeaveRequest>> getPendingLeaves();
  ResultFuture<String> updateStatus({
    required int leaveId,
    required String status,
  });
}
```

**UseCase:** `lib/src/leave_requests/domain/usecases/get_pending_leaves.dart`
```dart
import 'package:attendance/core/config/typedefs.dart';
import 'package:attendance/core/config/usecase.dart';
import 'package:attendance/src/leave_requests/domain/entity/leave_request.dart';
import 'package:attendance/src/leave_requests/domain/repo/leave_request_repo.dart';

class GetPendingLeavesUsecase extends UsecaseWithoutParams<List<LeaveRequest>> {
  const GetPendingLeavesUsecase(this._repo);

  final LeaveRequestRepo _repo;

  @override
  ResultFuture<List<LeaveRequest>> call() => _repo.getPendingLeaves();
}
```

### 2. Data Layer

**Model:** `lib/src/leave_requests/data/models/leave_request_model.dart`
```dart
import 'package:attendance/src/leave_requests/domain/entity/leave_request.dart';

class LeaveRequestModel extends LeaveRequest {
  LeaveRequestModel({
    required super.id,
    required super.employeeName,
    required super.startDate,
    required super.endDate,
    required super.status,
  });

  factory LeaveRequestModel.fromJson(Map<String, dynamic> json) =>
      LeaveRequestModel(
        id: json["id"] ?? 0,
        employeeName: json["employee_name"] ?? "",
        startDate: DateTime.parse(json["start_date"]),
        endDate: DateTime.parse(json["end_date"]),
        status: json["status"] ?? "",
      );
}
```

**DataSource:** `lib/src/leave_requests/data/datasource/leaves_remote_datasource.dart`
```dart
import 'package:attendance/core/config/mixins/network_handler.dart';
import 'package:attendance/core/constants/network_constants.dart';
import 'package:attendance/src/leave_requests/data/models/leave_request_model.dart';
import 'package:attendance/src/leave_requests/domain/entity/leave_request.dart';
import 'package:dio/dio.dart';

class LeavesRemoteDataSrcImpl
    with NetworkCallHandler
    implements LeavesRemoteDataSrc {
  const LeavesRemoteDataSrcImpl(this._dio);

  final Dio _dio;

  @override
  Future<List<LeaveRequest>> getPendingLeaves() async {
    final header = await NetworkConstants.getHeaders();

    return handleNetworkCall<List<LeaveRequest>>(
      call: () => _dio.get(
        '${NetworkConstants.url}/leaves/pending',
        options: Options(headers: header),
      ),
      onSuccess: (response) {
        final data = response.data[NetworkConstants.dataParam] as List;
        return data.map((item) => LeaveRequestModel.fromJson(item)).toList();
      },
    );
  }

  @override
  Future<String> updateStatus({
    required int leaveId,
    required String status,
  }) async {
    final header = await NetworkConstants.getHeaders();

    return handleNetworkCall<String>(
      call: () => _dio.put(
        '${NetworkConstants.url}/leaves/$leaveId/status',
        options: Options(headers: header),
        data: {"status": status},
      ),
      onSuccess: (response) => "",
    );
  }
}

abstract class LeavesRemoteDataSrc {
  Future<List<LeaveRequest>> getPendingLeaves();
  Future<String> updateStatus({required int leaveId, required String status});
}
```

**Repository:** `lib/src/leave_requests/data/repo/leaves_repo_impl.dart`
```dart
import 'package:attendance/core/config/mixins/error_handler.dart';
import 'package:attendance/core/config/typedefs.dart';
import 'package:attendance/src/leave_requests/data/datasource/leaves_remote_datasource.dart';
import 'package:attendance/src/leave_requests/domain/entity/leave_request.dart';
import 'package:attendance/src/leave_requests/domain/repo/leave_request_repo.dart';

class LeaveRequestRepoImpl with ErrorHandler implements LeaveRequestRepo {
  const LeaveRequestRepoImpl(this._remoteDataSource);

  final LeavesRemoteDataSrc _remoteDataSource;

  @override
  ResultFuture<List<LeaveRequest>> getPendingLeaves() async {
    return handleRepoCall(() => _remoteDataSource.getPendingLeaves());
  }

  @override
  ResultFuture<String> updateStatus({
    required int leaveId,
    required String status,
  }) async {
    return handleRepoCall(
      () => _remoteDataSource.updateStatus(leaveId: leaveId, status: status),
    );
  }
}
```

### 3. Presentation Layer

**State:** `lib/src/leave_requests/presentation/app/pending_leaves_cubit/pending_leaves_state.dart`
```dart
part of 'pending_leaves_cubit.dart';

@freezed
sealed class PendingLeavesState with _$PendingLeavesState {
  const factory PendingLeavesState.initial() = _initialState;

  const factory PendingLeavesState.loading() = _loadingState;

  const factory PendingLeavesState.failed({required String message}) =
      _failedState;

  const factory PendingLeavesState.success({
    required List<LeaveRequest> leaves,
  }) = _successState;
}
```

**Cubit:** `lib/src/leave_requests/presentation/app/pending_leaves_cubit/pending_leaves_cubit.dart`
```dart
import 'package:attendance/core/config/mixins/failure_popups.dart';
import 'package:attendance/core/utils/util_functions.dart';
import 'package:attendance/src/leave_requests/domain/entity/leave_request.dart';
import 'package:attendance/src/leave_requests/domain/usecases/get_pending_leaves.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'pending_leaves_state.dart';
part 'pending_leaves_cubit.freezed.dart';

class PendingLeavesCubit extends Cubit<PendingLeavesState> with FailurePopups {
  final GetPendingLeavesUsecase _getPendingLeavesUsecase;

  PendingLeavesCubit({required GetPendingLeavesUsecase getPendingLeavesUsecase})
      : _getPendingLeavesUsecase = getPendingLeavesUsecase,
        super(PendingLeavesState.initial());

  Future<void> getPendingLeaves() async {
    UtilFunctions.appLog("getPendingLeaves:");
    emit(PendingLeavesState.loading());

    final result = await _getPendingLeavesUsecase();

    result.fold(
      (failure) {
        emit(PendingLeavesState.failed(message: failure.message));
      },
      (leaves) {
        emit(PendingLeavesState.success(leaves: leaves));
      },
    );
  }
}
```

### 4. Dependency Injection

In `lib/core/services/injection_container.main.dart`:
```dart
Future<void> _leavesInit() async {
  sl
    ..registerLazySingleton(() => GetPendingLeavesUsecase(sl()))
    ..registerLazySingleton(() => UpdateLeaveStatusUsecase(sl()))
    ..registerLazySingleton<LeaveRequestRepo>(
      () => LeaveRequestRepoImpl(sl()),
    )
    ..registerLazySingleton<LeavesRemoteDataSrc>(
      () => LeavesRemoteDataSrcImpl(sl()),
    );
}
```

Add to `splashInit()`:
```dart
await Future.wait([
  // ... other inits
  _leavesInit(),
]);
```

### 5. Generate Freezed Code
```bash
dart run build_runner build --delete-conflicting-outputs
```

---

## Quick Reference Checklist

When creating a new feature, follow this checklist:

### Domain Layer
- [ ] Create entities in `domain/entity/`
- [ ] Create repository interface in `domain/repo/`
- [ ] Create use cases in `domain/usecases/`

### Data Layer
- [ ] Create models in `data/models/` (extend entities, add `fromJson`)
- [ ] Create remote datasource in `data/datasource/` (with abstract interface)
- [ ] Create repository implementation in `data/repo/` (implements domain repo)

### Presentation Layer
- [ ] Create cubit state in `presentation/app/{cubit_name}_cubit/`
- [ ] Create cubit in `presentation/app/{cubit_name}_cubit/`
- [ ] Run build_runner to generate freezed code
- [ ] Create views in `presentation/view/`
- [ ] Create widgets in `presentation/widgets/`

### Dependency Injection
- [ ] Register datasource in injection container
- [ ] Register repository in injection container
- [ ] Register use cases in injection container
- [ ] Call init function in `splashInit()`

### Final Steps
- [ ] Provide cubit in view using `BlocProvider`
- [ ] Test all states (initial, loading, success, failed)
- [ ] Verify error handling works correctly

---

## Summary

This architecture provides:
- **Separation of Concerns:** Each layer has a clear responsibility
- **Testability:** Easy to mock and test each layer independently
- **Maintainability:** Changes in one layer don't affect others
- **Scalability:** Easy to add new features following the same pattern
- **Error Handling:** Consistent error handling throughout the app
- **Type Safety:** Using Either type for error handling
- **Immutability:** Using Freezed for state management

Follow these guidelines and templates to maintain consistency across the codebase and make it easy for both humans and AI to understand and extend the application.