# API Contract

Base URLs live in `lib/core/constants/network_constants.dart` (`devUrl`, `prodUrl`),
selected per flavor by `F.baseUrl` in `lib/flavors.dart`. Replace the `example.com`
placeholders before the first real call.

## Response envelope

Every JSON response is unwrapped through the key constants in `NetworkConstants` — use the
constants, never string literals:

```dart
NetworkConstants.successParam    // "success"
NetworkConstants.dataParam       // "data"
NetworkConstants.messageParam    // "message"
NetworkConstants.errorsListParam // "errors"
NetworkConstants.statusCode      // "status"
```

Shape the mixins expect:

```json
{ "success": true,  "data": { ... }, "message": "..." }
{ "success": false, "data": { "errors": ["..."] }, "message": "...", "status": 422 }
```

Payload is always under `data`. If the backend uses a different envelope, change the
constants and `handleNetworkCall` / `_handleDioException` in
`lib/core/mixins/network_handler.dart` **once** — never special-case a datasource.

`handleNetworkCall` treats a response as successful when `success == true` **or** the HTTP
status is 200/201, then runs your `onSuccess`. A throw inside `onSuccess` is caught and
re-thrown as `FormatParserException`, so parsing bugs surface as parse failures, not
server errors.

## Auth

`AuthInterceptor` (`lib/core/network/auth_interceptor.dart`) is registered on the shared
`Dio` in `RegisterModule.dio` (`lib/core/services/register_module.dart`). It injects on
**every** request:

- `Authorization: Bearer <token>` — from `CacheService.getSessionToken()`, only when non-empty
- `language` — from `CacheService.getLanguage()`

Do not set these headers manually in a datasource; they are already applied. A login
datasource stores the token with `CacheService.cacheSessionToken()`; nothing else touches it.

A `401` throws `UnauthenticatedException` **and** calls
`AuthEventHandlerService.handle401Error()`, which runs `LogoutService` and `go`es to
`LoginView`. Don't add your own 401 handling on top of it. A request sent without a token
(guest) is ignored by the handler, so public endpoints can 401 harmlessly.

## Error mapping

Datasources throw exceptions; `handleRepoCall` (the `ErrorHandler` mixin) converts each to
its matching failure. Cubits only ever see `Failure`.

| Exception | Failure | Raised when |
|---|---|---|
| `ServerException` | `ServerFailure` | `success: false`, or an unmapped error |
| `UnauthenticatedException` | `UnauthenticatedFailure` | HTTP 401 |
| `GeneralException` | `GeneralFailure` | `success: false` or `data.errors` present — carries `errors: List<String>` |
| `NoInternetException` | `NoInternetFailure` | Socket error with no response |
| `TimeOutException` | `TimeOutFailure` | Connection timeout / connection error |
| `FormatParserException` | `FormatParserFailure` | `onSuccess` threw while parsing |
| `AuthException` | `AuthFailure` | Third-party sign-in errors (Firebase Auth, social) |
| `AuthCancelledByUserException` | `AuthCancelledByUserFailure` | User dismissed a sign-in sheet |

`GeneralFailure` is the one to surface field-level validation messages from — it's the only
failure carrying the `errors` list. `failure.getFailureMessage(context)` renders any of
them for the UI.

## Pagination

Default page size is `NetworkConstants.pageSize` (10). Add a `Paginated<T>` wrapper in
`core/config/` when the first paged endpoint lands, and parse `meta` there — not per
datasource.

## Endpoint inventory

Keep this section in sync with the `*_remote_datasrc_impl.dart` files: one table per
feature, `$x` for a path segment interpolated from a Dart variable. Request/response
shapes are **not** listed — read the datasource's `onSuccess` for the exact parse.

### products — `lib/src/products/data/datasources/products_remote_datasrc_impl.dart`
| Method | Path | Returns |
|---|---|---|
| GET | `/products` | `List<Product>` from `data` — reference feature, replace with the real one |
