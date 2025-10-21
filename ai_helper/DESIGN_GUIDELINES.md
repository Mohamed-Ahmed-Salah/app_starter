# Flutter UI/UX Design Guidelines for AI Assistants

## 📋 Overview
This document provides strict UI/UX design rules for creating consistent, maintainable, and theme-compliant Flutter widgets and screens. **Follow these rules without exception** to maintain design consistency across the application.

---

## 🚨 CRITICAL RULES - NEVER BREAK THESE

### ❌ **FORBIDDEN PRACTICES**

1. **NEVER use hardcoded sizes**
   - ❌ `padding: EdgeInsets.all(16)`
   - ✅ `padding: EdgeInsets.all(SizeConstants.innerContainerPadding)`

2. **NEVER use hardcoded font sizes**
   - ❌ `fontSize: 16`
   - ✅ `theme.textTheme.titleMedium`

3. **NEVER create `_buildX()` helper methods**
   - ❌ `Widget _buildHeader() { ... }`
   - ✅ Create a `HeaderWidget` as a separate StatelessWidget or StatefulWidget

4. **NEVER add custom styles to TextFormField, TextField, or ElevatedButton**
   - ❌ `TextFormField(decoration: InputDecoration(border: ...))`
   - ✅ `TextFormField()` - theme handles all styling

5. **NEVER use hardcoded colors**
   - ❌ `color: Color(0xFF587a6f)`
   - ✅ `color: theme.primaryColor` or `color: Colours.primaryColor`

6. **NEVER call `Theme.of(context)` or `AppLocalizations.of(context)` multiple times**
   - ❌ Calling `Theme.of(context)` repeatedly throughout the widget
   - ✅ Call once at the top: `final theme = Theme.of(context);` `final text = AppLocalizations.of(context);`

7. **NEVER hardcode strings in UI**
   - ❌ `Text("Leave Request")`
   - ✅ `Text(text?.leaveRequest ?? "Leave Request")`

---

## ✅ MANDATORY PATTERNS

### 1. **Theme and Localization Initialization**

**ALWAYS** initialize theme and localization at the top of the `build()` method:

```dart
@override
Widget build(BuildContext context) {
  final theme = Theme.of(context);
  final text = AppLocalizations.of(context);

  // Rest of widget tree
  return Scaffold(
    appBar: AppBar(
      title: Text("${text?.pageTitle}"),
    ),
    body: Text(
      "${text?.welcomeMessage}",
      style: theme.textTheme.titleLarge,
    ),
  );
}
```

**WHY?**
- Improves performance (single lookup)
- Cleaner, more readable code
- Easier to maintain

---

### 2. **Sizing and Spacing**

All sizes and spacing MUST come from `lib/core/constants/size_constants.dart`.

#### Available Size Constants:

```dart
// Border Radius
SizeConstants.fullBorderRadius       // 100 - For circular shapes
SizeConstants.outerBorderRadius      // 14  - Cards, containers, buttons
SizeConstants.innerBorderRadius      // 10  - Inner elements
SizeConstants.smallBorderRadius      // 6   - Small elements

// Padding (Inside Containers)
SizeConstants.smallInnerPadding      // 8
SizeConstants.meduimInnerPadding     // 12
SizeConstants.innerContainerPadding  // 16

// Spacing (Between Elements)
SizeConstants.baseHorizontalPadding  // 4  - Use with .w (4.w)
SizeConstants.baseVerticalPadding    // 4  - Use with .h (4.h)
SizeConstants.pageHorizontalPadding  // 16
SizeConstants.padding                // 20
SizeConstants.smallHorizontalPadding // 5
SizeConstants.verticalPadding        // 10 - Between items in same section
SizeConstants.verticalPaddingTwenty  // 20 - Between different sections

// Durations (Animations)
SizeConstants.mainDuration           // 1 second
SizeConstants.slideDuration          // 600ms
SizeConstants.secondaryDuration      // 400ms
SizeConstants.mainDelayDuration      // 400ms
SizeConstants.maxDelayDuration       // 600ms

// Icon & Image Sizes (Use with .w for responsive sizing)
SizeConstants.containerProfilePicture // 13 (use as: 13.w for width/height)
SizeConstants.bigIconSize             // 19
SizeConstants.iconContainerBox        // 8
```

#### ✅ Correct Usage Examples:

