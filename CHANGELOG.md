# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## 2.1.0 - 2026-11-16

### Added

- Add the `toggleable` option to allow toggling the lines of a disabled checklist, without editing, removing, adding or reordering them.
- Add the `reorderable` option to allow reordering the lines of a disabled checklist, without editing, removing or adding them.

### Fixed

- Fix an error when dragging a line whose text field was focused.

## 2.0.0 - 2026-11-15

### BREAKING CHANGES

- Remove `Checklist.keepKeyboardFocusNode`, each checklist now has its own focus node.
- Require Flutter 3.41 or later.

### Fixed

- Apply the `keyboardType`, `textInputAction` and `textCapitalization` options to the items, with `TextInputAction.newline` and `TextCapitalization.sentences` as the new defaults to keep the current behavior.
- Keep the focus node and the notifiers per checklist, so that several checklists don't interfere.
- Pass a copy of the lines to `onChanged`.
- Document that the lines are only read when the checklist is created.
- Display the items with Flutter's `ReorderableListView` instead of `animated_reorderable_list`, which fixes the focus not being given to an item added after a line that is not the last one, and only builds the visible items.

### Changed

- Adding and removing an item are no longer animated.

## 1.5.5 - 2025-08-08

### Added

- Add options to customize the keyboard of the checklist items text field.

## 1.5.4 - 2025-08-08

### Fixed

- Keep the keyboard on screen when adding a new item.

## 1.5.3 - 2025-06-13

### Fixed

- Default localizations to english if missing.

## 1.5.2 - 2025-06-13

### Changed

- Update dependencies.

## 1.5.1 - 2025-03-19

### Changed

- Make checklist item text field use sentence capitalization.

## 1.5.0 - 2025-02-12

### Added

- Add `autofocusFirstLine` to automatically focus the first checklist line (useful when creating the checklist for the first time with an empty line).

## 1.4.1 - 2025-02-11

### Fixed

- Make checklist item hint visible even when disabled.

## 1.4.0 - 2025-02-10

### Added

- Add `localizations` parameter to allow providing custom localizations.

## 1.3.0 - 2025-02-10

### Added

- Add hint text in empty checklist items.

## 1.2.0 - 2025-02-02

### Added

- Add boolean parameter `checkedReadOnly` to control whether checked items are read only (defaults to `false`).

## 1.1.3 - 2025-02-02

### Fixed

- Fix checklist tile background color when dragged.

## 1.1.2 - 2025-02-02

### Fixed

- Fix error when creating an item in an empty checklist.
- Fix localization instructions in README.md.

## 1.1.1 - 2025-02-02

### Fixed

- Fix typo in README.md.

## 1.1.0 - 2024-12-31

### Changed

- Move drag handle to the right.
- Reduce time to hold the tile to drag it from 500ms to 250ms.

## 1.0.1 - 2024-12-15

### Fixed

- Fix README.
- Fix example.

## 1.0.0 - 2024-12-13

Initial release.
