# Gotchas

Snapshot of things that will surprise you in the code as it stands. Unlike the other files
here, entries are expected to expire — delete one once it stops being true.

Rules to follow live in the other reference files and the skills; this file is only for
"the code does something you wouldn't predict."

---

## The app cannot launch until Firebase and flavors are configured — snapshot 2026-09-05

`lib/firebase_options_dev.dart` / `_prod.dart` are stubs that **throw** from
`currentPlatform`, so `init()` fails at `F.initializeFirebaseApp()`. And `--flavor dev`
selects nothing on the native side until `dart run flutter_flavorizr` has run. Both steps
are in `README.md`; delete this entry once they're done.

---

## A missing `injectable` annotation compiles fine

`sl<T>()` and constructor parameters resolve at runtime, so a class you forgot to annotate
(or annotated but never re-ran `dart run build_runner build` for) still passes
`flutter analyze`. It throws at first resolution — when the screen opens. See
[di-checklist.md](di-checklist.md).

Constructor changes are the opposite: the generated `injection_container.config.dart`
goes stale and the analyzer flags it, so those cannot be missed.

---

## `sl<Impl>()` throws when the impl is registered `as:` its interface

`@LazySingleton(as: SomeRepo)` registers the type `SomeRepo`, not `SomeRepoImpl`. Resolve
and inject by the interface.

---

## Registrations are lazy; construction order is not yours to pick

`configureDependencies()` awaits the `@preResolve` entries (SharedPreferences) and then
registers everything else lazily, in dependency order the generator chose. Never do
eager cross-service work in a constructor. `Dio` is the one `@singleton` — it is built
during `init()` because it reads `F.baseUrl`, which is why the flavor is set first.

---

## `whenOrNull` inside an arrow-bodied listener trips a lint

`listener: (_, state) => state.whenOrNull(...)` makes Dart infer the callbacks' return type
as `Object?`, and every block-bodied callback then warns
`body_might_complete_normally_nullable`. Use a block-bodied listener and call `whenOrNull`
as a statement (see `splash_view.dart`).

---

## Spelling to match, not fix

`lib/core/config/extentions/` is misspelled. Match it in imports; renaming it is a separate,
deliberate change. The per-feature folder is spelled correctly:
`lib/src/<feature>/domain/entities/extensions/`.
