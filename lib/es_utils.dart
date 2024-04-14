/*
 * Developed by Ajmal Muhammad P
 * Contact me @ support@erratums.com
 * https://erratums.com
 * Date created: 09-May-2021
 */

library es_utils;

import 'dart:math';
import 'package:es_utils/es_utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as httpClient;

export 'es_base_extensions.dart';
export 'es_messages.dart';
export 'es_widgets.dart';
export 'es_wrapper.dart';
export 'es_date_utils.dart';
export 'es_advanced_text_field.dart';

class ESUtils {
  static String getRandomString(final int length) {
    const chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    final Random rnd = Random.secure();
    return String.fromCharCodes(
      Iterable.generate(length, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))),
    );
  }

  static Future<String> readFile(final String url) => httpClient.read(Uri.parse(url));

  static Future pushScreen({
    required BuildContext context,
    required Widget newScreen,
    bool popRequired = true,
    bool showMiniWindow = false,
    BoxConstraints? constraints,
    bool barrierDismissible = true,
  }) {
    if (popRequired) Navigator.of(context).pop();
    if (showMiniWindow) {
      return ESMessage.showModalDialog(
        context,
        barrierDismissible: barrierDismissible,
        content: ClipRRect(
          borderRadius: ESPlatform.isSmallScreen(context) ? BorderRadius.zero : BorderRadius.circular(10),
          clipBehavior: Clip.antiAlias,
          child: newScreen,
        ),
        constraints: constraints,
      );
    } else {
      return Navigator.of(context).push(MaterialPageRoute(builder: (_) => newScreen));
    }
  }

  static Scaffold scaffold(
    BuildContext context, {
    Widget? body,
    String? subTitle,
    Widget? leading,
    IconData? iconData,
    required String title,
    List<Widget>? footerButtons,
    final bool hideCloseButton = false,
    List<Widget>? actions,
    final Color? backgroundColor,
    final Color? appBarColor,
    final Color? titleColor,
    final double toolbarHeight = kToolbarHeight,
  }) {
    final bool isSmallScreen = ESPlatform.isSmallScreen(context);

    if (!hideCloseButton && !isSmallScreen) {
      (actions ??= []).add(FocusScope(
        canRequestFocus: false,
        child: IconButton(
          tooltip: 'Close [Esc]',
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ));
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        titleSpacing: 0,
        actions: actions,
        toolbarHeight: toolbarHeight,
        backgroundColor: appBarColor,
        automaticallyImplyLeading: isSmallScreen || iconData == null,
        leading: isSmallScreen || iconData == null ? IconButton(icon: const Icon(Icons.arrow_back_ios_new), onPressed: () => Navigator.pop(context)) : Icon(iconData),
        title: () {
          if (subTitle == null && leading == null) return Text(title);
          return ListTile(
            title: Text(title),
            leading: leading,
            textColor: titleColor,
            subtitle: subTitle == null ? null : Text(subTitle),
          );
        }(),
      ),
      body: body,
      persistentFooterButtons: footerButtons,
    );
  }

  static Card insertInCard(
    Widget widget, {
    final EdgeInsetsGeometry childPadding = EdgeInsets.zero,
    final bool includeBorderSide = true,
    final Color useDarkTheme = Colors.white,
  }) {
    return Card(
      color: useDarkTheme,
      shadowColor: Colors.blueGrey,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      margin: childPadding,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: includeBorderSide ? const BorderSide(color: Colors.blueGrey, width: 1.5) : BorderSide.none,
      ),
      child: widget,
    );
  }

  static Widget createControlsInRow(List<Widget> aControls, {bool addBottomSpace = true, bool addSpaceAround = true}) {
    final List<Widget> varResult = [];
    for (var control in aControls) {
      if (addSpaceAround && varResult.isNotEmpty) varResult.add(const SizedBox(width: 10));
      varResult.add(Flexible(child: control));
    }
    if (addBottomSpace) varResult.add(const SizedBox(height: 10));
    return Align(
      alignment: Alignment.topLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: varResult,
      ),
    );
  }
}
