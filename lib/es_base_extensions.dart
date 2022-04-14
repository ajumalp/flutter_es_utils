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
    split(' ').forEach((word) => result += word.capitalizeFirstChar);
    return result;
  }
}

extension ESDoubleEx on double {
  String toStringAsFixedNoZero(final int n) => double.parse(toStringAsFixed(n)).toString();
}
