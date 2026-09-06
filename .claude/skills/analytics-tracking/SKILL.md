---
name: analytics-tracking
description: Add click and action tracking to a feature module — declaring a typed event method on AnalyticsClient, implementing it in each analytics provider, fanning it out through AnalyticsFacade, and placing the unawaited call in cubits, buttons, tabs, sheets and pagers. Use when adding or changing analytics in a module under lib/src/, adding a tracked event, or adding a new analytics provider.
---

# Analytics Tracking Skill

You are adding analytics to **one module at a time**. Your job is to find the interactions that
carry user intent, declare each one as a named, typed method on `AnalyticsClient`, and fire it so
it can never slow down or break the screen it came from.

## When to Use This Skill

- Adding tracking to a module under `lib/src/` that has none yet.
- Adding one tracked action to a module that is already covered.
- Adding a new analytics provider (Mixpanel, Amplitude, Meta) alongside Firebase.

## How tracking is structured here

Three files in `lib/core/monitoring/`, each with one job:

| File | Job |
|---|---|
| `analytics_client.dart` | **The inventory.** One typed method per event. Open this file and you know everything the app monitors. |
| `firebase_analytics_client.dart` | Firebase's implementation, in Firebase's own terms. |
| `analytics_facade.dart` | Fans one typed call out to every registered provider. |

**Why one method per event rather than a generic `logEvent(name, params)`:** because the typed
method is the seam that lets each provider speak its own dialect. `FirebaseAnalyticsClient` can
call `logAddToCart(items: …, value: …, currency: …)` — the native commerce API that populates
GA4's shopping reports — while a future `MixpanelAnalyticsClient` calls `track('Add To Cart', …)`
with Mixpanel's Title Case naming. Neither is reachable through a string and a map.

So: **never add a generic event method, and never route a new event through an existing one.**
An event that has no method has no home. Add the method.

The method name is *our* domain language. The event name string inside each provider is *that
provider's* language. Translating between them is the adapter's entire job:

```
trackProductAddedToCart(...)   →  Firebase:  'add_to_cart'      (GA4 standard name)
                               →  Mixpanel:  'Add To Cart'      (Mixpanel convention)
```

### Before you start — one open safety issue

`AnalyticsFacade._dispatch` has no `try`/`catch`. Because tracking calls are `unawaited`, a
provider that throws produces an unhandled async error, which reaches
`PlatformDispatcher.instance.onError` and is recorded to Crashlytics as **fatal** — an analytics
hiccup reported as a crash. Wrapping the loop body in `try`/`catch` is a three-line fix, but it
touches core: **flag it to the user before your first module lands.** Do not fix it silently.

---

## Implementation Pattern

### 1. Decide what the module tracks

Two passes. Run both — the second is the one people forget.

**Pass A — cubits.** Every public method on every cubit in
`lib/src/{module}/presentation/app/` is a candidate action.

**Pass B — everything that is not a cubit.** Several screens in this app have no cubit at all
(`onboarding`, `force_update`, `language`), and every screen has taps that never reach one:

```bash
grep -rn "onTap:\|onPressed:\|onChanged:\|onPageChanged:\|onSubmitted:" lib/src/{module}/
grep -rn "TabController\|showModalBottomSheet\|ValueNotifier\|animateToPage" lib/src/{module}/
```

Now cut. **Aim for 8–20 events per module.** Keep an interaction if it answers a question someone
would actually ask: does this drive a purchase, a signup, a navigation, a filter, or an abandon?
Drop pure chrome — back buttons, scroll position, expanding a FAQ, dismissing a toast.

### 2. Name the method and shape its params

**Naming** follows the methods already in the file — `track` + subject + past-tense verb:

```
trackOnboardingSkipped        ← existing
trackProductAddedToCart
trackProductRemovedFromCart
trackCheckoutStarted
trackOrderPlaced
trackProductViewed
trackSearchSubmitted
trackFilterApplied
trackTabSelected
```

