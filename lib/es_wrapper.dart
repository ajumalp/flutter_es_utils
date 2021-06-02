/*
 * Developed by Ajmal Muhammad P
 * Contact me @ support@erratums.com
 * https://erratums.com
 * Date created: 02-June-2021
 */

class ESGenericWrapper<T> {
  late T value;
  ESGenericWrapper(this.value);
}

class ESStringWrapper extends ESGenericWrapper<String> {
  ESStringWrapper(String value) : super(value);

  bool get isNotEmpty => value.isNotEmpty;
  bool get isEmpty => value.isEmpty;
  clear() => value = '';
}

class ESIntegerWrapper extends ESGenericWrapper<int> {
  ESIntegerWrapper(int value) : super(value);
}
