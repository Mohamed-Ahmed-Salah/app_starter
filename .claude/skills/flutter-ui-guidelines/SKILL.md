---
name: flutter-ui-guidelines
description: Enforce project-specific Flutter UI/UX design guidelines when building or reviewing widgets and screens. Use this when creating new Flutter UI, reviewing existing UI code, or adding/modifying widgets.
---

You are building or reviewing Flutter UI for this project. Apply every rule below **without exception**. These are not suggestions — they are enforced project standards.

---

## 🚨 FORBIDDEN — Never Do These

1. **No fixed sizes on containers — and no hardcoded padding numbers**
   - ❌ `Container(height: 120, width: 300, …)` / `SizedBox(height: 200, child: …)`
   - ✅ Let the container take its height from its content and its width from its parent
     (`Expanded`, `crossAxisAlignment: stretch`, `width: double.infinity`)
   - ❌ `EdgeInsets.all(16)` / `SizedBox(height: 20)`
   - ✅ `EdgeInsets.all(SizeConstants.cardPadding)` / `SizedBox(height: SizeConstants.sectionGap)`
   - ✅ On the rare occasion a dimension is genuinely required (an image box, a sheet cap),
     derive it from the screen: `MediaQuery.sizeOf(context).width * 0.4` — the ratio stays
     at the call site, it is **not** a `SizeConstants` token

2. **No hardcoded font sizes**
   - ❌ `TextStyle(fontSize: 16)`
   - ✅ `theme.textTheme.titleMedium`

3. **No hardcoded colors**
   - ❌ `color: Color(0xFF587a6f)` / `color: Colors.green`
   - ✅ `color: theme.primaryColor` or `color: Colours.success`

4. **No `_buildX()` private helper methods**
   - ❌ `Widget _buildHeader() { ... }`
   - ✅ Create a separate `HeaderWidget extends StatelessWidget`

5. **No custom styling on TextFormField / TextField / ElevatedButton / DropdownButtonFormField**
   - ❌ Adding `border:`, `fillColor:`, `filled:`, or `shape:` — the theme handles all of this
   - ✅ Only use `labelText:` and `hintText:` in `InputDecoration`

6. **No repeated `Theme.of(context)` or `AppLocalizations.of(context)` calls**
   - ❌ Calling them multiple times inside build
   - ✅ Declare once at the top of `build()`

7. **No hardcoded UI strings**
   - ❌ `Text("Products")`
   - ✅ `Text(text?.products ?? "Products")`

8. **No string interpolation patterns like `"${text?.name}"`**
   - ❌ `"${text?.name}"` — this coerces null to the string `"null"`
   - ✅ `text?.name ?? "Name"` — always use `??` fallback with a sensible default

9. **No `context.watch` at the top of a `build()` that returns more than the consumer**
   - ❌ reading a flag into a local, then using it on one button ten levels down
   - ✅ `BlocSelector` wrapped around the widget that actually reads it

---

## Rebuild Scope — Read State Where It Is Consumed

`context.watch<C>().state` subscribes the **whole enclosing widget**. In a form or a sheet
that means every text field rebuilds when a submit starts, purely to grey out one button.

Read the state at the consumer instead:

```dart
// ❌ rebuilds the entire sheet — header, all fields, footer
final submitting = context.watch<CreateAddressCubit>().state.maybeWhen(
  loading: () => true,
  orElse: () => false,
);
return Column(children: [Header(...), ...fields, Footer(submitting: submitting)]);

// ✅ rebuilds only the footer
return Column(children: [
  const Header(),
  ...fields,
  BlocSelector<CreateAddressCubit, CreateAddressState, bool>(
    selector: (state) =>
        state.maybeWhen(loading: () => true, orElse: () => false),
    builder: (context, submitting) => Footer(submitting: submitting),
  ),
]);
```

**When the same flag has more than one consumer** (a header close button *and* a footer CTA),
don't widen one selector to cover both — that is `context.watch` again. Give the file one
private `_SubmittingSelector` and wrap each consumer with it:

