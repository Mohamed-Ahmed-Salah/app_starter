# App Starter

Flutter app template: clean architecture, `flutter_bloc` cubits, `get_it` + `injectable`,
`fpdart`, `freezed`, `dio`, `go_router`, Firebase (analytics, crashlytics, messaging, remote
config). Two flavors, `dev` and `prod`. English and Arabic out of the box.

Claude Code is set up for this repo: `CLAUDE.md` routes to the skills in `.claude/skills/`
and the reference tables in `docs/claude-reference/`. Read those before changing anything.

## First-time setup

1. **Rename.** `name:` in `pubspec.yaml`, then every `package:app_starter/` import
   (`grep -rl "package:app_starter" lib test`). Android `namespace` / iOS bundle come from
   the next step.
2. **Flavors.** Fill every `CHANGE_ME` in the `flavorizr:` block of `pubspec.yaml` (app
   name, application/bundle ids, 1024x1024 icons under `assets/logo/`), then generate the
   native side:
   ```bash
   dart run flutter_flavorizr
   ```
3. **Firebase.** One project per flavor:
   ```bash
   flutterfire configure --project=<dev-project>  --out=lib/firebase_options_dev.dart
   flutterfire configure --project=<prod-project> --out=lib/firebase_options_prod.dart
   ```
   The checked-in files are stubs that throw until replaced.
4. **API.** Point `devUrl` / `prodUrl` in `lib/core/constants/network_constants.dart` at the
   backend, and the links in `lib/core/constants/text_constants.dart` at the product's pages.
5. **Brand.** Colours in `lib/core/res/colours.dart`, font family in
   `lib/core/config/app_theme_config.dart` (declare it under `flutter: fonts:`), icon font in
   `assets/fonts/app_icons.ttf` + `lib/core/res/app_icons.dart`, logo via `Media.appLogoImg`.
6. **Generate and run.**
   ```bash
   flutter pub get
   dart run build_runner build      # freezed states + injectable DI
   flutter gen-l10n                 # lib/l10n/*.arb → AppLocalizations
   flutter run --flavor dev
   ```

## Layout

```
lib/
├── main.dart                 providers → MaterialApp.router, locale from AppLanguageCubit
├── flavors.dart              F.appFlavor, baseUrl, firebaseOptions per flavor
├── core/                     shared code — see docs/claude-reference/codebase-map.md
│   ├── config/               theme, typedefs, usecase bases, extensions on Dart/Flutter types
│   ├── constants/            network, text, size tokens (spacing + radii only)
│   ├── errors/               exceptions (data layer throws) and failures (domain returns)
│   ├── mixins/               NetworkCallHandler, ErrorHandler
│   ├── monitoring/           analytics client/facade, crash logger, route observer
│   ├── network/              auth + logging interceptors
│   ├── providers/            app-wide BlocProvider registries
│   ├── res/                  Colours, Media, AppIcons
│   ├── services/             DI (injection_container + register_module), cache, push, …
│   └── utils/                validators, toasts, LocalizedText
├── l10n/                     app_en.arb, app_ar.arb (+ generated)
└── src/<feature>/            data/ domain/ presentation/
```

Reference feature: **`src/products/`** — every layer end to end with the DI annotations.
Copy its shape. `src/language/` shows an app-wide cubit driving `MaterialApp.locale`.

## Boot flow

`main()` → `init()` sets the flavor, initialises Firebase and runs the generated DI init →
`SplashView` → `AppRedirectionBloc` runs `splashInit()` (push, crash reporting, remote
config), checks the remote-config minimum version, then routes to **force update**,
**onboarding** (first launch), **home** (session token present) or **login**.

## Dependency injection

Annotate the class, run `build_runner`, resolve with `sl<T>()`:

| Layer | Annotation |
|---|---|
| datasource / repo impl | `@LazySingleton(as: Interface)` |
| usecase | `@lazySingleton` |
| cubit | `@injectable` (fresh per screen) |
| third-party / async / hand-built | a member of `RegisterModule` |

Details in `docs/claude-reference/di-checklist.md`.

## Placeholders to replace

- `src/home`, `src/auth/…/login_view.dart`, `src/onboarding` — minimal screens.
- `src/products` — reference feature; delete once a real one exists.
- `assets/imgs/placeholder_*.png`, `assets/logo/app_icon_*.png` — swap for real artwork.
- `other_core_files/` — the pre-rebuild core, kept for reference only. Delete when done.

## Commands

See `docs/claude-reference/commands.md`. Short version: `flutter analyze` must report zero
errors; `dart run build_runner build` after touching a state class or a DI annotation;
`flutter gen-l10n` after editing an ARB file.
