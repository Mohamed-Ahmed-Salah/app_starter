# Codebase Map

Landmarks in `lib/core/`, so shared pieces get reused instead of reinvented.

## Contracts — reach for these first

| Need | Use | Where |
|---|---|---|
| Repo/usecase return type | `ResultFuture<T>` = `Future<Either<Failure, T>>` | `core/config/typedefs.dart` |
| Usecase base class | `UsecaseWithParams<Return, Params>`, `UsecaseWithoutParams<Return>`, `StreamUsecaseWithoutParams<Return>` | `core/config/usecase.dart` |
| Wrap an HTTP call | `handleNetworkCall<T>({call, onSuccess})` — mixin `NetworkCallHandler` | `core/mixins/network_handler.dart` |
| Wrap a datasource call | `handleRepoCall<T>(() => ...)` — mixin `ErrorHandler` | `core/mixins/error_handler.dart` |
| Exceptions (data layer throws) | `ServerException`, `GeneralException`, … | `core/errors/exceptions.dart` |
| Failures (domain layer returns) | `ServerFailure`, `GeneralFailure`, … | `core/errors/failures.dart` |
| Error copy / status codes | `ErrorConst` | `core/errors/error_const.dart` |
| Render a `Failure` in the UI | `failure.getFailureMessage(context)` — `FailureExtension` | `core/config/extentions/failure_extension.dart` |

Only two `Either` states ever cross a layer boundary: `Left(Failure)` and `Right(T)`.
A datasource **throws**; a repo **returns** `Either`. Never let an exception escape a repo.

## Services

| Thing | Where |
|---|---|
| Token + prefs + language cache | `core/services/cache_service.dart` |
| DI container (`sl`) | `core/services/injection_container.dart`; registrations generated into `injection_container.config.dart` by `injectable` |
| Third-party / hand-built registrations | `core/services/register_module.dart` (the one `@module`) |
| Global logout | `core/services/logout_service.dart` |
| 401 → logout/redirect | `core/services/auth_event_handler_service.dart` |
| Dio + interceptor setup | `RegisterModule.dio` in `core/services/register_module.dart`, `core/network/auth_interceptor.dart` |
| Remote config, analytics, in-app review | `core/services/` |
| Crash/error logging | `core/monitoring/firebase_error_logger_service.dart` |

`CacheService` is the only thing that should touch `SharedPreferences` / secure storage.
Session token: `cacheSessionToken()` / `getSessionToken()`.

## UI

| Thing | Where |
|---|---|
| Colours | `core/res/colours.dart` |
| Images & icon constants | `core/res/media.dart` |
| Icon font glyphs | `core/res/app_icons.dart` (one glyph — extend from your own IcoMoon set) |
| Shared widgets | `core/widgets/` (not created yet — add on first shared widget) |
| Theme | `core/config/app_theme_config.dart` |
| Routes | `core/router.dart` |
| Enums | `core/config/enums.dart` |
| App-wide extensions (`BuildContext`, `DateTime`, `String`, `num`, `Failure`) | `core/config/extentions/` (note: spelled "extentions") |
| Entity / enum extensions (label, colour, icon, derived values) | `src/<feature>/domain/entities/extensions/<entity>_extension.dart` — never in `core/` |
| Date formatting / parsing | `dayMonth`, `dayMonthYear`, `weekdayDayMonth`, `String?.asDate` — `core/config/extentions/date_extension.dart` |
| Validators | `core/utils/form_validations.dart` |
| Logging helper | `UtilFunctions.appLog(...)` in `core/utils/util_functions.dart` |

Sizing uses `flutter_screenutil` — scale with `.w` / `.h` / `.sp` / `.r`, don't hardcode.
Strings are localized: ARB files in `lib/l10n/`, template `app_en.arb`.

## Feature layout

Features live in `lib/src/<feature>/` with `data/` `domain/` `presentation/`. The
`flutter-clean-arch` skill covers the structure and build order.

**Canonical example: `lib/src/products/`** — every layer of one feature end to end
(entity + extension, repo interface, usecase, model, datasource interface/impl, repo impl,
freezed cubit, view, widget) with the `injectable` annotations in place. Copy its shape.

`splash` carries the real boot flow: `AppRedirectionBloc` runs `splashInit()`, checks the
remote-config minimum version, then routes to force-update / onboarding / home / login.
`home`, `auth/login`, `onboarding` and `force_update` are minimal screens to replace.

Use `presentation/view/` (singular) for new features.

## Flavors

`lib/flavors.dart` — `Flavor.dev | prod`, with `F.appFlavor` set during `init()`
from Flutter's built-in `appFlavor`. Per-flavor Firebase options in
`lib/firebase_options_<flavor>.dart` — the checked-in ones are stubs that throw; overwrite
them with `flutterfire configure` output. Native flavors come from the `flavorizr:` block in
`pubspec.yaml` (`dart run flutter_flavorizr`). See `commands.md` to run one.