```dart
class _SubmittingSelector extends StatelessWidget {
  const _SubmittingSelector({required this.builder});

  final Widget Function(BuildContext context, bool submitting) builder;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<CreateAddressCubit, CreateAddressState, bool>(
      selector: (state) =>
          state.maybeWhen(loading: () => true, orElse: () => false),
      builder: builder,
    );
  }
}
```

Two cubits feeding one flag (a sheet serving both create and edit) → nest the selectors
inside that one widget and combine in its `builder`, so call sites stay unaware.

`BlocSelector` over `BlocBuilder` whenever the widget needs a *derived value* rather than the
state object: it compares the selected value, so an emission that doesn't change the flag
doesn't rebuild at all.

**`context.watch` is still correct when the widget's whole subtree is the consumer** — a
submit-button widget that is nothing but the button. The rule is about scope, not about the
API. If wrapping the return value in a selector would rebuild the same widgets, leave it.

---

## ✅ MANDATORY PATTERNS

### Theme & Localization — Always Declare at Top of `build()`

```dart
@override
Widget build(BuildContext context) {
  final theme = Theme.of(context);
  final text = AppLocalizations.of(context);
  // ...
}
```

---

### Sizing — Content Decides, Not Numbers

Nine times out of ten a widget needs **no size at all**. Height comes from the content;
width comes from the parent. Reach for a number only after these have failed:

```dart
// Full width: stretch, don't measure
Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [...])
SizedBox(width: double.infinity, child: ElevatedButton(...))

// Share a row: Expanded / Flexible, never a computed width
Row(children: [Expanded(child: ...), const SizedBox(width: SizeConstants.itemGap), Expanded(child: ...)])

// Keep a shape: AspectRatio, not width + height
AspectRatio(aspectRatio: 4 / 3, child: Image.network(...))

// Cap, don't fix
ConstrainedBox(constraints: const BoxConstraints(maxWidth: 480), child: ...)
```

When a dimension is genuinely required — a hero image box, a bottom-sheet height cap, a
horizontally scrolling card that must peek the next one — derive it from the screen, at
the call site:

```dart
final size = MediaQuery.sizeOf(context);
SizedBox(height: size.height * 0.35, child: ...)   // ✅ ratio lives here
SizedBox(width: size.width * 0.42, child: ...)     // ✅
```

- ❌ `SizeConstants.heroHeightFactor = 0.35` — a factor is not a token. It describes one
  screen, and putting it in `SizeConstants` invites the next one.
- ❌ `SizeConstants.productCardHeight = 220` — the same in pixels.
- ❌ `height: 200` on a `Container` whose child already has a height.

### Spacing & Radius — Use SizeConstants

`SizeConstants` holds exactly three kinds of value: **spacing** (padding, gaps between
sections and items), **border radii**, and **small control geometry** (icon sizes, tap
target, chip/badge padding). Nothing else goes in it.

**Page padding** (outer scaffold body):
```dart
Padding(padding: const EdgeInsets.all(SizeConstants.screenPadding))          // 16
```

**Card / inner container padding:**
```dart
Padding(padding: const EdgeInsets.all(SizeConstants.cardPadding))            // 12
Padding(padding: const EdgeInsets.all(SizeConstants.cardPaddingLoose))       // 16
```

**Gaps:**
```dart
const SizedBox(height: SizeConstants.itemGapSmall)     // 8  — tight items
const SizedBox(height: SizeConstants.itemGap)          // 12 — items in a section
const SizedBox(height: SizeConstants.subsectionGap)    // 24
const SizedBox(height: SizeConstants.sectionGap)       // 28 — between sections
```

**Border radius:**
```dart
BorderRadius.circular(SizeConstants.radiusXl)    // cards
BorderRadius.circular(SizeConstants.radiusLg)    // inputs, chips
BorderRadius.circular(SizeConstants.radiusMd)    // inner elements
BorderRadius.circular(SizeConstants.radiusFull)  // pills, avatars
```

**Icon sizes:**
```dart
Icon(Media.infoOutlineIcon, size: SizeConstants.iconSizeLarge)   // 16 / 20 / 24 / 28
```