Not `trackAddToCart` (that is the wire name, not ours) and not `trackCart` (says nothing).

**Params are named, `required`, and primitives only** — `String`, `int`, `double`, `bool`, or an
enum defined in `core/`. Never a `Product`, `Order`, `Cart` or any other entity:

```dart
// ✅ core stays independent of features
Future<void> trackProductAddedToCart({
  required String productSlug,
  required String productName,
  required int quantity,
  required double value,
  required String currency,
});

// ❌ drags lib/src/products into lib/core, and every provider now depends on it
Future<void> trackProductAddedToCart({required Product product, required int quantity});
```

`lib/core/monitoring/` must not import from `lib/src/`. The call site does the unwrapping —
`product.slug`, `product.price` — which also means a module agent never adds an import to core.

**Optional params** are `nullable with a default`, not `required`. Use them for genuinely
optional context (`String? couponCode`), never to make a required field skippable.

**Never accept, and never pass:** email, phone, full name, address lines, national or KYC document
numbers, auth tokens, OTPs, card numbers, IBANs, or raw exception messages. This app handles auth,
addresses, KYC uploads, wallets and payouts — the risk is real. Pass ids, slugs, enum names,
counts and amounts. A search term is the one user-typed value that is fine to send.

### 3. Add it to the three files, in this order

The analyzer walks you through it: declare it, and every missing implementation is a hard error.

#### 3a. `analytics_client.dart` — the declaration

Add it under its module's section header, creating the header if the module has none. **These
headers are the coverage map** — a module with no section has no tracking yet.

```dart
abstract class AnalyticsClient {
  Future<void> identifyUser(String userId);

  Future<void> resetUser();

  Future<void> trackScreenView(
    String routeName,
    String action,
    Map<String, Object?>? args,
  );

  // ── onboarding ────────────────────────────────────────────────────────
  /// Fired once on first launch — represents both app download and onboarding start.
  Future<void> trackOnboardingStart({required String deviceId});
  ...

  // ── cart ──────────────────────────────────────────────────────────────
  /// Fired after the add-to-cart request succeeds, not when the button is tapped.
  Future<void> trackProductAddedToCart({                       // ✅ 1. declare
    required String productSlug,
    required String productName,
    required int quantity,
    required double value,
    required String currency,
  });
}
```

Give each method a one-line doc comment saying **when it fires** — especially whether it is on
intent or on success. That comment is what stops the same event being fired from two places six
months from now.

#### 3b. `firebase_analytics_client.dart` — the implementation

Use Firebase's **native API** when one exists for this event; those populate GA4's built-in
reports. Fall back to `logEvent` with a GA4 standard name, and only then to a custom name.

```dart
@override
Future<void> trackProductAddedToCart({                         // ✅ 2. implement
  required String productSlug,
  required String productName,
  required int quantity,
  required double value,
  required String currency,
}) async {
  await _analytics.logAddToCart(
    items: [
      AnalyticsEventItem(
        itemId: productSlug,
        itemName: productName,
        quantity: quantity,
      ),
    ],
    value: value,
    currency: currency,
  );
}
```

When there is no native call, use `logEvent` and route the params through `_sanitizeParams` —
Firebase accepts only `String` and `num`, and silently drops everything else in release:

```dart
@override
Future<void> trackFilterApplied({
  required String screen,
  required int filterCount,
  String? brandSlug,
}) async {
  await _analytics.logEvent(
    name: 'filter_applied',
    parameters: _sanitizeParams({
      'screen': screen,
      'filter_count': filterCount,
      'brand_slug': brandSlug,                                 // null is dropped
    }),
  );
}
```

Wire names are `snake_case`, ≤40 chars, and never prefixed `firebase_` / `google_` / `ga_`.

If a second provider exists, implement the method there too, in that provider's idiom.

#### 3c. `analytics_facade.dart` — the fan-out

