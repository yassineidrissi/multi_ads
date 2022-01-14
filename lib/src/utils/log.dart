import 'package:flutter/foundation.dart';

class Log {
  static void log(Object obj) {
    if (kDebugMode) {
      print('Log: $obj');
    }
  }
}