```dart
// Border Radius
Container(
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(SizeConstants.outerBorderRadius),
  ),
)

// Card Margins
Card(
  margin: EdgeInsets.symmetric(
    horizontal: SizeConstants.baseHorizontalPadding.w,
    vertical: SizeConstants.verticalPadding,
  ),
)

// Container Padding
Padding(
  padding: const EdgeInsets.all(SizeConstants.innerContainerPadding),
  child: Column(
    children: [
      Text(...),
      const SizedBox(height: SizeConstants.verticalPadding),
      Text(...),
    ],
  ),
)

// Spacing Between Sections
Column(
  children: [
    SectionOne(),
    const SizedBox(height: SizeConstants.verticalPaddingTwenty),
    SectionTwo(),
  ],
)

// Responsive Spacing with flutter_screenutil
Row(
  children: [
    Icon(Icons.user),
    SizedBox(width: SizeConstants.baseHorizontalPadding.w),
    Text(...),
  ],
)
```

---

### 3. **Typography - Using Theme Text Styles**

**NEVER** specify `fontSize` directly. **ALWAYS** use `theme.textTheme`.

#### Available Text Styles:

| Style | Size | Weight | Usage |
|-------|------|--------|-------|
| `theme.textTheme.displayLarge` | 31.sp | w700 | Hero titles |
| `theme.textTheme.displayMedium` | 25.sp | w300 | Large display text |
| `theme.textTheme.displaySmall` | 20.sp | w500 | Small display text |
| `theme.textTheme.headlineLarge` | 23.sp | w300 | Section headers |
| `theme.textTheme.headlineMedium` | 22.sp | w300 | Page headers |
| `theme.textTheme.headlineSmall` | 21.5.sp | w300 | Subheaders |
| `theme.textTheme.titleLarge` | 18.sp | w300 | Main titles |
| `theme.textTheme.titleMedium` | 16.sp | w300 | Card titles |
| `theme.textTheme.titleSmall` | 15.sp | w300 | Small titles |
| `theme.textTheme.bodyLarge` | 16.sp | w300 | Large body text |
| `theme.textTheme.bodyMedium` | 14.sp | default | Normal body text |
| `theme.textTheme.bodySmall` | 13.5.sp | w300 | Small body text |
| `theme.textTheme.labelLarge` | 14.sp | w300 | Large labels |
| `theme.textTheme.labelMedium` | 13.sp | w300 | Medium labels |
| `theme.textTheme.labelSmall` | 12.sp | w300 | Small labels |

#### ✅ Correct Usage:

```dart
// Page Title
Text(
  text?.pageTitle??"Page title",
  style: theme.textTheme.titleLarge,
)

// Card Title with Custom Color
Text(
  "${text?.cardTitle}",
  style: theme.textTheme.titleMedium?.copyWith(
    color: Colours.textBlackColor,
    fontWeight: FontWeight.w600,
  ),
)

// Body Text
Text(
  "${text?.description}",
  style: theme.textTheme.bodyMedium,
)

// Small Label
Text(
  "${text?.label}",
  style: theme.textTheme.labelSmall?.copyWith(
    color: Colours.textHighlightColor,
  ),
)

// Highlighted Text
Text(
  "${text?.importantText}",
  style: theme.textTheme.titleMedium?.copyWith(
    fontWeight: FontWeight.bold,
    color: theme.primaryColor,
  ),
)
```

**IMPORTANT:** Only use `.copyWith()` to modify:
- `color`
- `fontWeight`
- `decoration` (underline, strikethrough)

Never modify `fontSize` or `fontFamily` - these are theme-managed.

---

### 4. **Colors - Using Theme and Colours Class**

Colors come from **TWO sources**:

#### A. Theme Colors (Dynamic, Organization-Specific)

```dart
theme.primaryColor              // Main brand color
theme.scaffoldBackgroundColor   // Background color
theme.colorScheme.secondary     // Secondary accent color
```

#### B. Colours Class (`lib/core/res/styles/colours.dart`) - Static Colors

