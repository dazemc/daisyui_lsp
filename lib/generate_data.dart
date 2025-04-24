import 'dart:convert';
import 'dart:io';

void main() async {
  final jsonStr = await File('lib/components.json').readAsString();
  final jsonData = jsonDecode(jsonStr) as List<dynamic>;

  final buffer = StringBuffer();
  buffer.writeln('// GENERATED FILE, DO NOT EDIT');
  buffer.writeln('const bakedComponents = [');

  for (final item in jsonData) {
    final label = jsonEncode(item['label']);
    final detail = jsonEncode(item['detail']);
    buffer.writeln(" { 'label': $label, 'detail': $detail},");
  }
  buffer.writeln('];');
  await File('lib/baked_components.dart').writeAsString(buffer.toString());
}
