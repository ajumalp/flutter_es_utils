/*
 * Developed by Ajmal Muhammad P
 * Contact me @ support@erratums.com
 * https://erratums.com
 * Date created: 14-June-2021
 */

import 'package:flutter/material.dart';

class ESTheme {
  static Color textColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black;
  }

  static Color barrierColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? Colors.white54 : Colors.black54;
  }
}
