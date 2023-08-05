/*
 * Developed by Ajmal Muhammad P
 * Contact me @ support@erratums.com
 * https://erratums.com
 * Date created: 09-May-2021
 */

library es_utils;

import 'package:intl/intl.dart';

abstract class ESDateTimeUtils {
  static final cY19H = DateTime(1900);
  static final cY3K = DateTime(3000);

  static const String cDateFormat = 'dd-MMM-yyyy';
  static const String cTimeFormat = 'hh:mm a';
  static const String cDBDateFormat = 'yyyy-MM-dd';
  static const String cDBTimeFormat = 'HH:mm:ss';
  static const String cDateRangeSeperator = ' | ';
  static const String cDBDateTimeFormat = '$cDBDateFormat $cDBTimeFormat';

  static String format(final DateTime value, format) => DateFormat(format).format(value);

  /// return format will be like `21-Jan-2021`
  static String formatDate(final DateTime value) => ESDateTimeUtils.format(value, ESDateTimeUtils.cDateFormat);
  static String formatTime(final DateTime value) => ESDateTimeUtils.format(value, ESDateTimeUtils.cTimeFormat);

  /// return format will be like `2021-01-21`
  static String formatDBDate(final DateTime value) => ESDateTimeUtils.format(value, ESDateTimeUtils.cDBDateFormat);

  static DateTime parse(final String value, format) => DateFormat(format).parse(value);
  static DateTime parseDate(final String value) => ESDateTimeUtils.parse(value, ESDateTimeUtils.cDateFormat);
  static DateTime parseTime(final String value) => ESDateTimeUtils.parse(value, ESDateTimeUtils.cTimeFormat);
  static DateTime parseDBDate(final String value) => ESDateTimeUtils.parse(value, ESDateTimeUtils.cDBDateFormat);
  static DateTime parseDBTime(final String value) => ESDateTimeUtils.parse(value, ESDateTimeUtils.cDBTimeFormat);
  static DateTime parseDBDateTime(final String value) => ESDateTimeUtils.parse(value, ESDateTimeUtils.cDBDateTimeFormat);

  /// Convert **from database** format **to ESDateController** format
  ///
  /// eg:- from format `2021-01-21` to format `21-Jan-2021`
  static String convertFromDBDate(final String value) => ESDateTimeUtils.formatDate(ESDateTimeUtils.parseDBDate(value));
  static String convertFromDBDateRange(final String value) {
    final List<String> varDates = value.split(ESDateTimeUtils.cDateRangeSeperator);
    return convertFromDBDate(varDates[0]) + cDateRangeSeperator + convertFromDBDate(varDates[1]);
  }

  /// Convert **from ESDateController** format **to database** format
  ///
  /// eg:- from format `21-Jan-2021` to format `2021-01-21`
  static String convertToDBDate(final String value) => ESDateTimeUtils.formatDBDate(ESDateTimeUtils.parseDate(value));
  static String convertToDBDateRange(final String value) {
    final List<String> varDates = value.split(ESDateTimeUtils.cDateRangeSeperator);
    return convertToDBDate(varDates[0]) + cDateRangeSeperator + convertToDBDate(varDates[1]);
  }
}