Mechanical, and the compiler catches any mismatch:

```dart
@override
Future<void> trackProductAddedToCart({                         // ✅ 3. fan out
  required String productSlug,
  required String productName,
  required int quantity,
  required double value,
  required String currency,
}) => _dispatch(
  (c) => c.trackProductAddedToCart(
    productSlug: productSlug,
    productName: productName,
    quantity: quantity,
    value: value,
    currency: currency,
  ),
);
```

Never put logic here. The one exception already in the file — `trackScreenView` dropping `pop` —
is a filter that applies to every provider equally. Provider-specific behaviour belongs in that
provider's client.

### 4. Place the call

**Every call is `unawaited`.** Analytics must never sit in front of an `emit`, a navigation, or a
`setState`:

```dart
import 'dart:async';                                           // for unawaited
```

| You are in… | Call it as |
|---|---|
| a **cubit** | `unawaited(_analytics.trackX(...))` — inject `AnalyticsFacade` |
| **anything else** — widget, view, tab controller, sheet, callback | `unawaited(sl<AnalyticsFacade>().trackX(...))` |

Where exactly:

| Surface | Where the call goes |
|---|---|
| Cubit, backend outcome | Inside `fold`'s **success** callback, before `emit` |
| Cubit, local-only change | Immediately before `emit` |
| Button / tile / chip `onTap` | First line of the callback, before navigation |
| `TabBar` / `TabController` | In `onTap:`, or in the listener guarded by `!indexIsChanging` |
| Bottom nav | In the shell view's `_goBranch`, before `goBranch` |
| `PageView` | In `onPageChanged`, or when the page **settles** for a `ValueNotifier` pager |
| Modal sheet | "opened" inside the static `show()`; the outcome at the **caller**, after the `await`, branching on `null` = dismissed |
| `ValueNotifier` / `setState` selection | In the setter, and only when the value actually changed |
| **Screen views** | **Nowhere.** `MyGoRouterObserver` already emits one per navigation. |

#### 4a. Cubit — after success, before emit

Inject the facade like any other dependency:

```dart
class AddToCartCubit extends Cubit<AddToCartState> {
  final AddToCartUsecase _addToCartUsecase;
  final AnalyticsFacade _analytics;                            // ✅ 1. field

  AddToCartCubit({
    required AddToCartUsecase addToCartUsecase,
    required AnalyticsFacade analytics,                        // ✅ 2. named required
  })  : _addToCartUsecase = addToCartUsecase,
        _analytics = analytics,
        super(AddToCartState.initial());

  Future<void> addToCart(Product product, int quantity) async {
    UtilFunctions.appLog('addToCart:');
    emit(AddToCartState.loading());
    final result = await _addToCartUsecase(...);
    result.fold(
      (failure) => emit(AddToCartState.failed(failure: failure)),
      (_) {
        unawaited(                                             // ✅ 3. success only
          _analytics.trackProductAddedToCart(
            productSlug: product.slug,
            productName: product.name,
            quantity: quantity,
            value: product.price * quantity,
            currency: product.currency,
          ),
        );
        emit(AddToCartState.success(product: product));
      },
    );
  }
}
```

Then add the argument wherever that cubit is constructed:

```dart
// Annotated cubits — the generated registration picks the new parameter up
// by type; just rerun `dart run build_runner build`.
@injectable
class SomeCubit extends Cubit<SomeState> {
  SomeCubit({required SomeUsecase someUsecase, required AnalyticsFacade analytics})  // ✅

// Cubits built inline because they need a sibling cubit from context —
// see docs/claude-reference/di-checklist.md.
SomeCubit(someUsecase: sl(), analytics: sl<AnalyticsFacade>())                // ✅
```

