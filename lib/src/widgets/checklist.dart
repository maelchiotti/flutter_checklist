import 'package:animated_reorderable_list/animated_reorderable_list.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_checklist/checklist.dart';
import 'package:flutter_checklist/l10n/checklist_localizations/checklist_localizations_en.g.dart';
import 'package:flutter_checklist/src/widgets/item_tile.dart';
import 'package:flutter_checklist/src/widgets/keep_keyboard_on_screen.dart';
import 'package:flutter_checklist/src/widgets/new_item_button.dart';

/// Checklist widget.
class Checklist extends StatefulWidget {
  /// A checklist with a list of [lines].
  ///
  /// The [lines] correspond to the entries in the checklist, with a text and whether they are toggled.
  /// They are only read when the checklist is created: to replace them afterwards, also give the checklist a new
  /// [key].
  ///
  /// On each change in the checklist (a line is added, removed, toggled or its text is changed),
  /// the [onChanged] callback is fired with a copy of the new list of lines.
  ///
  /// Set [enabled] to false to disable editing and toggling of the lines.
  ///
  /// Set [checkedReadOnly] to make checked lines read only.
  ///
  /// Set [autofocusFirstLine] to automatically focus the first line
  /// (useful when creating the checklist for the first time with an empty line).
  ///
  /// Override [localizations] to provide your own.
  const Checklist({
    super.key,
    required this.lines,
    this.enabled = true,
    this.checkedReadOnly = false,
    this.autofocusFirstLine = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.newline,
    this.textCapitalization = TextCapitalization.sentences,
    required this.onChanged,
    this.localizations,
  });

  /// The list of entries to display in the checklist, with a text and whether they are toggled.
  ///
  /// They are only read when the checklist is created: changing them afterwards has no effect. To reset the checklist
  /// with new lines, also give it a new `key`, for example a `ValueKey` of the lines or of their source.
  ///
  /// ```dart
  /// Checklist(
  ///   // A new key creates a new checklist from the new lines
  ///   key: ValueKey(note.id),
  ///   lines: note.lines,
  ///   onChanged: (lines) => note.lines = lines,
  /// )
  /// ```
  final List<ChecklistLine> lines;

  /// Whether this checklist is enabled and allow editing its items.
  ///
  /// Defaults to `true`.
  final bool enabled;

  /// Whether the checked items should be read only.
  final bool checkedReadOnly;

  /// Whether to automatically focus the first line when the checklist is created.
  final bool autofocusFirstLine;

  /// The `TextInputType` of the checklist items `TextField`.
  ///
  /// Defaults to `TextInputType.text`.
  final TextInputType keyboardType;

  /// The `TextInputAction` of the checklist items `TextField`.
  ///
  /// Defaults to `TextInputAction.newline`.
  final TextInputAction textInputAction;

  /// The `TextCapitalization` of the checklist items `TextField`.
  ///
  /// Defaults to `TextCapitalization.sentences`.
  final TextCapitalization textCapitalization;

  /// Custom implementation of [ChecklistLocalizations] to replace the default ones or provide unavailable ones.
  ///
  /// For an example on how to implement this class, look at any generated implementation for the already supported
  /// languages: <https://github.com/maelchiotti/flutter_checklist/tree/main/lib/l10n/checklist_localizations>.
  final ChecklistLocalizations? localizations;

  /// Called when a line in the checklist is added, removed, toggled or its text is changed with the new list of lines.
  ///
  /// The list is a copy, that the checklist doesn't change afterwards.
  final void Function(List<ChecklistLine>) onChanged;

  @override
  State<Checklist> createState() => _ChecklistState();
}

class _ChecklistState extends State<Checklist> {
  late final List<Key> keys;
  late final List<ChecklistLine> values;

  /// Focus node of the placeholder `TextField` that keeps the keyboard on screen when adding a new item.
  final keepKeyboardFocusNode =
      FocusNode(debugLabel: 'Keep keyboard on screen');

  /// Notifier of the key of the item being dragged, or `null` if none is.
  final draggedItemKeyNotifier = ValueNotifier<Key?>(null);

  /// Notifier of the key of the last added item, or `null` if none was added.
  final addedItemKeyNotifier = ValueNotifier<Key?>(null);

