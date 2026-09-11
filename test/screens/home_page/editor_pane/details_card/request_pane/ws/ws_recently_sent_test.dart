import 'package:apidash/models/models.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/screens/home_page/editor_pane/details_card/request_pane/ws/ws_recently_sent.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
      'Recently Sent hides automatic (heartbeat) messages with any payload',
      (tester) async {
    const keepalive = '{"type":"keepalive"}';
    final history = [
      WebSocketMessage(
        payload: 'hi',
        timestamp: DateTime(2026, 1, 1),
        messageType: WebSocketMessageType.sent,
      ),
      WebSocketMessage(
        payload: keepalive,
        timestamp: DateTime(2026, 1, 1, 0, 0, 2),
        isAutomatic: true,
        messageType: WebSocketMessageType.sent,
      ),
    ];

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          selectedRequestModelProvider.overrideWith(
            (ref) => RequestModel(
              id: 'ws',
              apiType: APIType.websocket,
              wsRequestModel: WebSocketRequestModel(
                enableMessageHeartbeat: true,
                messageHeartbeatPayload: keepalive,
                messageHistory: history,
              ),
            ),
          ),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: WsRecentlySent(
              templates: const [],
              onReuse: (_) {},
              onSaveTemplate: (_, __) {},
            ),
          ),
        ),
      ),
    );

    expect(find.text('hi'), findsOneWidget);
    expect(find.text(keepalive), findsNothing);
  });
}
