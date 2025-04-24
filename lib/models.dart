import 'package:lsp_server/lsp_server.dart';

class DaisyuiComponents {
  final String label;
  final String detail;
  DaisyuiComponents({required this.label, required this.detail});
}

CompletionItem toCompletionItem(DaisyuiComponents component) {
  return CompletionItem(
    label: component.label,
    kind: CompletionItemKind.Text,
    detail: component.detail,
    insertText: component.label,
    insertTextFormat: InsertTextFormat.PlainText,
  );
}