`AnalyticsFacade` is registered by concrete type from `RegisterModule.analyticsFacade`, so a
bare `sl()` or a typed constructor parameter resolves it. There is no `AnalyticsClient`
registration — `sl<AnalyticsClient>()` throws. A new provider is annotated
`@lazySingleton` and added to the list in `RegisterModule.analyticsFacade`.

#### 4b. Button, tile, chip

```dart
ProductCardWidget(
  onTap: () {
    unawaited(                                                 // ✅ before navigating
      sl<AnalyticsFacade>().trackProductSelected(
        productSlug: product.slug,
        listName: 'best_sellers',
        index: index,
      ),
    );
    context.pushNamed(
      ProductDetailView.name,
      pathParameters: {'slug': product.slug},
    );
  },
)
```

#### 4c. TabBar / TabController

`TabController` notifies **twice** per switch — once when the animation starts, once when it
lands. Guard, or every tab switch is counted twice:

```dart
_tabController.addListener(() {
  if (_tabController.indexIsChanging) return;                  // ✅ ignore the in-flight tick
  unawaited(
    sl<AnalyticsFacade>().trackTabSelected(
      screen: 'products',
      tab: _tabSlugs[_tabController.index],
      index: _tabController.index,
    ),
  );
});
```

A programmatic `animateTo` — a "view all" CTA that jumps to another tab — fires this too. That is correct: the user did land on that tab. If
you need to tell the two apart, add a `source` param (`'tab_bar'` / `'cta'`).

#### 4d. Bottom navigation

`goBranch` does not push a route, so the router observer never sees it. Track it explicitly in
the shell view that owns the `StatefulNavigationShell` (its `_goBranch`), once the app has a
tab shell:

```dart
void _goBranch(int branch) {
  if (branch != navigationShell.currentIndex) {                // ✅ a re-tap resets the branch,
    unawaited(                                                 //    it is not a tab switch
      sl<AnalyticsFacade>().trackTabSelected(
        screen: 'main_shell',
        tab: _items[branch].label,
        index: branch,
      ),
    );
  }
  navigationShell.goBranch(
    branch,
    initialLocation: branch == navigationShell.currentIndex,
  );
}
```

#### 4e. PageView and carousels

With `onPageChanged`, fire directly. With a `PageController` listener — the onboarding pager in
`lib/src/onboarding/presentation/view/onboarding_view.dart` is one — the listener runs on every
frame of the scroll, so fire only when the settled page changes, which that widget already
computes:

```dart
final snapped = raw.round();
if (_pageNotifier.value != snapped) {
  _pageNotifier.value = snapped;
  unawaited(sl<AnalyticsFacade>().trackOnboardingPageViewed(index: snapped));  // ✅ once
}
```

#### 4f. Modal bottom sheets

Sheets here expose `static Future<T?> show(...)` and return through `Navigator.pop`, with `null`
meaning dismissed. Split the tracking across both sides — the sheet cannot tell apply from
dismiss, and the caller cannot tell when it opened:

```dart
// In the sheet
static Future<ProductFilterState?> show(BuildContext context, {...}) {
  unawaited(sl<AnalyticsFacade>().trackSheetOpened(sheet: 'product_filter'));  // ✅
  return showModalBottomSheet<ProductFilterState>(...);
}

// At the caller
Future<void> _openFilterSheet(BuildContext context) async {
  final filterCubit = context.read<ProductFilterCubit>();
  final result = await ProductFilterSheet.show(context, initial: filterCubit.state, ...);
  if (result == null) {
    unawaited(sl<AnalyticsFacade>().trackSheetDismissed(sheet: 'product_filter'));  // ✅
    return;
  }
  unawaited(sl<AnalyticsFacade>().trackFilterApplied(                              // ✅
    screen: 'product_list',
    filterCount: result.activeCount,
  ));
  filterCubit.apply(result);
}
```

#### 4g. Selection state

Fire on change, not on rebuild:

