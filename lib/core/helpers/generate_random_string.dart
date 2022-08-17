import 'dart:math';

String generateRandomString(int length) {
  var random = Random();
  var result = StringBuffer();
  for (var i = 0; i < length; i++) {
    result.writeCharCode(random.nextInt(26) + 65);
  }
  return result.toString();
}
