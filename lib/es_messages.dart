/*
 * Developed by Ajmal Muhammad P
 * Contact me @ support@erratums.com
 * https://erratums.com
 * Date created: 09-May-2021
 */

import 'package:es_utils/es_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ESMessage {
  /// A CircularProgressIndicator can be used to display while processing in background
  static Scaffold showProgressIndicator({required String title, bool centerTitle = false}) {
    return Scaffold(
      appBar: AppBar(title: Text(title), centerTitle: centerTitle),
      body: ESProgressIndicator(),
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
  static void showListDialog({
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
  }) {
    final bool multiSelect = multiSelectValues.length == options.length;
    showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              contentPadding: const EdgeInsets.all(6.0),
              title: title == '' ? null : Text(title),
              content: ListView.builder(
                shrinkWrap: true,
                itemCount: options.length,
                itemBuilder: (BuildContext context, int index) {
                  final String soption = '$prefixText ${options[index].toString()} $suffixText';
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

  static void customDialog({
    required final BuildContext context,
    final String? title,
    final Widget? content,
    final Function()? onSubmit,
    final String okBtnText = 'SUBMIT',
  }) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        contentPadding: const EdgeInsets.all(6.0),
        title: Text(title ?? ''),
        content: content,
        actions: [
          TextButton(
            child: const Text('CANCEL'),
            onPressed: Navigator.of(context).pop,
          ),
          TextButton(
            child: Text(okBtnText),
            onPressed: () {
              Navigator.of(context).pop();
              if (onSubmit != null) onSubmit();
            },
          ),
        ],
      ),
    );
  }

  /// Shwos a dialog with single button. Default title will be 'Error'.
  static showErrorMessage(BuildContext context, {String title = 'Error', String? message, bool barrierDismissible = true, Function()? onPressed}) {
    return showConfirmDialog(
      context: context,
      title: title,
      message: message,
      buttonLeft: 'OK',
      onPressed: (aBtnIndex) {
        if (onPressed != null) return onPressed();
      },
    );
  }

  /// Shwos a dialog with single button. Default title will be 'Info'.
  static showInfoMessage(BuildContext context, {String title = 'Info', String? message, bool barrierDismissible = true, Function()? onPressed}) {
    return showConfirmDialog(
      context: context,
      title: title,
      message: message,
      buttonLeft: 'OK',
      onPressed: (aBtnIndex) {
        if (onPressed != null) onPressed();
      },
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
    final bool barrierDismissible = true,
  }) {
    return showDialog(
      context: context,
      useRootNavigator: false,
      barrierDismissible: barrierDismissible,
      useSafeArea: true,
      barrierColor: MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white54 : Colors.black54,
      builder: (_) => CupertinoAlertDialog(
        title: Column(
          children: <Widget>[
            Text(title ?? '', style: TextStyle(color: Colors.blue)),
            SizedBox(height: 10),
          ],
        ),
        content: content ?? Text(message ?? ''),
        actions: [
          CupertinoDialogAction(
            onPressed: () {
              if (autoPop) Navigator.pop(context);
              if (onPressed != null) onPressed(0);
            },
            child: Text(buttonLeft),
          ),
          if (buttonRight != null)
            CupertinoDialogAction(
              onPressed: () {
                if (autoPop) Navigator.pop(context);
                if (onPressed != null) onPressed(1);
              },
              child: Text(buttonRight),
            ),
        ],
      ),
    );
  }
}
