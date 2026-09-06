# Self-Review

Run this over your own diff before reporting a task complete. Read the diff — not your
memory of what you intended to write.

## Comments

The default is **no comment**. Code says what it does; a comment that repeats it is noise
that has to be maintained and will eventually lie.

Delete a comment when it:

- restates the line below it — `// Nothing to open — drop the section` above
  `if (url == null) return const SizedBox.shrink();`
- describes what a well-named method already announces — `/// The pdf for the active
  language` above `String? pdfUrl(...)`
- points at another member instead of saying something — `/// Same fallback as [pdfUrl].`
- narrates the change rather than the code — `// renamed from googleLogin`
- **defines a word already in the line** — see below

Keep a comment when it carries something the reader cannot recover from the code:

- **the policy behind a choice** — `/// Prefer the active language, fall back to the other.`
  on the helper that implements it
- **why, not what** — `// A different url (e.g. the locale changed) deserves its own attempt.`
- **a non-obvious constraint** — `// CachedNetworkImage reports the failure from inside a
  build, so the swap is deferred to the end of the frame.`
- **a deliberate deviation** that would otherwise look like a mistake

When a rule is implemented once and used in several places, document it **at the
implementation**, not at each call site. One comment on `_pick`, none on the getters that
delegate to it.

### A comment above a class or method is a naming test

If you wrote one, exactly one of these is true — decide which before moving on:

- **The name already says it.** Delete the comment.
  `/// Header row with the section title.` above `_SectionHeaderWidget` — the reader
  learned nothing.
- **The name is wrong, and the comment is covering for it.** Rename; then delete the comment.
  `/// Header (eyebrow + title) and the white card beneath it.` above
  `_ProductsCardWidget` — it renders a header *and* a card, so "Card" was a lie. Renaming
  it `_ProductsLoadedWidget` made the comment unnecessary.
- **It says something the name cannot carry** — a rationale, a constraint, a deviation.
  Keep it, and cut it down to only that part.
  `/// A bespoke surface, so it is built directly rather than restyling the themed
  [ElevatedButton].` — the "why not the obvious thing" is the whole value; the description
  of what it looks like was dropped.

The failure mode to watch for: a comment that opens by restating the name and then adds what
looks like the real information. Cut the first half — then put the second half through the
same test, because "the part that isn't the name" is most often the body in prose:

```dart
/// Cached banner art filling the band. While it loads — or if it fails — it
/// stays empty so the band's own colour shows through unchanged.
class _CategoryBandBackgroundWidget extends StatelessWidget {
```

Sentence one is the class name. Sentence two reads `placeholder:` and `errorWidget:` — both
`SizedBox.shrink()`, four lines below — back to the reader, and then explains that an empty
widget shows what is behind it. Neither half survived, so the comment went.

### Be strict: the bar is "the code cannot say this"

**If the name says what the thing is and what it does, it takes no comment.** Things here are
named accurately, so the doc above them is usually dead weight:

```dart
/// Shows the "Add address" bottom sheet — street, city and postcode on one
/// step. Resolves to `true` once the address is saved, so the caller can
/// refresh the list.
Future<bool?> showAddAddressSheet(BuildContext context) {
```

The name gives the first half. The signature gives the second.

Delete these without looking for a reason to keep them:

- **A definition of a word already on the line.** `registerLazySingleton` *means* one shared
  instance created on first use; a comment saying so defines the word `singleton`. Same trap:
  `lazy`, `const`, `late`, `factory`, `debounce`.
- **The body in prose.** Three bullets describing what each enum case renders, when the
  `switch` below returns exactly that — and the analyzer keeps the `switch` honest, not the
  bullets.
- **Design and spec references** — `(design 6a)`, ticket numbers, "as per the Figma". Designs
  get revised and renumbered; the code is what shipped. Which mock it came from helps nobody
  change it.
- **Pointers to other code** — `see AppWideProviderRegistry`, `used by the login form`. `grep`
  answers these exactly and survives renames.

Why be strict, when it's "only a comment": comments don't get updated. The code moves and the
sentence stays, so the default fate of every comment is to become a confident lie. Each one is
a liability taken on to save the reader a few seconds — worth it only when the code genuinely
cannot say the thing.

Two questions when you catch yourself writing one:

- **Who is this for?** If the honest answer is "the reviewer, so they see I chose this on
  purpose", that's an argument about the diff, not a fact about the code. The diff gets merged
  and disappears; the sentence stays, addressed to nobody. The tell is a comment comparing a
  line to its neighbours ("unlike the cubits around it"), or defending a choice nobody has
  questioned.
- **Am I documenting the code, or the thinking that produced it?** A decision that took ten
  minutes and one that took ten seconds compile to the same line. Effort is not a property of
  the code, and the reader cannot see the difference — nor do they need to. When the reasoning
  is fully absorbed by the code, writing it out again restates the spec beside its
  implementation.

## Duplication

- Did you write the same rule twice? Extract it, then comment it once.
- Did you leave the old path in place beside the new one? Delete it.
- Does a doc file now restate something the code or a skill already says?

## Shared transforms — dates, times, money, formatting

Anything that turns raw data into display text, or a string into a typed value, belongs in
an extension, not inline at the call site. The backend is consistent in what it sends and
the UI is consistent in how it shows it, so these are always reused — writing one inline
guarantees a second copy later that drifts.

Two homes, chosen by the type being extended:

- **Dart / Flutter / `core/` types** (`DateTime`, `String`, `num`, `BuildContext`, `Failure`)
  → `lib/core/config/extentions/`.
- **A feature's entity or enum** → `lib/src/<feature>/domain/entities/extensions/`.
  Never in `core/`, which must not import from `lib/src/`.

Before writing a `DateFormat`, a `num` → currency string, or a `String` → `DateTime`:

1. **Look for the extension.** Dates and times → `date_extension.dart`
   (`dayMonth`, `dayMonthYear`, `weekdayDayMonth`, `String?.asDate`).
2. **Extend it if the shape you need is missing** — add the named format there and use it.
   Don't inline "just this once".
3. **Only create a new extension file** if no existing one covers the type — and put it
   in the home the table above dictates.

Checks:

- No `DateFormat(...)` outside `date_extension.dart`.
- Locale is passed for anything user-visible. `DateFormat` silently renders English month
  and day names when it isn't — the bug is invisible until someone opens the app in Arabic.
- **Parsing happens in the model, not the widget.** A widget calling `DateTime.tryParse` on
  a raw string means the entity is carrying a `String` that should have been a `DateTime`.
- The format is named for what it *is* (`dayMonthYear`), not where it's used
  (`productCardDate`) — the next screen needing the same shape should find it.

## Honesty of the diff

- Every claim you're about to make in the summary — is it verified, or inferred? Say which.
- Did you state a hazard without testing it? Test it or drop the claim.
- Anything you skipped or couldn't finish — is it named explicitly?

## Mechanics

- `flutter analyze lib/` → zero errors. Warnings you didn't cause are baseline; leave them.
- Deleted a symbol? `grep` for it across `lib/` — including DI and provider registries.
- New `get_it` type? Confirm the registration exists; the analyzer will not.
- Changed a freezed **state** shape? Run build_runner. Otherwise don't.
- Files you touched: no new warnings attributable to them.

## Scope

- Does the diff do what was asked, and only that?
- Anything you removed — was it dead, or just unfamiliar? Prove it with a `grep`.
