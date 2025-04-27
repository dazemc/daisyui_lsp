import 'dart:io';
import 'package:daisyui_lsp/models.dart';

import 'baked_components.dart';

void main() async {
  final buffer = StringBuffer();
  buffer.writeln('// GENERATED CODE, DO NOT EDIT');
  buffer.writeln('import \'package:lsp_server/lsp_server.dart\';\n');
  buffer.writeln('final completionList = [');
  // final List<CompletionItem> completionList = <CompletionItem>[];
  for (DaisyuiComponent component in components.values) {
    final item = component.toCompletionItem();
    buffer.writeln('CompletionItem(');
    buffer.writeln('    label: "${_string(item.label)}",');
    buffer.writeln('    kind: const CompletionItemKind(${item.kind}),');
    buffer.writeln('    detail: "${_string(item.detail)}",');
    buffer.writeln('    insertText: "${_string(item.insertText)}",');
    buffer.writeln('    insertTextFormat: InsertTextFormat.PlainText,');
    buffer.writeln('),');
  }
  buffer.writeln('];');
  final outFile = File('baked_completion.dart');
  outFile.writeAsString(buffer.toString());
  print('✅ baked_completion.dart generated successfully.');
}

String _string(String? input) => input == null ? 'null' : input.replaceAll('\"', "'");
