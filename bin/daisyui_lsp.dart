import 'dart:io';
import 'package:daisyui_lsp/baked_completion.dart';
import 'package:daisyui_lsp/baked_components.dart';
import 'package:logging/logging.dart';
import 'package:lsp_server/lsp_server.dart';

void main(List<String> arguments) async {
  final Map<Uri, String> openDocuments = {};

  final logFile = File('/home/daze/daisyui_lsp.log');
  // Set up logging
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    final String log = '${record.level.name}: ${record.time}: ${record.loggerName}: ${record.message}';
    // stderr.writeln(log);
    logFile.writeAsStringSync('$log\n', mode: FileMode.append);
  });
  final log = Logger('DaisyUILspServer');
  log.info('Initializing DaisyUI LSP server...');
  // Create LSP connection
  final connection = Connection(stdin, stdout);
  final List<String> triggers = ['"', "'", ' '];

  // Handle LSP initialize request
  connection.onInitialize((params) async {
    // log.info('Responding to nvim request: $params');
    log.info('Declaring completion capabilities with trigger $triggers');
    final completionOptions = CompletionOptions(resolveProvider: false, triggerCharacters: triggers);
    return InitializeResult(
      capabilities: ServerCapabilities(
        textDocumentSync: const Either2.t1(TextDocumentSyncKind.Full),
        completionProvider: completionOptions,
        hoverProvider: const Either2.t1(true),
        // Add more capabilities as needed (e.g., completion, hover)
      ),
    );
  });

  // Handle textDocument/didOpen
  connection.onDidOpenTextDocument((params) async {
    try {
      final text = params.textDocument.text.toString();
      openDocuments[params.textDocument.uri] = text;
      log.info('Opened document: ${params.textDocument.uri}');
      log.info(text);
      // Example: Send empty diagnostics (modify as needed)
      connection.sendDiagnostics(PublishDiagnosticsParams(diagnostics: [], uri: params.textDocument.uri));
    } catch (e, stackTrace) {
      log.severe('Error in onDidOpenTextDocument for ${params.textDocument.uri}: $e', e, stackTrace);
    }
  });

  connection.onDidChangeTextDocument((params) async {
    try {
      final Uri uri = params.textDocument.uri;
      log.info('Document at $uri changed: ${params.contentChanges}');
      final Map<String, dynamic> firstChangeMap =
          params.contentChanges.isNotEmpty
              ? params.contentChanges.first.toJson() as Map<String, dynamic>
              : {'text': ''};
      final String firstChange = firstChangeMap['text'].toString();
      openDocuments[uri] = firstChange;
    } catch (e, stackTrace) {
      log.severe('Error in onDidChangeTextDocument for ${params.textDocument.uri}: $e', e, stackTrace);
    }
  });

  connection.onCompletion((params) async {
    // final List<CompletionItem> completionItems = <CompletionItem>[
    //   CompletionItem(
    //     label: 'btn',
    //     kind: CompletionItemKind.Text,
    //     detail: 'DaisyUI button class',
    //     insertText: 'btn',
    //     insertTextFormat: InsertTextFormat.PlainText,
    //   ),
    // ];

    final completions = CompletionList(isIncomplete: false, items: completionList);
    return completions;
  });

  connection.onHover((params) async {
    final Uri uri = params.textDocument.uri;
    final Position pos = params.position;
    final String? textRaw = openDocuments[uri];
    final String? text = textRaw?.trim() ?? '';
    if (text != null) {
      final String documentation = components[text]?.documentation ?? 'Documentation for $text not found';
      final Hover hover = Hover(contents: Either2.t1(MarkupContent(kind: MarkupKind.Markdown, value: documentation)));
      return hover;
    } else {
      return Hover(contents: Either2.t1(MarkupContent(kind: MarkupKind.PlainText, value: '')));
    }
  });

  // Start listening for LSP messages
  log.info('LSP server listening...');
  await connection.listen();
}
