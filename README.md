# flutter_checklist

![Pub Version](https://img.shields.io/pub/v/flutter_checklist)

A widget to display a checklist.

![Screen recording of the example app](https://raw.githubusercontent.com/maelchiotti/flutter_checklist/refs/heads/main/doc/screen_recordings/screen_recording_cropped.gif)

## Installing

See the [installing instructions](https://pub.dev/packages/flutter_checklist/install).

## Features

- Display a checklist
- Toggle items and edit their text
- Reorder items
- Add new items (either after the submitted one or at the end)
- Remove items
- Make the checklist read only

## Usage

### ChecklistLine

The `ChecklistLine` type is a [record](https://dart.dev/language/records) that represents a line (an item, an entry) of the checklist. It contains the text of that line and whether it is toggled.

A list of `ChecklistLine` represents a checklist with all its lines. The order of the list directly determines the order of the items in the checklist.

### Checklist

The `Checklist` widget displays your list of `ChecklistLine` as a checklist.

It requires as arguments the list of `ChecklistLine` to display, and a callback function to execute when any modification is performed on that list with the new list of `ChecklistLine`.

The list of `ChecklistLine` is only read when the widget is created. To reset the checklist with other lines, also give it a new `key`.

A checklist can be made read only by setting the `enabled` parameter to `false`, which disables any modification to the checklist lines as well as their reordering.

```dart
// The list of five ChecklistLine to display with their text and whether they are toggled
final lines = List.generate(
  5,
  (index) => (text: 'Line ${index + 1}', toggled: false),
);

// The function to execute when the checklist is modified, with the new list of ChecklistLine
void onChanged(List<ChecklistLine> lines) {
  log(lines.toString());
}

// The checklist widget
Checklist(
  lines: lines,
  onChanged: onChanged,
);
```

### Localization

#### Embedded

This package supports localization. To enable it in your app, add the localizations delegates to your `MaterialApp`:

```dart
MaterialApp(
  localizationsDelegates: [
    ChecklistLocalizations.delegate,
    // Any other localizations delegates, from your app or other packages
  ],
);
```

The following localizations are currently supported (ordered alphabetically):

- English
- French

To add support for a new localization or improve an existing one, please open an [issue](https://github.com/maelchiotti/flutter_checklist/issues).

#### Custom

To provide your own localizations (to replace the embedded ones are provide missing ones), implement the `ChecklistLocalizations` class (for examples, look at the [generated ones](https://github.com/maelchiotti/flutter_checklist/tree/main/lib/l10n/checklist_localizations)) and pass it to the `localizations` parameter:

```dart
Checklist(
  lines: lines,
  onChanged: onChanged,
  localizations: CustomChecklistLocalizations(),
)
```

## Example

See the [example app](https://pub.dev/packages/flutter_checklist/example).