If a spacing or radius you need is missing, add it to `SizeConstants` on the 4px grid. If a
*dimension* is missing, it does not belong there — see the section above.

`flutter_screenutil` is initialised once in `main.dart` and used by the theme for text and
icon scaling. Widgets do not call `.w` / `.h` / `.sp` themselves.

---

### Typography — Always Use `theme.textTheme`

| Style | Usage |
|-------|-------|
| `theme.textTheme.displayLarge` | Hero titles |
| `theme.textTheme.displayMedium` | Large display |
| `theme.textTheme.displaySmall` | Small display |
| `theme.textTheme.headlineLarge/Medium/Small` | Section / page headers |
| `theme.textTheme.titleLarge` | Main titles |
| `theme.textTheme.titleMedium` | Card titles |
| `theme.textTheme.titleSmall` | Small titles |
| `theme.textTheme.bodyLarge/Medium/Small` | Body text |
| `theme.textTheme.labelLarge/Medium/Small` | Labels |

Only modify `color`, `fontWeight`, or `decoration` via `.copyWith()`. Never modify `fontSize` or `fontFamily`.

```dart
Text(
  text?.pageTitle ?? "Page Title",
  style: theme.textTheme.titleLarge,
)

Text(
  text?.cardTitle ?? "Card Title",
  style: theme.textTheme.titleMedium?.copyWith(
    color: Colours.textBlackColor,
    fontWeight: FontWeight.w600,
  ),
)
```

---

### Colors — Theme or Colours Class

**Dynamic / organization-specific:**
```dart
theme.primaryColor
theme.scaffoldBackgroundColor
theme.colorScheme.secondary
```

**Static semantic colors from `Colours` class (`lib/core/res/colours.dart`):**
```dart
// Brand — swap for the product's brand book; keep the semantic names below
Colours.primaryColor / Colours.primaryColorSwatch
Colours.scaffoldBackground
Colours.mint50..mint700, Colours.warmBlack600..900, Colours.coral400..600
Colours.cream50..200, Colours.grey50..grey700

// Text
Colours.textPrimary / Colours.textSecondary / Colours.textTertiary
Colours.textOnDark / Colours.textPrice / Colours.textStrike / Colours.textLink

// Surfaces & borders
Colours.surfacePage / surfaceRaised / surfaceSunken / surfaceCream / surfaceMint
Colours.borderSubtle / borderDefault / borderStrong / borderInput

// Status — each has a *Bg pair for tinted containers
Colours.success / successBg
Colours.error / errorStrong / errorBg
Colours.warning / warningBg
Colours.info / infoBg

// Interaction
Colours.ctaBg / ctaBgHover / ctaFg / ctaBgDisabled / ctaFgDisabled
Colours.badgeNewBg / badgeSaleBg

// Skeletons
Colours.shimmerBase / shimmerHighlight / shimmerEdge
```

**If a color you need does not exist in `Colours`, add it there.** Do not hardcode it inline.

**For enums and entities**, create or use an extension that returns the colour, icon and
label directly — the `OrderStatusX` pattern:

```dart
// shape: lib/src/<feature>/domain/entities/extensions/<entity>_extension.dart
// live example in this repo: products/domain/entities/extensions/product_extension.dart
extension OrderStatusX on OrderStatus {
  String label(AppLocalizations? text) => switch (this) {
    OrderStatus.pending => text?.orderStatusPending ?? 'Pending',
    OrderStatus.delivered => text?.orderStatusDelivered ?? 'Delivered',
    OrderStatus.cancelled => text?.orderStatusCancelled ?? 'Cancelled',
  };

  Color get color => switch (this) {
    OrderStatus.pending => Colours.warning,
    OrderStatus.delivered => Colours.success,
    OrderStatus.cancelled => Colours.error,
  };

  IconData get icon => switch (this) { ... };
}

// Usage in widgets:
Container(color: order.status.color)
Text(order.status.label(text))
```

**Where an extension lives is decided by the type it extends:**

