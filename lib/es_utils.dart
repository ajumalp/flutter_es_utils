/*
 * Developed by Ajmal Muhammad P
 * Contact me @ support@erratums.com
 * https://erratums.com
 * Date created: 09-May-2021
 * test
 */

library es_utils;

import 'dart:math';

export 'es_messages.dart';
export 'es_widgets.dart';
export 'es_wrapper.dart';
export 'es_base_extensions.dart';

class ESUtils {
  static String getRandomString(final int length) {
    const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    final Random _rnd = Random.secure();
    return String.fromCharCodes(
      Iterable.generate(length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))),
    );
  }
}
