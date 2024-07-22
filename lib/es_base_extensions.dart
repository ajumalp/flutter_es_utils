/*
 * Developed by Ajmal Muhammad P
 * Contact me @ support@erratums.com
 * https://erratums.com
 * Date created: 23-July-2021
 */

extension ESStringExtn on String {
  String get capitalizeFirstChar {
    switch (length) {
      case 0:
        return '';

      case 1:
        return this[0].toUpperCase();

      default:
        return this[0].toUpperCase() + substring(1);
    }
  }

  String get capitalizeFirstCharOfWords {
    if (length < 1) return '';

    String result = '';
    split(' ').forEach((word) => result += '${word.capitalizeFirstChar} ');

    return result.trim();
  }

  /// To be used with Phone Number
  /// This will split string by "-" and return country code
  /// 91-9876543210 => 91
  String? get countryCode {
    final phoneDetails = split('-');
    if (phoneDetails.length < 2) {
      return null;
    } else {
      return phoneDetails.first;
    }
  }

  /// To be used with Phone Number
  /// This will split string by "-" and return phone number
  /// 91-9876543210 => 9876543210
  String? get phoneNumber {
    final phoneDetails = split('-');
    if (phoneDetails.isEmpty) {
      return null;
    } else {
      return phoneDetails.last;
    }
  }
}

extension ESDoubleEx on double {
  String toStringAsFixedNoZero(final int n) => double.parse(toStringAsFixed(n)).toString();
}