| Extends | Lives in | Example |
|---|---|---|
| A Dart, Flutter or `core/` type — `BuildContext`, `DateTime`, `String`, `num`, `Color`, `Failure` | `lib/core/config/extentions/<type>_extension.dart` | `date_extension.dart`, `failure_extension.dart` |
| An entity or enum declared in `lib/src/<feature>/domain/entities/` | `lib/src/<feature>/domain/entities/extensions/<entity>_extension.dart` | `products/domain/entities/extensions/product_extension.dart` |

Name the extension `<Type>X`. One file per extended type; a feature never puts its
entity's helpers in `core/`, and `core/` never imports from `lib/src/`.

The entity class itself stays Flutter-free (see the `flutter-clean-arch` skill); its
extension file is where `Colours`, `Media` and `AppLocalizations` are allowed to appear.

---

### Localization — Always Add to Both ARB Files

When adding any user-facing string:

1. Add to `lib/l10n/app_en.arb`:
```json
{
  "myString": "My String",
}
```

2. Add to `lib/l10n/app_ar.arb`:
```json
{
  "myString": "النص بالعربي"
}
```

3. Run: `flutter gen-l10n`

4. Use with **null-safe fallback** — never string interpolation:
```dart
// ✅ Correct
text?.myString ?? "My String"
text?.emailLabel ?? "Email"

// ❌ Wrong — coerces null to "null"
"${text?.myString}"
```

---

### Widget Composition — No `_buildX()` Methods

Always extract to separate `StatelessWidget` or `StatefulWidget` classes.

```dart
// ✅ Correct
class MyView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const HeaderWidget(),
        const BodyWidget(),
      ],
    );
  }
}

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: SizeConstants.screenPadding,
      ),
      child: Text(
        text?.header ?? "Header",
        style: theme.textTheme.titleLarge,
      ),
    );
  }
}
```

**Widget placement:**
- Used across multiple features → `lib/core/widgets/` (with subdirs: `filters/`, `dialogs/`, `cards/`)
- Used in one feature only → `lib/src/{feature}/presentation/widgets/`
- Shared widgets must accept callbacks, not access cubits directly

---

### Scaffold / Page Layout Pattern

```dart
Scaffold(
  appBar: AppBar(
    title: Text(text?.pageTitle ?? "Page Title"),
  ),
  body: Padding(
    padding: const EdgeInsets.symmetric(
      horizontal: SizeConstants.screenPadding,
    ),
    child: Column(
      children: [
        const SectionOneWidget(),
        const SizedBox(height: SizeConstants.sectionGap),
        const SectionTwoWidget(),
      ],
    ),
  ),
)
```

---

### Form Fields & Validation

**Always use `TextFormValidation` from `lib/core/utils/form_validations.dart` for validators. Never write inline validation logic.**

#### Available validators:

| Method | Use for |
|--------|---------|
| `TextFormValidation.requiredField(value, context: context)` | Any required field |
| `TextFormValidation.emailValidation(value, context: context)` | Email fields |
| `TextFormValidation.optionalEmailValidation(value, context: context)` | Optional email |
| `TextFormValidation.fullNameValidation(value, context: context)` | Full name (EN + AR, no numbers/special chars) |
| `TextFormValidation.phoneValidation(value, context: context)` | Phone (numeric, min 9 digits) |
| `TextFormValidation.amountValidation(value, context: context, max: balance)` | Money amount (> 0, optional cap) |
| `TextFormValidation.passwordValidation(value, context: context)` | Password (min 8 chars, must have number) |
| `TextFormValidation.passwordConfirmationValidation(value, password: pw, context: context)` | Confirm password match |

Need another rule? Add a static method to `TextFormValidation` with its message in both ARB
files — never an inline `validator:` closure.

#### Available input formatters:

```dart
TextFormValidation.englishAndArabic      // Allow EN + AR letters and spaces only
TextFormValidation.passwordAllowedText   // Allow password-safe characters
TextFormValidation.usernameAllowedText   // Allow a-z, 0-9, . and _ only
```

#### ✅ Correct usage:

