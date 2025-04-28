import 'package:lsp_server/lsp_server.dart';

class DaisyuiComponent {
  final String label;
  final String detail;
  final String documentation;
  final CompletionItemKind kind;
  const DaisyuiComponent({required this.label, required this.detail, required this.kind, required this.documentation});

  CompletionItem toCompletionItem() {
    return CompletionItem(
      label: label,
      kind: kind,
      detail: detail,
      insertText: label,
      insertTextFormat: InsertTextFormat.PlainText,
    );
  }
}
