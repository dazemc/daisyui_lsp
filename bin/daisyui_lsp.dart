import 'dart:io';
import 'package:daisyui_lsp/baked_completion.dart';
import 'package:logging/logging.dart';
import 'package:lsp_server/lsp_server.dart';

void main(List<String> arguments) async {
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
        // Add more capabilities as needed (e.g., completion, hover)
      ),
    );
  });

  // Handle textDocument/didOpen
  connection.onDidOpenTextDocument((params) async {
    try {
      log.info('Opened document: ${params.textDocument.uri}');
      // Example: Send empty diagnostics (modify as needed)
      connection.sendDiagnostics(PublishDiagnosticsParams(diagnostics: [], uri: params.textDocument.uri));
    } catch (e, stackTrace) {
      log.severe('Error in onDidOpenTextDocument for ${params.textDocument.uri}: $e', e, stackTrace);
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

  // Start listening for LSP messages
  log.info('LSP server listening...');
  await connection.listen();
}
