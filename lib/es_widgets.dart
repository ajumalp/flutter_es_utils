/*
 * Developed by Ajmal Muhammad P
 * Contact me @ support@erratums.com
 * https://erratums.com
 * Date created: 09-May-2021
 */

import 'package:es_utils/es_three_arched_circle.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

abstract class ESPlatform {
  /// Get the platform type `TargetPlatform`
  /// ```dart
  /// return Theme.of(context).platform
  /// ```
  static TargetPlatform targetPlatform(BuildContext context) => Theme.of(context).platform;

  /// can be used to check platform is web or not using [kIsWeb] internally
  static bool get isWeb => kIsWeb;

  /// Will return true if platform is either Android or iOS
  static bool isMobile(BuildContext context) {
    final TargetPlatform varPlatform = targetPlatform(context);
    return varPlatform == TargetPlatform.android || varPlatform == TargetPlatform.iOS;
  }

  /// Will return true if platform is Android
  static bool isAndroid(BuildContext context) {
    if (isWeb) return false;
    final TargetPlatform varPlatform = targetPlatform(context);
    return varPlatform == TargetPlatform.android;
  }

  /// Will return true if platform is iOS
  static bool isiOS(BuildContext context) {
    if (isWeb) return false;
    final TargetPlatform varPlatform = targetPlatform(context);
    return varPlatform == TargetPlatform.iOS;
  }

  /// Will return true if platform is Windows
  static bool isWindows(BuildContext context) {
    if (isWeb) return false;
    final TargetPlatform varPlatform = targetPlatform(context);
    return varPlatform == TargetPlatform.windows;
  }

  /// Will return true if screen size is less than [size].
  /// [size] is default to 500
  static bool isSmallScreen(BuildContext context, {final double width = 500}) {
    return MediaQuery.of(context).size.width <= width;
  }
}

class ESButton extends StatelessWidget {
  final String caption;
  final Color? textColor;
  final Color? buttonColor;

  /// [onPressed] is the event triggerd when button is pressed/clicked
  final Function() onPressed;

  /// [width] to set width of the button. Default to full width of parent
  final double? width;

  /// An edge rounded button extended from [ElevatedButton]
  ///
  /// [caption] is the text displayed on button
  ///
  /// [onPressed] is the event triggerd when button is pressed/clicked
  ///
  /// [width] to set width of the button. Default to full width of parent
  const ESButton(
    this.caption, {
    Key? key,
    this.textColor,
    this.buttonColor,
    required this.onPressed,
    this.width = double.infinity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TargetPlatform varPlatform = Theme.of(context).platform;

    return SizedBox(
      width: width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 1,
          backgroundColor: buttonColor,
          padding: EdgeInsets.symmetric(
            horizontal: 30,
            vertical: (varPlatform == TargetPlatform.android || varPlatform == TargetPlatform.iOS) ? 8 : 15,
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        ),
        child: Text(caption, style: TextStyle(fontSize: 18, color: textColor)),
        onPressed: () => onPressed(),
      ),
    );
  }
}

class ESProgressIndicator extends AlertDialog {
  /// A CircularProgressIndicator can be used to display while processing in background

  ESProgressIndicator({
    Key? key,
    String? status,
  }) : super(
          elevation: status != null ? 2 : 0,
          backgroundColor: status == null ? Colors.transparent : null,
          key: key,
          content: Wrap(
            runSpacing: 20,
            alignment: WrapAlignment.center,
            children: [
              const ESThreeArchedCircle(size: 50),
              if (status != null) Text(status),
            ],
          ),
        );
}

/// A control to display linked text which is inherited from RichText
class ESLinkText extends RichText {
  /// [text] text to be displayed
  ///
  /// [prefixText] a non link text to be displayed before linked text
  ///
  /// [url] the url to redirect when clicked
  ///
  /// [onTap] the function to be triggered when tapped.
  /// Only work if URL is [url] is not null
  ESLinkText(
    String text, {
    Key? key,
    String prefixText = '',
    String? url,
    Function()? onTap,
    double fontSize = 16,
    Color textColor = Colors.lightBlue,
    Color prefixTextColor = Colors.white,
  }) : super(
          key: key,
          text: TextSpan(
            children: [
              if (prefixText != '') TextSpan(text: prefixText, style: TextStyle(color: prefixTextColor, fontSize: fontSize)),
              TextSpan(
                text: text,
                style: TextStyle(color: textColor, fontSize: fontSize, fontWeight: FontWeight.bold),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    if (url != null) {
                      launchUrlString(url);
                    } else if (onTap != null) {
                      onTap();
                    }
                  },
              ),
            ],
          ),
        );
}