```dart
void _selectVariation(ProductVariation variation) {
  if (_selectedVariation.value?.id == variation.id) return;    // ✅ a re-tap is not a selection
  _selectedVariation.value = variation;
  unawaited(sl<AnalyticsFacade>().trackVariationSelected(
    productSlug: widget.product.slug,
    variationId: variation.id.toString(),
  ));
}
```

#### 4h. Screen views — do not write these

`MyGoRouterObserver` (`lib/core/monitoring/routing_observer.dart`) is attached to the router and
emits a screen view on every push and replace. Hand-logging one double-counts it.

Known gap, worth reporting rather than working around: the observer is registered on the **root**
`GoRouter` only. Once the app has a `StatefulShellRoute`, its branches have no `observers:` unless
you add them — pushes inside a tab go onto the branch's own navigator and may never reach it. If screens from your module are missing, say so; do not paper
over it with a manual event.

### 5. Firebase limits

Breaching one of these **silently drops data in release builds** — you will not see it in debug.

| Limit | Value | Consequence |
|---|---|---|
| Distinct event names | **500 per app, for its lifetime** | New names rejected; a name can never be deleted |
| Params per event | 25 | Extras dropped |
| Event / param name length | 40 chars, `[a-z][a-z0-9_]*` | Rejected |
| String param value | 100 chars | Truncated |
| User properties | 25 | Extras rejected |

Money is a `num` in major units plus a `currency` ISO code — never a formatted or localized
string. Enums go over the wire as `.name`. Lists become a count, or ids joined with `,` under 100
chars.

### 6. Verify

```bash
flutter analyze lib/          # zero errors
```

The analyzer is a real safety net here: a declaration with no implementation, or a facade forward
with a mismatched param, is a hard error — not a silent gap.

Then run the app on the `dev` flavor and walk the module. Check, in order:

1. Every event you planned actually fires.
2. **No event fires twice for one action** — the usual causes are a tab listener without the
   `indexIsChanging` guard, and a cubit and its button both tracking the same tap.
3. No param carries anything from the "never log" list.
4. Screen views still appear, one per navigation.

To confirm against the real backend, use Firebase DebugView:
`adb shell setprop debug.firebase.analytics.app {applicationId}` on Android, or the
`-FIRDebugEnabled` launch argument on iOS.

---

## Working the rollout

One module per agent, three phases. Do not skip phase 1.

**Phase 1 — audit and plan.** Do steps 1 and 2, then write
`docs/claude-plans/{YYYY-MM-DD}-analytics-{module}-plan.md`: a table of every proposed event with
its method name, its params, its wire name, when it fires, and its call site (`file.dart` plus the
surface from §4). **Wait for approval before writing code.**

**Phase 2 — implement.** Steps 3 and 4, in that order.

**Phase 3 — verify.** Step 6.

The `// ── {module} ──` section headers in `analytics_client.dart` are the coverage map. There is
no separate catalog doc to update — the interface is the catalog, which is the point of the whole
design.

---

## Checklist

- [ ] Every event is a named, typed method on `AnalyticsClient`, under its module's section header
- [ ] Each method has a doc comment saying when it fires, and whether on intent or on success
- [ ] Params are named, `required`, and primitives — no entity from `lib/src/` reaches core
- [ ] Implemented in **every** provider, using that provider's native API where one exists
- [ ] Forwarded in `AnalyticsFacade` with no logic added
- [ ] Every call site is wrapped in `unawaited(...)`
- [ ] Cubits inject `AnalyticsFacade`; non-cubit code uses `sl<AnalyticsFacade>()`
- [ ] Every tracking cubit has `analytics: sl()` at its construction site
- [ ] Cubit events fire inside `fold`'s success branch, before `emit`
- [ ] Tab listeners guard on `!indexIsChanging`
- [ ] Sheet "applied" fires at the caller, not inside the sheet
- [ ] Selection events fire only when the value changed
- [ ] No hand-written screen views
- [ ] One action produces exactly one event — verified on a device, not assumed
- [ ] Wire names are `snake_case` and GA4-standard where one exists
- [ ] No PII in any param
- [ ] `flutter analyze lib/` is clean

