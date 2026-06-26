import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

void main() async {
  // Read some data.
  final jsonData = await Isolate.run(_readAndParseJson);

  // Use that data.
  print('Number of JSON keys: ${jsonData.length}');
}

const String filename = 'with_keys.json';

Future<Map<String, dynamic>> _readAndParseJson() async {
  final fileData = await File(filename).readAsString();
  final jsonData = jsonDecode(fileData) as Map<String, dynamic>;
  return jsonData;
}

Future<Map<String, dynamic>> _readAndParseJson1() async {
  final fileData = await File(filename).readAsString();
  final jsonData = jsonDecode(fileData) as Map<String, dynamic>;
  return jsonData;
}

class console {
  static void log(Object tag, Object value) {
    print('$tag $value');
  }
}

extension on String {
  bool isBlank() => trim().isEmpty;
}