  @override
  void initState() {
    super.initState();

    keys = List.generate(widget.lines.length, (_) => UniqueKey());
    values = List.from(widget.lines);
  }

  @override
  void dispose() {
    keepKeyboardFocusNode.dispose();
    draggedItemKeyNotifier.dispose();
    addedItemKeyNotifier.dispose();

    super.dispose();
  }

  void onReorderStart(int index) {
    final key = keys[index];

    draggedItemKeyNotifier.value = key;
  }

  void onReorder(int oldIndex, int newIndex) {
    setState(() {
      final item = keys.removeAt(oldIndex);
      final value = values.removeAt(oldIndex);

      keys.insert(newIndex, item);
      values.insert(newIndex, value);
    });

    widget.onChanged(List.of(values));
  }

  void onReorderEnd(int index) {
    draggedItemKeyNotifier.value = null;
  }

  void updateToggled(Key key, bool toggled) {
    final index = keys.indexWhere((k) => k == key);
    final value = (text: values[index].text, toggled: toggled);

    values[index] = value;

    widget.onChanged(List.of(values));
  }

  void updateText(Key key, String text) {
    final index = keys.indexWhere((k) => k == key);
    final value = (text: text, toggled: values[index].toggled);

    values[index] = value;

    widget.onChanged(List.of(values));
  }

  void addItem(Key? key) {
    keepKeyboardFocusNode.requestFocus();

    setState(() {
      final index = key != null ? keys.indexWhere((k) => k == key) + 1 : 0;
      final newKey = UniqueKey();
      final value = (text: '', toggled: false);

      keys.insert(index, newKey);
      values.insert(index, value);

      addedItemKeyNotifier.value = newKey;
    });

    widget.onChanged(List.of(values));
  }

  void removeItem(Key key) {
    setState(() {
      final index = keys.indexWhere((k) => k == key);

      keys.removeAt(index);
      values.removeAt(index);
    });

    widget.onChanged(List.of(values));
  }

  @override
  Widget build(BuildContext context) {
    // Changing the duration is buggy in debug mode
    final duration = kReleaseMode ? Duration(milliseconds: 150) : null;

    // Use the custom user localizations, or else those for the current locale, or else those in english
    final localizations = widget.localizations ??
        ChecklistLocalizations.of(context) ??
        ChecklistLocalizationsEn();

    return widget.enabled
        ? ListView(
            children: [
              KeepKeyboardOnScreen(
                focusNode: keepKeyboardFocusNode,
                keyboardType: widget.keyboardType,
                textInputAction: widget.textInputAction,
                textCapitalization: widget.textCapitalization,
              ),
              AnimatedReorderableListView(
                items: keys,
                itemBuilder: (context, index) {
                  return ItemTile(
                    key: keys[index],
                    value: values[index],
                    checkedReadOnly: widget.checkedReadOnly,
                    autofocus: widget.autofocusFirstLine && index == 0,
                    keyboardType: widget.keyboardType,
                    textInputAction: widget.textInputAction,
                    textCapitalization: widget.textCapitalization,
                    draggedItemKeyNotifier: draggedItemKeyNotifier,
                    addedItemKeyNotifier: addedItemKeyNotifier,
                    onChanged: updateText,
                    onToggled: updateToggled,
                    onSubmitted: addItem,
                    onRemove: removeItem,
                    localizations: localizations,
                  );
                },
                isSameItem: (Key key, Key otherKey) => key == otherKey,
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                dragStartDelay: Duration(milliseconds: 250),
                onReorderStart: onReorderStart,
                onReorder: onReorder,
                onReorderEnd: onReorderEnd,
                insertDuration: duration,
                removeDuration: duration,
              ),
              NewItemButton(
                onTap: () => addItem(keys.lastOrNull),
                localizations: localizations,
              ),
            ],
          )
        : ListView.builder(
            itemCount: keys.length,
            itemBuilder: (context, index) {
              return ItemTile(
                key: keys[index],
                value: values[index],
                enabled: false,
                draggedItemKeyNotifier: draggedItemKeyNotifier,
                addedItemKeyNotifier: addedItemKeyNotifier,
                localizations: localizations,
              );
            },
          );
  }
}
