# flutter_checklist

Flutter package published on pub.dev: a `Checklist` widget with checkable, editable and reorderable items. BSD-3-Clause.

Apps display and store their checklists with it: treat any change of a public signature or of the default behavior as breaking.

## Commands

The Flutter version is pinned in `.fvmrc`. Locally, run Flutter and Dart through `fvm` (`fvm flutter ...`, `fvm dart ...`).

- Install: `flutter pub get` (and in `example`).
- Format: `dart format <files>` (default width, 80).
- Analyze: `dart analyze --fatal-infos`.
- Localizations: `flutter gen-l10n` (config in `l10n.yaml`). The generated files of `lib/l10n/checklist_localizations` are committed: regenerate and commit them with each ARB change, never edit them by hand.
- Example: `cd example && flutter run`.
- Publish: `dart pub publish --dry-run` only; the maintainer publishes (`make publish`).

There are no tests. The `check` skill runs every check and the `release` skill prepares a version.

Running `flutter pub get` with a newer Flutter rewrites `example/pubspec.lock`: only commit it when the dependencies are meant to change.

## Structure

- `lib/checklist.dart` exports the public API: `Checklist`, `ChecklistLine` and `ChecklistLocalizations`.
- `lib/src/widgets/checklist.dart`: the `Checklist` widget. It keeps a `UniqueKey` per line next to the values, renders them with `animated_reorderable_list`, and calls `onChanged` with the whole new list after each change (added, removed, toggled, edited, reordered).
- `lib/src/widgets/item_tile.dart`: one line (checkbox, text field, drag handle, delete button). `new_item_button.dart`: the button that adds a line. `keep_keyboard_on_screen.dart`: a hidden text field that keeps the keyboard open while a new line gets the focus.
- `lib/src/utils`: `ChecklistLine` (`({String text, bool toggled})`), the global notifiers of the dragged and added keys, the subdued alpha, color extensions.
- `lib/l10n/translations`: `checklist_en.arb` (source) and `checklist_fr.arb`. Every new text goes in both, with an `@key` description. Users can pass their own `ChecklistLocalizations`; missing locales fall back to English.

## Code style

- `flutter_lints` with `strict-inference`, `public_member_api_docs`, `always_use_package_imports`, `always_put_control_body_on_new_line`, `curly_braces_in_flow_control_structures` and `unawaited_futures`.
- Package imports (`package:flutter_checklist/...`).
- Every public member has a `///` doc comment, and every constructor parameter is documented on its field and summed up in the constructor comment.
- New options have a default that keeps the current behavior, and are shown in `example/lib/main.dart` and the README.

## Git

Every issue and pull request has a label for its kind: `bug`, `enhancement` or `documentation`. A pull request gets the label of its issue.

Commits on `main`, and a `vX.Y.Z` commit for each version. `CHANGELOG.md` has one `## X.Y.Z` section per version with one sentence per change.
