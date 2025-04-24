import 'dart:convert';
import 'dart:io';

void main() async {
  final file = File('lib/components.json');
  final jsonString = await file.readAsString();
  final List<dynamic> data = jsonDecode(jsonString) as List<dynamic>;

  final buffer = StringBuffer();
  buffer.writeln('// GENERATED CODE — DO NOT EDIT');
  buffer.writeln('import "models.dart";\n');
  buffer.writeln('const components = <DaisyuiComponent>[');

  for (final item in data) {
    final label = jsonEncode(item['label']);
    final detail = jsonEncode(item['detail']);
    buffer.writeln('DaisyuiComponent(label: $label, detail: $detail),');
  }

  buffer.writeln('];');

  final outputFile = File('lib/baked_components.dart');
  await outputFile.writeAsString(buffer.toString());

  print('✅ baked_components.dart generated successfully.');
}