```dart
// Primary Colors
Colours.primaryColor            // Color(0xFF587a6f)
Colours.secondaryColor          // Color(0xFFE67E22)
Colours.scaffoldBackground      // Color(0xFFfcfcfa)

// Neutral Colors
Colours.kWhite                  // White
Colours.kBlack                  // Black
Colours.textBlackColor          // Colors.black87
Colours.textHighlightColor      // Color(0xFF515755)
Colours.borderGreyColor         // Black with 0.1 alpha
Colours.hintTextColor           // Black with 0.5 alpha
Colours.lightGreyTextColor      // Colors.grey[600]
Colours.darkGrey                // Color(0xFF757575)
Colours.grey                    // Color(0xFFBDBDBD)
Colours.grey100                 // Color(0xFFF5F5F5)
Colours.grey200                 // Color(0xFFEEEEEE)
Colours.grey300                 // Color(0xFFE0E0E0)
Colours.grey400                 // Color(0xFFBDBDBD)

// Status Colors
Colours.onTimeGreen             // Color(0xFF2E7D32)
Colours.lightGreen              // Colors.green
Colours.tooEarlyOrange          // Colors.orange
Colours.lateRed                 // Color(0xFFF54135)
Colours.notAvailableGrey        // Colors.grey

// Feature-Specific Colors
Colours.approvedGreen           // Color(0xFFE8F5E9)
Colours.rejectedRed             // Color(0xFFFFEBEE)
Colours.rejectedButtonRed       // Colors.redAccent
Colours.approveButtonGreen      // Color(0xFF2E7D32) with 0.7 alpha
Colours.holidayOrWeekendColor   // Colors.amber
Colours.sickDayColor            // Colors.pinkAccent
Colours.onLeaveColor            // Color(0xFF2196F3)

// Semantic Colors
Colours.errorColor              // Color(0xFFF54135)
Colours.greenSuccess            // Color(0xFF24CE9F)
Colours.yellowWarningColor      // Color(0xFFF2B325)

// Specific UI Elements
Colours.homeAppBarColor         // Color(0xFF1A1A1A)
Colours.mapRoads                // White
Colours.mapPin                  // Primary color

// AI Gradient
Colours.aiGradient              // [Color(0xFFbad9e0), Color(0xFFddc2ed), Color(0xFFe0a6cd)]
```

#### ✅ Usage Examples:

```dart
// Use theme.primaryColor for dynamic theming
Container(
  color: theme.primaryColor,
)

// Use Colours class for fixed semantic colors
Container(
  decoration: BoxDecoration(
    color: Colours.scaffoldBackground,
    border: Border.all(color: Colours.borderGreyColor),
  ),
  child: Text(
    "${text?.message}",
    style: theme.textTheme.bodyMedium?.copyWith(
      color: Colours.textBlackColor,
    ),
  ),
)

// Status indicator
Container(
  color: leave.status == RequestStatus.approved
    ? Colours.approvedGreen
    : Colours.rejectedRed,
)

// Icon with theme color
Icon(
  Icons.person,
  color: theme.primaryColor,
)
```

---

### 5. **Form Fields - NEVER Add Custom Styles**

The theme handles **ALL** styling for:
- `TextFormField`
- `TextField`
- `DropdownButtonFormField`
- `ElevatedButton`
- `TextButton`
- `OutlinedButton`

Theme configuration is in `lib/core/services/theme_config_service.dart`.

#### ✅ Correct Usage:

```dart
// TextFormField - NO decoration customization
TextFormField(
  controller: _nameController,
  keyboardType: TextInputType.name,
  textInputAction: TextInputAction.next,
  validator: FormValidations.validateFullName,
  decoration: InputDecoration(
    labelText: "${text?.fullName}",
    hintText: "${text?.enterFullName}",
  ),
)

// DropdownButtonFormField - NO decoration customization
DropdownButtonFormField<LeaveType>(
  value: _selectedLeaveType,
  decoration: InputDecoration(
    labelText: "${text?.leaveType}",
  ),
  items: LeaveType.values.map((type) {
    return DropdownMenuItem(
      value: type,
      child: Text("${type.getDisplayName(text)}"),
    );
  }).toList(),
  onChanged: (value) {
    setState(() {
      _selectedLeaveType = value;
    });
  },
)

// ElevatedButton - Only customize when needed
ElevatedButton(
  onPressed: () {},
  child: Text("${text?.submit}"),
)

// ElevatedButton with custom colors (specific use cases)
ElevatedButton(
  onPressed: onReject,
  style: ElevatedButton.styleFrom(
    minimumSize: Size(double.infinity, 45),
    backgroundColor: Colours.rejectedButtonRed,
    foregroundColor: Colours.kWhite,
  ),
  child: Text(
    "${text?.reject}",
    style: theme.textTheme.titleMedium?.copyWith(
      color: Colours.kWhite,
      fontWeight: FontWeight.w600,
    ),
  ),
)
```

#### ❌ WRONG - Don't Do This:

