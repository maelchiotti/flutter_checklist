import 'package:flutter/gestures.dart';
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
  /// Set [toggleable] to allow toggling the lines when the checklist is disabled.
  ///
  /// Set [reorderable] to allow reordering the lines when the checklist is disabled.
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
    this.toggleable = false,
    this.reorderable = false,
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

  /// Whether the lines of this checklist can be toggled when it is not [enabled].
  ///
  /// When the checklist is not [enabled] but is toggleable, its lines can be toggled, but not edited, removed, added or
  /// reordered, unless [reorderable] is `true`: for example a checklist in a reading mode. When the checklist is
  /// [enabled], its lines can always be toggled.
  ///
  /// Defaults to `false`.
  final bool toggleable;

  /// Whether the lines of this checklist can be reordered when it is not [enabled].
  ///
  /// When the checklist is not [enabled] but is reorderable, its lines can be dragged to another position, but not
  /// edited, removed or added, and they can only be toggled if [toggleable] is `true`: for example a checklist in a
  /// reading mode that still lets the user sort its lines. When the checklist is [enabled], its lines can always be
  /// reordered.
  ///
  /// Defaults to `false`.
  final bool reorderable;

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
  final keepKeyboardFocusNode = FocusNode(
    debugLabel: 'Keep keyboard on screen',
  );

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

  void onReorderItem(int oldIndex, int newIndex) {
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
    // Use the custom user localizations, or else those for the current locale, or else those in english
    final localizations = widget.localizations ??
        ChecklistLocalizations.of(context) ??
        ChecklistLocalizationsEn();

    // A disabled checklist that is not reorderable is a plain list, with no drag and drop
    if (!widget.enabled && !widget.reorderable) {
      return ListView.builder(
        itemCount: keys.length,
        itemBuilder: (context, index) {
          return ItemTile(
            key: keys[index],
            value: values[index],
            enabled: false,
            toggleable: widget.toggleable,
            onToggled: updateToggled,
            draggedItemKeyNotifier: draggedItemKeyNotifier,
            addedItemKeyNotifier: addedItemKeyNotifier,
            localizations: localizations,
          );
        },
      );
    }

    return ReorderableListView.builder(
      // The header and the footer only exist when the checklist is enabled, to edit it
      header: widget.enabled
          ? KeepKeyboardOnScreen(
              focusNode: keepKeyboardFocusNode,
              keyboardType: widget.keyboardType,
              textInputAction: widget.textInputAction,
              textCapitalization: widget.textCapitalization,
            )
          : null,
      footer: widget.enabled
          ? NewItemButton(
              onTap: () => addItem(keys.lastOrNull),
              localizations: localizations,
            )
          : null,
      itemCount: keys.length,
      itemBuilder: (context, index) {
        return _DelayedDragStartListener(
          key: keys[index],
          index: index,
          child: ItemTile(
            key: keys[index],
            value: values[index],
            enabled: widget.enabled,
            toggleable: widget.toggleable,
            reorderable: widget.reorderable,
            checkedReadOnly: widget.checkedReadOnly,
            autofocus:
                widget.enabled && widget.autofocusFirstLine && index == 0,
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction,
            textCapitalization: widget.textCapitalization,
            draggedItemKeyNotifier: draggedItemKeyNotifier,
            addedItemKeyNotifier: addedItemKeyNotifier,
            onChanged: widget.enabled ? updateText : null,
            onToggled: updateToggled,
            onSubmitted: widget.enabled ? addItem : null,
            onRemove: widget.enabled ? removeItem : null,
            localizations: localizations,
          ),
        );
      },
      // The whole item starts the drag after a short press, instead of the default handles
      buildDefaultDragHandles: false,
      // A lower elevation than the default one (6) for the dragged item
      proxyDecorator: (child, index, animation) {
        return AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            return Material(
              elevation: Curves.easeInOut.transform(animation.value) * 2,
              color: Colors.transparent,
              child: child,
            );
          },
          child: child,
        );
      },
      onReorderStart: onReorderStart,
      onReorderItem: onReorderItem,
      onReorderEnd: onReorderEnd,
    );
  }
}

/// Starts dragging an item after it is pressed for [_dragStartDelay].
///
/// Same as [ReorderableDelayedDragStartListener], with a shorter delay than the default long press.
class _DelayedDragStartListener extends ReorderableDragStartListener {
  const _DelayedDragStartListener({
    super.key,
    required super.child,
    required super.index,
  });

  static const _dragStartDelay = Duration(milliseconds: 250);

  @override
  MultiDragGestureRecognizer createRecognizer() {
    return DelayedMultiDragGestureRecognizer(
      delay: _dragStartDelay,
      debugOwner: this,
    );
  }
}
