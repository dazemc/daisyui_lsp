import 'package:lsp_server/lsp_server.dart';

class DaisyuiComponent {
  final String label;
  final String detail;
  const DaisyuiComponent({required this.label, required this.detail});

  CompletionItem toCompletionItem(DaisyuiComponent component) {
    return CompletionItem(
      label: component.label,
      kind: CompletionItemKind.Text,
      detail: component.detail,
      insertText: component.label,
      insertTextFormat: InsertTextFormat.PlainText,
    );
  }
}
