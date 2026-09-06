# App Starter

Flutter app starter. Clean architecture, `flutter_bloc` (cubits), `get_it` + `injectable`,
`fpdart`, `freezed`, `dio`, `go_router`, Firebase. Two flavors: `dev` / `prod`; `en` / `ar`.
Features live in `lib/src/<feature>/{data,domain,presentation}`; shared code in `lib/core/`.
Reference feature: `lib/src/products/`. First-time setup (flavorizr, flutterfire, rename)
is in `README.md`.

## Read before doing

This file routes; it does not contain the rules. Open the matching source before you start —
it is not optional reading, and it is more current than anything summarised here.

| Doing this | Read first |
|---|---|
| Implementing a feature, usecase, repo, or cubit | skill `flutter-clean-arch` |
| Building or reviewing UI | skill `flutter-ui-guidelines` |
| Adding or changing analytics tracking | skill `analytics-tracking` |
| Adding or changing an API call | [docs/claude-reference/api-contract.md](docs/claude-reference/api-contract.md) |
| Registering a dependency | [docs/claude-reference/di-checklist.md](docs/claude-reference/di-checklist.md) |
| Reaching for anything in `core/` | [docs/claude-reference/codebase-map.md](docs/claude-reference/codebase-map.md) |
| Running, building, codegen, analyzing | [docs/claude-reference/commands.md](docs/claude-reference/commands.md) |
| Anything non-trivial | [docs/claude-reference/gotchas.md](docs/claude-reference/gotchas.md) |
| **Finishing — before reporting a task done** | [docs/claude-reference/self-review.md](docs/claude-reference/self-review.md) |
| **Committing — writing a message, or splitting work into commits** | skill `smart-commits` |

## Working agreements

- Commit messages: no `Co-Authored-By` trailer. Show the message for review before committing.
- Plans, reviews, and bug write-ups go in `docs/claude-plans|claude-review|claude-bugs/`.