```dart
TextFormField(
  controller: _nameController,
  keyboardType: TextInputType.name,
  inputFormatters: [TextFormValidation.englishAndArabic],
  decoration: InputDecoration(
    labelText: text?.fullName ?? "Full Name",
    hintText: text?.enterFullName ?? "Enter full name",
  ),
  validator: (v) => TextFormValidation.fullNameValidation(v, context: context),
)

TextFormField(
  controller: _emailController,
  keyboardType: TextInputType.emailAddress,
  decoration: InputDecoration(
    labelText: text?.email ?? "Email",
    hintText: text?.enterEmail ?? "Enter email",
  ),
  validator: (v) => TextFormValidation.emailValidation(v, context: context),
)

TextFormField(
  controller: _passwordController,
  obscureText: true,
  inputFormatters: [TextFormValidation.passwordAllowedText],
  decoration: InputDecoration(
    labelText: text?.password ?? "Password",
  ),
  validator: (v) => TextFormValidation.passwordValidation(v, context: context),
)
```

#### Form template:

```dart
class MyFormView extends StatefulWidget {
  const MyFormView({super.key});

  @override
  State<MyFormView> createState() => _MyFormViewState();
}

class _MyFormViewState extends State<MyFormView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(text?.formTitle ?? "Form"),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: SizeConstants.screenPadding,
          ),
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                inputFormatters: [TextFormValidation.englishAndArabic],
                decoration: InputDecoration(
                  labelText: text?.name ?? "Name",
                  hintText: text?.enterName ?? "Enter name",
                ),
                validator: (v) => TextFormValidation.fullNameValidation(v, context: context),
              ),
              const SizedBox(height: SizeConstants.sectionGap),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Handle submit
                  }
                },
                child: Text(text?.submit ?? "Submit"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

---

### Icons — Always Use `Media` Class

**Never reference an icon set directly in widget code** — not `AppIcons.*`, not `Icons.*` /
`CupertinoIcons.*`. All icons are pre-declared in `lib/core/res/media.dart` under the `Media`
class, named by *purpose*. Use them from there.

- ❌ `Icon(Icons.info_outline)`
- ✅ `Icon(Media.infoOutlineIcon)`

**If an icon you need is not yet in `Media`, add it there before using it.** But first check
that it really isn't — see **Reuse before you add** below.

#### Reuse before you add

`Media` is a registry, not a per-screen list. Before declaring a new entry, grep `media.dart`
for the glyph you are about to point at:

```bash
grep -n "AppIcons.infoCircle\|Icons.info_outline" lib/core/res/media.dart
```

Then, in order:

1. **An entry already resolves to that glyph → reuse it.** Never add a second constant for the
   same `IconData`.
2. **The existing name is bound to its first screen → rename it so it can be reused.** A name
   like `profileUserIcon` says where it was first used, not what it is. Rename to what the glyph
   *is* (`userIcon`), update every call site (`grep -rn "Media.profileUserIcon" lib/`), and use
   the new name. The analyzer catches every missed site.
3. **Nothing resolves to it → add a new entry**, choosing the set by the order below.

Name a new entry for **what the glyph is or does**, not for the screen that needs it:
`userIcon`, `downloadIcon`, `externalLinkIcon`, `nextPageIcon`. Reserve a `<context>` prefix
for the rare case where the same glyph carries a different meaning in two places and both
entries must exist.

#### Which icon set a new `Media` entry resolves to

**1. `AppIcons.*` — the project's own icon font. Always try this first.**

`lib/core/res/app_icons.dart` is the constant-per-glyph map for `assets/fonts/app_icons.ttf`.
The starter ships one glyph (`infoCircle`) as the pattern; generate the real set from the
product's SVGs with IcoMoon, replace the `.ttf`, and add one doc-commented constant per glyph
(`/// <Name>.svg`). Outline/filled pairs get `*Filled` for the selected state:

```dart
static const IconData cartIcon = AppIcons.bag;
static const IconData cartFilledIcon = AppIcons.bagFilled;
```

**2. Material `Icons.*` — the fallback while the branded set is incomplete.**

Say so in a trailing comment so it is found and replaced when the glyph lands:

