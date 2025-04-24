import 'dart:convert';
import 'dart:io';

void main() async {
  final file = File('lib/components.json');
  final jsonString = await file.readAsString();
  final List<dynamic> data = jsonDecode(jsonString) as List<dynamic>;
  final Map<String, String> classCategories = {
    '"component"': 'CompletionItemKind.Snippet',
    '"color"': 'CompletionItemKind.Color',
    '"style"': 'CompletionItemKind.Property',
    '"behavior"': 'CompletionItemKind.Value',
    '"size"': 'CompletionItemKind.Unit',
    '"modifier"': 'CompletionItemKind.Value',
    '"placement"': 'CompletionItemKind.Value',
    '"part"': 'CompletionItemKind.Field',
    '"direction"': 'CompletionItemKind.Value',
  };

  final buffer = StringBuffer();
  buffer.writeln('// GENERATED CODE — DO NOT EDIT');
  buffer.writeln("import 'package:lsp_server/lsp_server.dart';");
  buffer.writeln('import "models.dart";\n');
  buffer.writeln('const components = <DaisyuiComponent>[');

  for (final item in data) {
    final label = jsonEncode(item['label']);
    final detail = jsonEncode(item['detail']);
    final kind = jsonEncode(item['category']);
    buffer.writeln('DaisyuiComponent(label: $label, detail: $detail, kind: ${classCategories[kind]}),');
  }

  buffer.writeln('];');

  final outputFile = File('lib/baked_components.dart');
  await outputFile.writeAsString(buffer.toString());

  print('✅ baked_components.dart generated successfully.');
}
