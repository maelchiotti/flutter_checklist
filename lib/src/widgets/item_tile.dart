import 'package:flutter/material.dart';
import 'package:flutter_checklist/checklist.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_checklist/src/utils/extensions/color_extension.dart';

/// Item tile widget.
class ItemTile extends StatefulWidget {
  /// A tile for a checklist item that can be moved, with a checkbox and a modifiable text.
  const ItemTile({
    super.key,
    required this.value,
    this.enabled = true,
    this.checkedReadOnly = false,
    this.autofocus = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.newline,
    this.textCapitalization = TextCapitalization.sentences,
    required this.draggedItemKeyNotifier,
    required this.addedItemKeyNotifier,
    required this.localizations,
    this.onToggled,
    this.onChanged,
    this.onSubmitted,
    this.onRemove,
  }) : assert(
          (enabled &&
                  onToggled != null &&
                  onChanged != null &&
                  onSubmitted != null &&
                  onRemove != null) ||
              !enabled,
          'If the item is enabled, all callbacks must not be null',
        );

  /// The value of this checklist item, with the text and whether it is toggled.
  final ChecklistLine value;

  /// Whether this item is enabled and allows toggling its checkbox, editing and submitting its text and removing itself.
  ///
  /// Defaults to `true`.
  final bool enabled;

  /// Whether this item should be read only if checked.
  final bool checkedReadOnly;

  /// Whether to automatically focus this item.
  final bool autofocus;

  /// The `TextInputType` of the text field.
  final TextInputType keyboardType;

  /// The `TextInputAction` of the text field.
  final TextInputAction textInputAction;

  /// The `TextCapitalization` of the text field.
  final TextCapitalization textCapitalization;

  /// Notifier of the key of the item being dragged in the checklist, to highlight this item when it is.
  final ValueListenable<Key?> draggedItemKeyNotifier;

  /// Notifier of the key of the last item added to the checklist, to focus this item when it is.
  final ValueListenable<Key?> addedItemKeyNotifier;

  /// Custom implementation of [ChecklistLocalizations] to replace the default ones or provide unavailable ones.
  final ChecklistLocalizations localizations;

  /// Called when the checkbox of this item is toggled.
  final void Function(Key, bool)? onToggled;

  /// Called when the text of this item is changed.
  final void Function(Key, String)? onChanged;

  /// Called when the text of this item is submitted.
  final void Function(Key)? onSubmitted;

  /// Called when the remove button is tapped.
  final void Function(Key)? onRemove;

  @override
  State<ItemTile> createState() => _ItemTileState();
}

class _ItemTileState extends State<ItemTile> {
  late bool toggled;
  late TextEditingController textController;
  late bool hasFocus;

  @override
  void initState() {
    assert(widget.key != null, 'Missing key for checklist item');

    super.initState();

    toggled = widget.value.toggled;
    textController = TextEditingController(text: widget.value.text);
    hasFocus = false;
  }

  void onToggled(bool? toggled) {
    if (toggled == null) {
      return;
    }

    setState(() {
      this.toggled = toggled;
    });

    widget.onToggled!(widget.key!, toggled);
  }

  void onChanged(String text) {
    widget.onChanged!(widget.key!, text);
  }

  void onSubmitted(String text) {
    widget.onSubmitted!(widget.key!);
  }

  void onRemove() {
    widget.onRemove!(widget.key!);
  }

  void onFocusChange(bool hasFocus) {
    setState(() {
      this.hasFocus = hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bodyLarge = Theme.of(context).textTheme.bodyLarge;
    final subduedColor = bodyLarge?.color?.subdued;
    final bodyLargeLineThrough = bodyLarge?.copyWith(
      color: subduedColor,
      decoration: TextDecoration.lineThrough,
      decorationColor: subduedColor,
    );

    return Material(
      child: FocusScope(
        onFocusChange: onFocusChange,
        child: ValueListenableBuilder(
            valueListenable: widget.draggedItemKeyNotifier,
            builder: (context, draggedItemKey, child) {
              final tileColor = draggedItemKey == widget.key
                  ? Theme.of(context).colorScheme.surfaceContainerHigh
                  : null;

              return ListTile(
                tileColor: tileColor,
                leading: Checkbox(
                  value: toggled,
                  visualDensity: VisualDensity.compact,
                  onChanged: widget.enabled ? onToggled : null,
                ),
                title: ValueListenableBuilder(
                    valueListenable: widget.addedItemKeyNotifier,
                    builder: (context, addedItemKey, child) {
                      // Make the text field read only if the checklist widget is disabled,
                      // or if the item is checked and the checklist widget is set to make checked items read only
                      final readonly = !widget.enabled ||
                          (toggled && widget.checkedReadOnly);

                      // Automatically focus the text field if the checklist widget is set to autofocus the first line,
                      // or if the item's key corresponds to the last added item
                      final autofocus =
                          widget.autofocus || addedItemKey == widget.key;

                      return TextField(
                        controller: textController,
                        readOnly: readonly,
                        autofocus: autofocus,
                        keyboardType: widget.keyboardType,
                        textInputAction: widget.textInputAction,
                        textCapitalization: widget.textCapitalization,
                        maxLines: 1,
                        style: toggled ? bodyLargeLineThrough : bodyLarge,
                        decoration: InputDecoration.collapsed(
                          hintText: widget.localizations.hint_entry,
                        ),
                        onChanged: onChanged,
                        onSubmitted: onSubmitted,
                      );
                    }),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (hasFocus && widget.enabled)
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: onRemove,
                      ),
                    if (widget.enabled) Icon(Icons.drag_indicator)
                  ],
                ),
                visualDensity: VisualDensity.compact,
                contentPadding: EdgeInsets.only(left: 16, right: 8),
              );
            }),
      ),
    );
  }
}