```dart
static const IconData imageBrokenIcon = Icons.image_not_supported_outlined; // no AppIcons glyph yet
```

If the product adopts a third-party set as its fallback (Lucide, Phosphor…), add the package,
pick **one weight** that matches the branded font's stroke, and document it here — never mix
weights.

**3. `CupertinoIcons.*` — only inside a Cupertino-specific widget** (an iOS action sheet), never
as a general fallback.

#### Finding an icon

- `lib/core/res/media.dart` — what is already wired up and named. **Always here first.**
- `lib/core/res/app_icons.dart` — what the branded font contains; grep the `/// <Name>.svg`
  comments.
- `open assets/fonts/app_icons.ttf` in Font Book to see every glyph at once.

---

### Images & Assets — Always Use `Media` Class

**Never hardcode asset paths.** All asset paths are in `lib/core/res/media.dart`, and every
asset folder is listed under `flutter: assets:` in `pubspec.yaml`.

- ❌ `Image.asset('assets/imgs/placeholder_1.png')`
- ✅ `Image.asset(Media.placeholder1Img)`

Current entries:

```dart
Media.appLogoImg        // splash logo — TODO(starter): point at the real logo
Media.placeholder1Img   // delete once real assets exist
Media.placeholder2Img
```

Suffix by kind: `*Img` for raster, `*Svg` for vectors (add `flutter_svg` when the first one
lands), `*Lottie` for animations (add `lottie` when the first one lands).

---

### Common Imports

```dart
import 'package:app_starter/core/constants/size_constants.dart';
import 'package:app_starter/core/constants/text_constants.dart';
import 'package:app_starter/core/res/media.dart';
import 'package:app_starter/core/res/colours.dart';
import 'package:app_starter/core/utils/form_validations.dart';
import 'package:app_starter/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
```

---

## 📋 Pre-Flight Checklist

Before finalizing any UI code:

- [ ] `final theme = Theme.of(context);` at top of `build()`
- [ ] `final text = AppLocalizations.of(context);` at top of `build()`
- [ ] No fixed `height:` / `width:` on containers — content and parent decide; `Expanded` / `stretch` / `AspectRatio` before any number
- [ ] Any required dimension is `MediaQuery.sizeOf(context)` × a ratio at the call site — no factor or pixel dimension added to `SizeConstants`
- [ ] All padding, gaps and radii use `SizeConstants.*`
- [ ] Page-level padding uses `screenPadding`, cards use `cardPadding`
- [ ] All text styles use `theme.textTheme.*`
- [ ] All colors use `theme.*` or `Colours.*` — none added inline
- [ ] Missing colors added to `Colours` class
- [ ] Enums and entities have extensions for color, icon and label — in `domain/entities/extensions/` of their feature, not `core/`
- [ ] No hardcoded strings — all use `text?.key ?? "Fallback"`
- [ ] No `"${text?.key}"` string interpolation anywhere
- [ ] No `_buildX()` methods — separate widgets only
- [ ] No custom styling on TextFormField / TextField / ElevatedButton
- [ ] New strings added to both `app_en.arb` and `app_ar.arb`
- [ ] `const` constructors used wherever possible
- [ ] `StatelessWidget` used unless local state is actually needed
- [ ] All validators use `TextFormValidation.*` — no inline validation logic
- [ ] No `context.watch` whose rebuild reaches past the widgets that read the value — use `BlocSelector` at the consumer
- [ ] All icons use `Media.*` in widgets — no raw `AppIcons.*` / `Icons.*`
- [ ] Before adding a `Media` icon entry, grepped `media.dart` for the glyph — reused the existing entry, or renamed a screen-bound one to a reusable name and updated its call sites
- [ ] New `Media` icon entries use `AppIcons.*`, falling back to Material `Icons.*` with a `// no AppIcons glyph yet` comment
- [ ] New `Media` icon names say what the glyph is (`userIcon`), not which screen first needed it (`storefrontCustomerIcon`)
- [ ] All asset paths use `Media.*` — no inline asset strings
- [ ] Multi-use non-UI constants use `TextConstants.*` — no duplicate string literals
