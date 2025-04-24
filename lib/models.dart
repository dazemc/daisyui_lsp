import 'package:lsp_server/lsp_server.dart';

class DaisyuiComponent {
  final String label;
  final String detail;
  const DaisyuiComponent({required this.label, required this.detail});

  CompletionItem toCompletionItem() {
    return CompletionItem(
      label: label,
      kind: CompletionItemKind.Text,
      detail: detail,
      insertText: label,
      insertTextFormat: InsertTextFormat.PlainText,
    );
  }
}
