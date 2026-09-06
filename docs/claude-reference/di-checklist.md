# DI Checklist

How to register a dependency in this project. Follow this; don't copy what a nearby file
happens to do.

## The rule

**Annotate once. Generate. Resolve everywhere else.**

A type is constructed in exactly one place — the generated registration. Every other
reference pulls it with `sl<T>()` or takes it as a constructor parameter. Never
hand-construct a registered type a second time.

`injectable` reads annotations from every file under `lib/` and writes
`lib/core/services/injection_container.config.dart`. That file is generated — never edit
it, and never write a `register*` call by hand.

## Adding a dependency

### 1. Annotate — in the class's own file

```dart
import 'package:injectable/injectable.dart';

@LazySingleton(as: SomeRemoteDataSrc)          // datasource impl: as its interface
class SomeRemoteDataSrcImpl implements SomeRemoteDataSrc { ... }

@LazySingleton(as: SomeRepo)                   // repo impl: as its interface
class SomeRepoImpl implements SomeRepo { ... }

@lazySingleton                                 // usecase: concrete
class SomeUsecase { ... }

@injectable                                    // cubit: fresh per resolution
class SomeCubit extends Cubit<SomeState> { ... }
```

- Impls of an interface use `@LazySingleton(as: Interface)`. Parameters typed as the
  interface then resolve to the impl; `sl<SomeRepo>()` works, `sl<SomeRepoImpl>()` throws.
- Usecases, repos, datasources → lazy singletons.
- Cubits → `@injectable`, so each screen gets a fresh instance. Use `@lazySingleton` only
  when the cubit deliberately holds state across screens.
- Constructor parameters are resolved by **type**, positional or named — no `sl()` inside
  a constructor, no manual wiring.

### 2. Generate

```bash
dart run build_runner build
```

Rerun after adding, removing, or re-annotating a class, or after changing an annotated
class's constructor signature. Not needed for body-only edits.

### 3. Provide — `lib/core/providers/<feature>_providers.dart` (app-wide cubits only)

```dart
BlocProvider<SomeCubit>(create: (_) => sl<SomeCubit>()),
```

That's the whole entry. Screen-scoped cubits are provided by the screen
(`create: (_) => sl<SomeCubit>()`) — see the `flutter-clean-arch` skill.

**Exception:** a cubit that needs a *sibling cubit* from `context` can't come from `get_it`
— build it inline where the sibling is in scope, and annotate only its usecases.

## Third-party and hand-built types — `register_module.dart`

`SharedPreferences`, `FlutterSecureStorage`, `Dio` (with its interceptors), `InAppReview`,
and the `AnalyticsFacade` (which takes a *list* of clients) live in the single `@module`
class `RegisterModule`. Add there only what an annotation on our own class cannot express:

- a type we don't own,
- async construction (`@preResolve` on a `Future` getter — awaited before the rest of the
  graph is built),
- an argument that has to be assembled by hand.

Adding an analytics provider means annotating the new client `@lazySingleton` **and**
adding it to the list in `RegisterModule.analyticsFacade`.

## The one hazard

**A missing annotation compiles.** `sl<T>()` and constructor parameters look identical
whether or not `T` was ever registered. The generator only warns when an annotated class
*depends on* something unregistered; a class nobody annotated is invisible to it. The
failure is at first resolution — when the screen opens.

So after adding a **new** type: check its annotation, run the build, then grep the
generated file for the class name and open the screen once.

Constructor changes are the opposite and need no vigilance: the generated file is
rebuilt from the signature, and a stale build shows up as a hard analyzer error in
`injection_container.config.dart`.

## Startup order

`init()` in `injection_container.dart` sets `F.appFlavor`, then runs Firebase init and
`configureDependencies()` together. `@preResolve` entries (SharedPreferences) are awaited
first; everything else is lazy, so a service must not do eager cross-service work in its
constructor. Push, crash reporting and remote config start later, in `splashInit()`.
