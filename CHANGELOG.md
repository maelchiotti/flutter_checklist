# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project
adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## Unreleased

- Apply the `keyboardType`, `textInputAction` and `textCapitalization` options to the items, with `TextInputAction.newline` and `TextCapitalization.sentences` as the new defaults to keep the current behavior.
- Keep the focus node and the notifiers per checklist, so that several checklists don't interfere, and deprecate `Checklist.keepKeyboardFocusNode`.
- Pass a copy of the lines to `onChanged`.
- Document that the lines are only read when the checklist is created.

## 1.5.5

- Add options to customize the keyboard of the checklist items text field.

## 1.5.4

- Keep the keyboard on screen when adding a new item.

## 1.5.3

- Default localizations to english if missing.

## 1.5.2

- Update dependencies.

## 1.5.1

- Make checklist item text field use sentence capitalization.

## 1.5.0

- Add `autofocusFirstLine` to automatically focus the first checklist line (useful when creating the checklist for the first time with an empty line)

## 1.4.1

- Make checklist item hint visible even when disabled

## 1.4.0

- Add `localizations` parameter to allow providing custom localizations

## 1.3.0

- Add hint text in empty checklist items

## 1.2.0

- Add boolean parameter `checkedReadOnly` to control whether checked items are read only (defaults to `false`)

## 1.1.3

- Fix checklist tile background color when dragged

## 1.1.2

- Fix error when creating an item in an empty checklist
- Fix localization instructions in README.md

## 1.1.1

- Fix typo in README.md

## 1.1.0

- Move drag handle to the right
- Reduce time to hold the tile to drag it from 500ms to 250ms

## 1.0.1

- Fix README
- Fix example

## 1.0.0

Initial release.
