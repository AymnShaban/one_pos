import 'dart:convert';

/// Prints any given data in a readable structured way.
void printData(dynamic data, {String title = "Data"}) {
  print("==== $title ====");

  if (data == null) {
    print("null");
    return;
  }

  try {
    // Try pretty-printing JSON if possible
    final pretty = const JsonEncoder.withIndent('  ').convert(data);
    print(pretty);
  } catch (e) {
    // If not JSON encodable, fallback to string-based inspection
    if (data is Iterable) {
      for (var i = 0; i < data.length; i++) {
        print("[$i]: ${data.elementAt(i)}");
      }
    } else if (data is Map) {
      data.forEach((key, value) {
        print("$key: $value");
      });
    } else {
      // Fallback: print as string
      print(data.toString());
    }
  }

  print("=====================");
}