## Common Mistakes to Avoid

1. ❌ **Adding a generic event method** so a module can avoid touching core
   - Wrong: `trackEvent(String name, Map<String, Object?> params)`
   - Right: a named method per event — that is what lets each provider implement it natively

2. ❌ **Reusing an unrelated method** because the params happen to fit
   - Wrong: firing `trackProductSelected` for a banner tap
   - Right: add `trackPromotionSelected`

3. ❌ **Forgetting `unawaited`**
   - Wrong: `_analytics.trackOrderPlaced(...)` bare — the analyzer will not complain, and the
     future's failure becomes an unhandled async error
   - Right: `unawaited(_analytics.trackOrderPlaced(...))`

4. ❌ **Awaiting it** — `await _analytics.trackOrderPlaced(...)` puts a network round trip in
   front of the user's next screen

5. ❌ **Passing an entity into core**
   - Wrong: `trackProductViewed({required Product product})`
   - Right: `trackProductViewed({required String productSlug, required String productName})`

6. ❌ **Tracking before the operation succeeded**
   - Wrong: firing `trackOrderPlaced` when the checkout button is tapped
   - Right: firing it inside `fold`'s success branch

7. ❌ **Double-counting one action** — the button logs it and the cubit logs it too. Pick one:
   the cubit if there is a backend outcome, the widget if there isn't.

8. ❌ **Tab listener without a guard** — `TabController` notifies twice per switch

9. ❌ **Hand-logging screen views** — the router observer already emits them

10. ❌ **Logging inside `build()`** — it re-runs on every rebuild, so one screen becomes forty
    events. Track in callbacks and cubit methods only.

11. ❌ **Localized or formatted values**
    - Wrong: `'price': '١٤٩٫٠٠ ر.س'`, `tab: text?.walletTab`
    - Right: `value: 149.0`, `currency: 'SAR'`, `tab: 'wallet'`

12. ❌ **PII in params** — no email, phone, address, KYC number, token, or raw error message

13. ❌ **Putting provider-specific behaviour in the facade** — it belongs in that provider's client

## When to Ask the User

1. **A method would need data the app doesn't have.** The existing
   `trackOnboardingStart({required String deviceId})` is the live example: nothing in this app
   produces a device id, and `device_info_plus` isn't a dependency. Ask where it should come from —
   do not invent one, and do not delete the method.

2. **You can't find the source of a param** — a currency code, a list id, a promotion id. Ask; do
   not hardcode `'SAR'`.

3. **A param might be PII** — a referral code, an invite code, a storefront name. Ask before
   sending it.

4. **Two modules want the same event with different params.** Ask which shape wins; do not fork it
   into two near-identical methods.

5. **You're unsure an interaction is worth tracking.** List it in the plan doc under "borderline"
   and let the user cut.

6. **Anything in `lib/core/monitoring/` needs to change beyond adding your methods** — including
   the `_dispatch` try/catch noted at the top. Ask first.

## Summary

1. Inventory the module — cubit methods **and** the taps, tabs, sheets and pagers that never reach
   a cubit. Cut to 8–20 that carry intent.
2. Name each one `track{Subject}{PastTenseVerb}`, with named `required` primitive params.
3. Add it to three files: declare on `AnalyticsClient`, implement in every provider using its
   native API, forward in `AnalyticsFacade`.
4. Call it `unawaited` — injected `_analytics` in cubits, `sl<AnalyticsFacade>()` everywhere else.
   Never in `build()`, never twice for one action.
5. No entities in core, no PII, no localized strings, money as `num` + `currency`.
6. `flutter analyze lib/`, then walk the module on a device and count the events.

`analytics_client.dart` is the inventory. If someone can't read that one file and know what the
app monitors, the change is wrong.
