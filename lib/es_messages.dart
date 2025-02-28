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

  static CupertinoAlertDialog showProgressBar({final String title = 'Processing', final String message = 'Please wait ... !'}) {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Row(children: <Widget>[
        const CircularProgressIndicator(),
        const SizedBox(width: 30),
        Text(message),
      ]),
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
    final String? subTitle,
    final String prefixText = '',
    final String suffixText = '',
    final selectedValue,
    Color? primaryColor,
    final Function(int, dynamic)? onSelection,
    final List<bool> multiSelectValues = const [],
    final String okBtnText = 'Submit',
    final Function(List<bool>)? onSubmit,
    bool barrierDismissible = true,
    BoxConstraints constraints = const BoxConstraints(maxWidth: 850, maxHeight: 750),
  }) {
    primaryColor = primaryColor ?? Theme.of(context).primaryColor;
    final bool multiSelect = multiSelectValues.length == options.length;

    return showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              contentPadding: const EdgeInsets.all(0),
              titlePadding: const EdgeInsets.only(top: 15, left: 15, bottom: 0),
              actionsPadding: const EdgeInsets.only(top: 0, left: 10, right: 10, bottom: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              title: title == '' ? null : Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              content: Container(
                width: 300,
                decoration: BoxDecoration(border: Border.all(color: Colors.blueGrey[100] ?? Colors.blueGrey)),
                margin: multiSelect ? const EdgeInsets.symmetric(vertical: 10) : const EdgeInsets.only(top: 10),
                constraints: constraints,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: options.length,
                  itemBuilder: (BuildContext context, int index) {
                    final String soption = '$prefixText ${options[index].toString()} $suffixText'.trim();
                    return ListTile(
                      tileColor: index % 2 == 0 ? null : primaryColor?.withValues(alpha: 0.05),
                      leading: () {
                        if (multiSelect) {
                          return Checkbox(
                            activeColor: primaryColor,
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
                        if (onSelection != null) {
                          onSelection(index, options[index]);
                        } else if (multiSelect) {
                          multiSelectValues[index] = !multiSelectValues[index];
                          setState(() {});
                        }
                      },
                    );
                  },
                ),
              ),
              actions: () {
                if (!multiSelect) return null;
                return [
                  ESButton('CANCEL', buttonColor: primaryColor, textColor: Colors.white, onPressed: Navigator.of(context).pop, width: 150),
                  ESButton(
                    okBtnText,
                    width: 150,
                    buttonColor: Colors.white,
                    textColor: primaryColor,
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
    final String? message,
    final Function(TextEditingController)? onSubmit,
    final String? defaultValue,
    final String? suffixText,
  }) {
    final TextEditingController controller = TextEditingController(text: defaultValue);

    ESMessage.customDialog(
      context: context,
      title: title,
      iconData: Icons.quiz_outlined,
      onSubmit: (context) {
        if (onSubmit != null) onSubmit(controller);
      },
      content: () {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (message != null) const SizedBox(height: 15),
            if (message != null) Text(message),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: TextField(
                decoration: InputDecoration(
                  isDense: true,
                  border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                  filled: false,
                  hintStyle: const TextStyle(color: Colors.grey),
                  hintText: hitText ?? '',
                  labelText: hitText ?? '',
                  suffixText: suffixText,
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
    final Function(BuildContext context)? onSubmit,
    final Function()? onCancel,
    final String okBtnText = 'SUBMIT',
    final IconData? iconData,
    final Color? iconColor,
    Color? primaryColor,
    final bool hideCancelButton = false,
  }) {
    primaryColor = primaryColor ?? Theme.of(context).primaryColor;

    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: Colors.white,
        iconPadding: iconData == null ? null : const EdgeInsets.only(top: 15),
        icon: iconData == null ? null : Icon(iconData, color: iconColor ?? primaryColor, size: 60),
        titlePadding: const EdgeInsets.only(top: 15, left: 15, bottom: 0),
        actionsPadding: const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        contentPadding: const EdgeInsets.all(6.0),
        title: Text(title ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
        content: content,
        actionsOverflowDirection: VerticalDirection.down,
        actions: [
          ESUtils.createControlsInRow([
            if (!hideCancelButton)
              ESButton(
                'CANCEL',
                width: double.infinity,
                textColor: Colors.white,
                buttonColor: primaryColor,
                onPressed: () {
                  Navigator.pop(context);
                  if (onCancel != null) onCancel();
                },
              ),
            ESButton(
              okBtnText,
              width: double.infinity,
              textColor: primaryColor,
              buttonColor: Colors.white,
              onPressed: () {
                if (autoPop) Navigator.of(context).pop();
                if (onSubmit != null) onSubmit(context);
              },
            ),
          ]),
        ],
      ),
    );
  }

  /// Shwos a dialog with single button. Default title will be 'Error'.
  static showWarningMessage(
    BuildContext context, {
    String title = 'Warning',
    String? message,
    bool barrierDismissible = true,
    Function()? onPressed,
  }) {
    return showConfirmDialog(
      context: context,
      title: title,
      message: message,
      primaryButton: 'OK',
      iconColor: Colors.amber,
      primaryButtonColor: Colors.amber,
      iconData: Icons.warning_amber,
      barrierDismissible: barrierDismissible,
      onPressed: (aBtnIndex) {
        if (onPressed != null) return onPressed();
      },
    );
  }

  /// Shwos a dialog with single button. Default title will be 'Error'.
  static showErrorMessage(
    BuildContext context, {
    String title = 'Error',
    String? message,
    bool barrierDismissible = true,
    Function()? onPressed,
  }) {
    return showConfirmDialog(
      context: context,
      title: title,
      message: message,
      primaryButton: 'OK',
      iconColor: Colors.red,
      primaryButtonColor: Colors.red,
      iconData: Icons.report_outlined,
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
    bool barrierDismissible = true,
    Function()? onPressed,
  }) {
    return showConfirmDialog(
      context: context,
      title: title,
      message: message,
      primaryButton: 'OK',
      iconData: Icons.info_outline,
      iconColor: Colors.green,
      primaryButtonColor: Colors.green,
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
    final Color primaryButtonColor = Colors.red,
    final Color secondaryButtonColor = Colors.green,
    final bool barrierDismissible = true,
  }) {
    return showConfirmDialog(
      context: context,
      primaryButton: 'No',
      secondaryButton: 'Yes',
      title: title,
      message: message,
      content: content,
      autoPop: autoPop,
      primaryButtonColor: primaryButtonColor,
      secondaryButtonColor: secondaryButtonColor,
      iconData: Icons.live_help_outlined,
      iconColor: primaryButtonColor,
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
  /// [primaryButton] this is the primary button. This cannot be null.
  /// If you have multiple buttons, then this will be displayed on left side
  ///
  /// [secondaryButton] an optional button to be displayed on right side
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
    Color? primaryColor,
    required final String primaryButton,
    final Color? primaryButtonColor,
    final String? secondaryButton,
    final Color? secondaryButtonColor,
    final bool autoPop = true,
    final IconData? iconData,
    final Color? iconColor,
    final Function(int)? onPressed,
    final bool barrierDismissible = true,
  }) {
    primaryColor = primaryColor ?? Theme.of(context).primaryColor;

    return showDialog(
      context: context,
      useRootNavigator: false,
      barrierDismissible: barrierDismissible,
      useSafeArea: true,
      barrierColor: ESTheme.barrierColor(context),
      builder: (BuildContext context) => KeyboardListener(
        autofocus: true,
        focusNode: FocusNode(),
        onKeyEvent: (event) {
          if (HardwareKeyboard.instance.isLogicalKeyPressed(LogicalKeyboardKey.enter) || HardwareKeyboard.instance.isLogicalKeyPressed(LogicalKeyboardKey.numpadEnter)) {
            if (autoPop) Navigator.pop(context);
            if (onPressed != null) onPressed(1);
          }
        },
        child: AlertDialog(
          backgroundColor: Colors.white,
          iconPadding: iconData == null ? null : const EdgeInsets.only(top: 15),
          icon: iconData == null ? null : Icon(iconData, color: iconColor ?? primaryColor, size: 60),
          titlePadding: const EdgeInsets.only(top: 15, left: 15, bottom: 0),
          actionsPadding: const EdgeInsets.only(top: 0, left: 10, right: 10, bottom: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          title: Column(
            children: <Widget>[
              Text(title ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
            ],
          ),
          content: content ?? Text(message ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
          actions: [
            ESUtils.createControlsInRow([
              Tooltip(
                message: '[Esc]',
                child: ESButton(
                  primaryButton,
                  width: double.infinity,
                  textColor: Colors.white,
                  buttonColor: primaryButtonColor ?? primaryColor,
                  onPressed: () {
                    if (autoPop) Navigator.pop(context);
                    if (onPressed != null) onPressed(0);
                  },
                ),
              ),
              if (secondaryButton != null)
                Tooltip(
                  message: '[Press Enter]',
                  child: ESButton(
                    secondaryButton,
                    width: double.infinity,
                    textColor: Colors.white,
                    buttonColor: secondaryButtonColor ?? primaryColor,
                    onPressed: () {
                      if (autoPop) Navigator.pop(context);
                      if (onPressed != null) onPressed(1);
                    },
                  ),
                ),
            ]),
          ],
        ),
      ),
    );
  }
}
