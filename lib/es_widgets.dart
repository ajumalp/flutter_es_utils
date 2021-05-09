/*
 * Developed by Ajmal Muhammad P
 * Contact me @ support@erratums.com
 * https://erratums.com
 * Date created: 09-May-2021
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ESButton extends StatelessWidget {
  final String caption;

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
  const ESButton(this.caption, {required this.onPressed, this.width = double.infinity});

  @override
  Widget build(BuildContext context) {
    final TargetPlatform varPlatform = Theme.of(context).platform;

    return SizedBox(
      width: width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(
            horizontal: 30,
            vertical: kIsWeb
                ? 20
                : varPlatform == TargetPlatform.android || varPlatform == TargetPlatform.iOS
                    ? 10
                    : 20,
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          primary: Colors.blue[400],
        ),
        child: Text(caption, style: const TextStyle(color: Colors.white, fontSize: 18)),
        onPressed: () => onPressed(),
      ),
    );
  }
}

class ESProgressIndicator extends AlertDialog {
  /// A CircularProgressIndicator can be used to display while processing in background
  ESProgressIndicator()
      : super(
          content: Row(
            children: <Widget>[
              const Text('Please wait ... !'),
              const Spacer(),
              const CircularProgressIndicator(),
            ],
          ),
        );
}