```dart
// ❌ Custom border radius on TextFormField
TextFormField(
  decoration: InputDecoration(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12), // ❌ Theme handles this
    ),
  ),
)

// ❌ Custom colors on TextFormField
TextFormField(
  decoration: InputDecoration(
    fillColor: Colors.white,  // ❌ Theme handles this
    filled: true,             // ❌ Theme handles this
  ),
)

// ❌ Custom shape on ElevatedButton
ElevatedButton(
  style: ElevatedButton.styleFrom(
    shape: RoundedRectangleBorder(...), // ❌ Theme handles this
  ),
  child: Text("Submit"),
)
```

---

### 6. **Widget Composition - No `_buildX()` Methods**

Instead of private build methods, create **separate widget classes**.

#### ❌ WRONG:

```dart
class MyView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(context),
        _buildBody(context),
        _buildFooter(context),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(...);
  }

  Widget _buildBody(BuildContext context) {
    return Container(...);
  }

  Widget _buildFooter(BuildContext context) {
    return Container(...);
  }
}
```

#### ✅ CORRECT:

```dart
class MyView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const HeaderWidget(),
        const BodyWidget(),
        const FooterWidget(),
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

    return Container(
      padding: const EdgeInsets.all(SizeConstants.innerContainerPadding),
      child: Text(
        "${text?.header}",
        style: theme.textTheme.titleLarge,
      ),
    );
  }
}

class BodyWidget extends StatelessWidget {
  const BodyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = AppLocalizations.of(context);

    return Container(
      child: Text(
        "${text?.body}",
        style: theme.textTheme.bodyMedium,
      ),
    );
  }
}

class FooterWidget extends StatelessWidget {
  const FooterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(...);
  }
}
```

**Benefits:**
- Better testability
- Easier to reuse
- Cleaner code organization
- Better performance (const constructors)

---

### 7. **Localization - Adding New Strings**

When adding **ANY** user-facing text, you MUST add it to BOTH localization files.

#### Files:
- English: `lib/l10n/app_en.arb`
- Arabic: `lib/l10n/app_ar.arb`

#### Process:

1. **Add to `app_en.arb`:**
```json
{
  "leaveRequest": "Leave Request",
  "@leaveRequest": {
    "description": "Title for leave request page"
  },
  "dateRange": "{startDate} - {endDate}",
  "@dateRange": {
    "description": "Date range format"
  }
}
```

2. **Add to `app_ar.arb`:**
```json
{
  "leaveRequest": "طلب إجازة",
  "dateRange": "{startDate} - {endDate}"
}
```

3. **Run code generation:**
```bash
flutter gen-l10n
```

4. **Use in code:**
```dart
final text = AppLocalizations.of(context);

Text("${text?.leaveRequest}")

Text("${text?.dateRange(startDate, endDate)}")
```

#### Localization Patterns:

```dart
// Simple string
Text("${text?.submit}")

// String with parameter
Text("${text?.employeeId(employee.id)}")

// Null-safe with fallback
Text("${text?.title ?? 'Default Title'}")

// In InputDecoration
TextFormField(
  decoration: InputDecoration(
    labelText: "${text?.emailLabel}",
    hintText: "${text?.enterEmail}",
  ),
)
```

**IMPORTANT:** Always use `"${text?.key}"` pattern with null-safety operator `?`.

---

## 📐 Layout Best Practices

### Responsive Design with `flutter_screenutil`

Use `.w`, `.h`, and `.sp` for responsive sizing:

```dart
// Width percentage
SizedBox(width: 50.w)  // 50% of screen width

// Height percentage
SizedBox(height: 10.h) // 10% of screen height

// Responsive font size (already handled by theme, but for custom cases)
fontSize: 14.sp

// Example: Responsive icon size
Icon(
  Icons.person,
  size: 20.sp,  // Scales with screen size
)

// Example: Responsive spacing
SizedBox(width: 4.w)  // Responsive horizontal spacing
```

### Common Layout Patterns:

#### Form Section Spacing:
```dart
Column(
  children: [
    TextFormField(
      decoration: InputDecoration(labelText: "${text?.name}"),
    ),
    const SizedBox(height: SizeConstants.verticalPadding),
    TextFormField(
      decoration: InputDecoration(labelText: "${text?.email}"),
    ),
    const SizedBox(height: SizeConstants.verticalPaddingTwenty),
    ElevatedButton(
      onPressed: () {},
      child: Text("${text?.submit}"),
    ),
  ],
)
```

---

## 📋 Pre-Flight Checklist

Before submitting any UI code, verify:

- [ ] ✅ `final theme = Theme.of(context);` declared at top of `build()`
- [ ] ✅ `final text = AppLocalizations.of(context);` declared at top of `build()`
- [ ] ✅ All sizes use `SizeConstants.*`
- [ ] ✅ All text uses `theme.textTheme.*`
- [ ] ✅ All colors use `theme.*` or `Colours.*`
- [ ] ✅ No hardcoded strings - all use `"${text?.key}"`
- [ ] ✅ No `_buildX()` methods - separate widgets instead
- [ ] ✅ No custom styling on TextFormField/TextField/ElevatedButton
- [ ] ✅ New strings added to both `app_en.arb` AND `app_ar.arb`
- [ ] ✅ Responsive sizing uses `.w`, `.h`, `.sp` where appropriate
- [ ] ✅ `const` constructors used where possible
- [ ] ✅ Widgets are StatelessWidget unless state is needed

---

## 🚀 Quick Reference

### Common Imports:
```dart
import 'package:packageName/core/constants/size_constants.dart';
import 'package:packageName/core/res/styles/colours.dart';
import 'package:packageName/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
```

### Widget Template:
```dart
class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.all(SizeConstants.innerContainerPadding),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(SizeConstants.outerBorderRadius),
      ),
      child: Text(
        "${text?.content}",
        style: theme.textTheme.bodyMedium,
      ),
    );
  }
}
```

### Form Template:
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
        title: Text("${text?.formTitle}"),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(SizeConstants.pageHorizontalPadding),
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: "${text?.name}",
                  hintText: "${text?.enterName}",
                ),
              ),
              const SizedBox(height: SizeConstants.verticalPaddingTwenty),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Handle submit
                  }
                },
                child: Text("${text?.submit}"),
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

## ⚠️ Common Violations and Fixes

### Violation 1: Hardcoded Sizes
```dart
// ❌ WRONG
padding: EdgeInsets.all(16)

// ✅ CORRECT
padding: const EdgeInsets.all(SizeConstants.innerContainerPadding)
```

### Violation 2: Hardcoded Font Sizes
```dart
// ❌ WRONG
Text("Title", style: TextStyle(fontSize: 18))

// ✅ CORRECT
Text("${text?.title}", style: theme.textTheme.titleLarge)


// ✅ CORRECT with fallback
Text(text?.title ?? "Title", style: theme.textTheme.titleLarge)
```

### Violation 3: Multiple Theme Calls
```dart
// ❌ WRONG
Widget build(BuildContext context) {
  return Column(
    children: [
      Text("A", style: Theme.of(context).textTheme.titleLarge),
      Text("B", style: Theme.of(context).textTheme.bodyMedium),
    ],
  );
}

// ✅ CORRECT
Widget build(BuildContext context) {
  final theme = Theme.of(context);
  final text = AppLocalizations.of(context);

  return Column(
    children: [
      Text("${text?.textA}", style: theme.textTheme.titleLarge),
      Text("${text?.textB}", style: theme.textTheme.bodyMedium),
    ],
  );
}
```

### Violation 4: Private Build Methods
```dart
// ❌ WRONG
class MyView extends StatelessWidget {
  Widget _buildTitle() {
    return Text("Title");
  }
}

// ✅ CORRECT
class TitleWidget extends StatelessWidget {
  const TitleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Text(
      "${text?.title}",
      style: theme.textTheme.titleLarge,
    );
  }
}
```

### Violation 5: Hardcoded Strings
```dart
// ❌ WRONG
Text("Leave Request")

// ✅ CORRECT
Text("${text?.leaveRequest}")
```

### Violation 6: Custom TextField Styling
```dart
// ❌ WRONG
TextFormField(
  decoration: InputDecoration(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    fillColor: Colors.white,
  ),
)

// ✅ CORRECT
TextFormField(
  decoration: InputDecoration(
    labelText: "${text?.fieldLabel}",
    hintText: "${text?.fieldHint}",
  ),
)
```

---

## 📝 Summary

**Golden Rules:**
1. **Theme first** - Initialize `theme` and `text` at the top
2. **SizeConstants always** - No hardcoded numbers
3. **Separate widgets** - No `_buildX()` methods
4. **Theme handles forms** - No custom TextFormField/ElevatedButton styling
5. **Localize everything** - Add to both EN and AR files
6. **Colors from theme or Colours class** - No hardcoded colors

Following these guidelines ensures:
- ✅ Consistent UI/UX across the app
- ✅ Easy theme customization
- ✅ Better maintainability
- ✅ Proper localization support
- ✅ Responsive design
- ✅ Clean, readable code

---

**Version**: 1.0
**Last Updated**: October 2025
**Maintained by**: Development Team
