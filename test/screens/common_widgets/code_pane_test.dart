import 'package:apidash/consts.dart';
import 'package:apidash/models/models.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/screens/common_widgets/code_pane.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final wsRequest = RequestModel(
    id: 'ws-1',
    apiType: APIType.websocket,
    wsRequestModel: const WebSocketRequestModel(url: 'wss://example.com/ws'),
  );

  testWidgets('WebSocket code pane offers DashBot codegen instead of Raise Issue', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          selectedRequestModelProvider.overrideWith((ref) => wsRequest),
        ],
        child: const MaterialApp(home: Scaffold(body: CodePane())),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(kMsgCodegenWebSocketViaDashbot), findsOneWidget);
    expect(find.text(kLabelGenerateCodeDashbot), findsOneWidget);
    expect(find.text('Raise Issue'), findsNothing);
  });
}
