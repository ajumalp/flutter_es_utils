/*
 * Developed by Ajmal Muhammad P
 * Contact me @ support@erratums.com
 * https://erratums.com
 * Date created: 23-July-2021
 */

extension ESDoubleEx on double {
  String toStringAsFixedNoZero(final int n) => double.parse(this.toStringAsFixed(n)).toString();
}
