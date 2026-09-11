import 'package:apidash/models/request_model.dart';
import 'package:apidash/models/ws_request_model.dart';
import 'package:apidash/providers/collection_providers.dart';
import 'package:apidash/screens/home_page/editor_pane/details_card/request_pane/ws/ws_recently_sent.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Recently Sent dedupes repeated payloads, most recent first',
      (tester) async {
    const sent = WebSocketMessageType.sent;
    final requestModel = RequestModel(
      id: 'ws-1',
      apiType: APIType.websocket,
      wsRequestModel: const WebSocketRequestModel(
        messageHistory: [
          WebSocketMessage(payload: 'hi', messageType: sent),
          WebSocketMessage(payload: 'hello', messageType: sent),
          WebSocketMessage(payload: 'hi', messageType: sent),
          WebSocketMessage(payload: 'hi', messageType: sent),
        ],
      ),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          selectedRequestModelProvider.overrideWith((ref) => requestModel),
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
    await tester.pumpAndSettle();

    expect(find.text('hi'), findsOneWidget);
    expect(find.text('hello'), findsOneWidget);
    // Send count shown only on the repeated card.
    expect(find.text('\u00d73'), findsOneWidget);
    expect(find.textContaining('\u00d7'), findsOneWidget);
    expect(find.byType(Scrollbar), findsOneWidget);
    // Most recent send comes first.
    expect(
      tester.getTopLeft(find.text('hi')).dx,
      lessThan(tester.getTopLeft(find.text('hello')).dx),
    );
  });
}
