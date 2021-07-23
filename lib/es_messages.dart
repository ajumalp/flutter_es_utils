/*
 * Developed by Ajmal Muhammad P
 * Contact me @ support@erratums.com
 * https://erratums.com
 * Date created: 09-May-2021
 */

import 'package:es_utils/es_theme.dart';
import 'package:es_utils/es_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ESMessage {
  /// A CircularProgressIndicator can be used to display while processing in background
  static Scaffold showProgressIndicator({required String title, bool centerTitle = false}) {
    return Scaffold(
      appBar: AppBar(title: Text(title), centerTitle: centerTitle),
      body: ESProgressIndicator(),
    );
  }

  static Future showModalDialog(
    BuildContext context, {
    Widget? content,
    bool barrierDismissible = false,
    BoxConstraints? constraints = const BoxConstraints(maxWidth: 850, maxHeight: 750),
  }) {
    return showDialog(
      context: context,
      barrierColor: Colors.white54,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Container(
            constraints: constraints,
            child: content,
          ),
        );
      },
    );
  }

  /// Shows a dialog with list of items to select
  ///
  /// [options] the list of items to display
  ///
  /// [title] the title of the dialog
  ///
  /// [prefixText] text to be added before each item
  ///
  /// [suffixText] text to be added after each item
  ///
  /// [onSelection] the event triggered when an item is selected
  ///
  /// [prefixText] or [suffixText] won't send with [onSelection].
  /// Only the selected value in the [options] will be used in [onSelection]
  ///
  /// [selectedValue] similar to default value. You can set the initial selected value
  ///
  /// [multiSelectValues] if you want to diplay a checkbox for each item, pass a boolean list
  /// with exactly same number count of options
  ///
  /// [okBtnText] title for accept button. Default title is 'Submit'.
  ///
  /// [onSubmit] this function will be called when the okBtnText button is pressed
  static Future showListDialog({
    required final BuildContext context,
    required final List options,
    final String title = '',
    final String prefixText = '',
    final String suffixText = '',
    final Function(int, dynamic)? onSelection,
    final selectedValue,
    final List<bool> multiSelectValues = const [],
    final String okBtnText = 'Submit',
    final Function(List<bool>)? onSubmit,
    bool barrierDismissible = true,
    BoxConstraints constraints = const BoxConstraints(maxWidth: 850, maxHeight: 750),
  }) {
    final bool multiSelect = multiSelectValues.length == options.length;

    return showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              contentPadding: const EdgeInsets.all(6.0),
              title: title == '' ? null : Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
              content: Container(
                width: 300,
                constraints: constraints,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: options.length,
                  itemBuilder: (BuildContext context, int index) {
                    final String soption = '$prefixText ${options[index].toString()} $suffixText'.trim();
                    return ListTile(
                      leading: () {
                        if (multiSelect) {
                          return Checkbox(
                            value: multiSelectValues[index],
                            onChanged: (value) {
                              multiSelectValues[index] = value ?? false;
                              setState(() {});
                            },
                          );
                        } else {
                          return null;
                        }
                      }(),
                      selectedTileColor: Colors.black12,
                      selected: () {
                        if (multiSelect || selectedValue == null) return false;
                        return options[index] == selectedValue;
                      }(),
                      title: Text(soption),
                      onTap: () {
                        if (onSelection != null) onSelection(index, options[index]);
                      },
                    );
                  },
                ),
              ),
              actions: () {
                if (!multiSelect) return null;
                return [
                  TextButton(
                    child: const Text('CANCEL'),
                    onPressed: Navigator.of(context).pop,
                  ),
                  TextButton(
                    child: Text(okBtnText),
                    onPressed: () {
                      Navigator.of(context).pop();
                      if (onSubmit != null) onSubmit(multiSelectValues);
                    },
                  ),
                ];
              }(),
            );
          },
        );
      },
    );
  }

  /// Shows a dialog which can accept input text
  ///
  /// [title] title for the dialog
  ///
  /// [hitText] caption for the edit field
  ///
  /// [onSubmit] function called when the Submit button is pressed
  ///
  /// [defaultValue] the default value to be set into the edit field
  static void showInputDialog({
    required final BuildContext context,
    required final String title,
    final String? hitText,
    final Function(TextEditingController)? onSubmit,
    final String? defaultValue,
  }) {
    final TextEditingController controller = TextEditingController(text: defaultValue);

    ESMessage.customDialog(
      context: context,
      title: title,
      onSubmit: () {
        if (onSubmit != null) onSubmit(controller);
      },
      content: () {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(height: 15),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: TextField(
                decoration: InputDecoration(
                  isDense: true,
                  border: const OutlineInputBorder(borderRadius: const BorderRadius.all(const Radius.circular(10))),
                  filled: false,
                  hintStyle: const TextStyle(color: Colors.grey),
                  hintText: hitText ?? '',
                  labelText: hitText ?? '',
                  suffixIcon: () {
                    return InkWell(
                      child: const Icon(Icons.cancel),
                      onTap: () => controller.clear(),
                    );
                  }(),
                ),
                autofocus: true,
                controller: controller,
              ),
            ),
          ],
        );
      }(),
    );
    // Make the field as selected by default
    controller.selection = TextSelection(baseOffset: 0, extentOffset: controller.text.length);
  }

  static Future<T?> customDialog<T>({
    required final BuildContext context,
    required final Widget content,
    final String? title,
    final bool autoPop = true,
    final bool barrierDismissible = true,
    final Function()? onSubmit,
    final Function()? onCancel,
    final String okBtnText = 'SUBMIT',
  }) {
    void _doSubmit() {
      if (autoPop) Navigator.of(context).pop();
      if (onSubmit != null) onSubmit();
    }

    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) => AlertDialog(
        contentPadding: const EdgeInsets.all(6.0),
        titlePadding: const EdgeInsets.only(top: 20, bottom: 10, right: 15, left: 15),
        title: Text(title ?? '', style: TextStyle(fontWeight: FontWeight.bold)),
        content: content,
        actionsOverflowDirection: VerticalDirection.down,
        actions: [
          TextButton(
            child: const Text('CANCEL'),
            onPressed: () {
              Navigator.of(context).pop();
              if (onCancel != null) onCancel();
            },
          ),
          TextButton(
            child: Text(okBtnText),
            onPressed: () => _doSubmit(),
          ),
        ],
      ),
    );
  }

  /// Shwos a dialog with single button. Default title will be 'Error'.
  static showErrorMessage(
    BuildContext context, {
    String title = 'Error',
    String? message,
    bool barrierDismissible = false,
    Function()? onPressed,
  }) {
    return showConfirmDialog(
      context: context,
      title: title,
      message: message,
      buttonLeft: 'OK',
      barrierDismissible: barrierDismissible,
      onPressed: (aBtnIndex) {
        if (onPressed != null) return onPressed();
      },
    );
  }

  /// Shwos a dialog with single button. Default title will be 'Info'.
  static showInfoMessage(
    BuildContext context, {
    String title = 'Info',
    String? message,
    bool barrierDismissible = false,
    Function()? onPressed,
  }) {
    return showConfirmDialog(
      context: context,
      title: title,
      message: message,
      buttonLeft: 'OK',
      barrierDismissible: barrierDismissible,
      onPressed: (aBtnIndex) {
        if (onPressed != null) onPressed();
      },
    );
  }

  static showQuestionMessage({
    required BuildContext context,
    final String? title,
    final String? message,
    final Widget? content,
    final bool autoPop = true,
    final Function? onAccept,
    final Function? onReject,
    final bool barrierDismissible = true,
  }) {
    return showConfirmDialog(
      context: context,
      buttonLeft: 'No',
      buttonRight: 'Yes',
      title: title,
      message: message,
      content: content,
      autoPop: autoPop,
      onPressed: (index) {
        if (index == 1 && onAccept != null) {
          onAccept();
        } else if (index == 0 && onReject != null) {
          onReject();
        }
      },
      barrierDismissible: barrierDismissible,
    );
  }

  /// Shwos a confirmation dialog
  ///
  /// [title] title for the dialog
  ///
  /// [message] Text message to be diplayed
  ///
  /// [content] can be used to override [message].
  /// If [content] is set, [message] won't be used
  ///
  /// [buttonLeft] this is the primary button. This cannot be null.
  /// If you have multiple buttons, then this will be displayed on left side
  ///
  /// [buttonRight] an optional button to be displayed on right side
  ///
  /// [autoPop] default to true. If false, `Navigator.pop(context)` won't be called
  ///
  /// [onPressed] will be called when we press any button with button index as parameter
  /// **Index** 0 => Left button and 1 => Right button
  static showConfirmDialog({
    required BuildContext context,
    final String? title,
    final String? message,
    final Widget? content,
    required final String buttonLeft,
    final String? buttonRight,
    final bool autoPop = true,
    final Function(int)? onPressed,
    final bool barrierDismissible = false,
  }) {
    return showDialog(
      context: context,
      useRootNavigator: false,
      barrierDismissible: barrierDismissible,
      useSafeArea: true,
      barrierColor: ESTheme.barrierColor(context),
      builder: (BuildContext context) => RawKeyboardListener(
        autofocus: true,
        focusNode: FocusNode(),
        onKey: (event) {
          if (event.isKeyPressed(LogicalKeyboardKey.enter) || event.isKeyPressed(LogicalKeyboardKey.numpadEnter)) {
            if (autoPop) Navigator.pop(context);
            if (onPressed != null) onPressed(1);
          }
        },
        child: CupertinoAlertDialog(
          title: Column(
            children: <Widget>[
              Text(title ?? ''),
              const SizedBox(height: 10),
            ],
          ),
          content: content ?? Text(message ?? ''),
          actions: [
            Tooltip(
              message: '[Esc]',
              child: CupertinoDialogAction(
                onPressed: () {
                  if (autoPop) Navigator.pop(context);
                  if (onPressed != null) onPressed(0);
                },
                child: Text(buttonLeft, style: TextStyle(color: ESTheme.textColor(context))),
              ),
            ),
            if (buttonRight != null)
              Tooltip(
                message: '[Press Enter]',
                child: CupertinoDialogAction(
                  onPressed: () {
                    if (autoPop) Navigator.pop(context);
                    if (onPressed != null) onPressed(1);
                  },
                  child: Text(buttonRight, style: TextStyle(fontWeight: FontWeight.w600, color: ESTheme.textColor(context))),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
