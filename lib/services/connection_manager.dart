// lib/services/connection_manager.dart

import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';

import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'dart:async';
import 'dart:math';

/// TODO: it should also be usable for other Protocols
/// A singleton service that holds active WebSocket connections.
///
/// Each connection is keyed by the request-tab ID so that the UI and provider
/// layer can retrieve an existing channel or tear it down when the tab is
/// closed / the user disconnects.
///
class ConnectionManager {
  ConnectionManager._();
  static final ConnectionManager instance = ConnectionManager._();

  /// Maps request ID → active WebSocket channel.
  final Map<String, WebSocketChannel> _channels = {};
  
  /// Maps request ID → active MQTT client.
  final Map<String, MqttServerClient> _mqttClients = {};

  /// Whether there is an active connection for [requestId].
  bool hasConnection(String requestId) => _channels.containsKey(requestId) || _mqttClients.containsKey(requestId);

  /// Returns the active channel for [requestId], or `null` if none exists.
  WebSocketChannel? getChannel(String requestId) => _channels[requestId];

  /// Opens a new WebSocket connection to [url] with optional [headers].
  ///
  /// The channel is stored under [requestId] so it can be reused for
  /// subsequent sends or torn down later.
  Future<WebSocketChannel> connect(
    String requestId,
    String url, {
    Map<String, String>? headers,
    Duration? pingInterval,
  }) async {
    // Tear down any pre-existing connection for the same tab.
    disconnect(requestId);

    final uri = Uri.parse(url);
    debugPrint('WS: connecting to $uri');
    final channel = IOWebSocketChannel.connect(
      uri,
      headers: headers,
      pingInterval: pingInterval,
    );
    _channels[requestId] = channel;
    return channel;
  }

  /// Sends a text [message] through the channel identified by [requestId].
  void send(String requestId, String message) {
    final channel = _channels[requestId];
    if (channel == null) {
      debugPrint('WS: no active channel for $requestId');
      return;
    }
    channel.sink.add(message);
  }

  /// Closes the WebSocket connection for [requestId].
  void disconnect(String requestId) {
    final channel = _channels.remove(requestId);
    if (channel != null) {
      debugPrint('WS: disconnecting $requestId');
      channel.sink.close();
    }
  }

  // --- MQTT LOGIC ---
  
  Future<MqttServerClient> connectMqtt(
    String requestId,
    String brokerUrl,
    int port, {
    String? clientId,
    String? username,
    String? password,
    bool useTLS = false,
    void Function(String topic)? onSubscribed,
    void Function(String topic, String payload)? onMessage,
    void Function()? onDisconnected,
  }) async {
    disconnectMqtt(requestId);

    String host = brokerUrl;
    if (host.contains("://")) {
      try {
        final uri = Uri.parse(host);
        host = uri.host.isNotEmpty ? uri.host : host;
      } catch (e) {
        debugPrint("Error parsing MQTT URL: $e");
      }
    }
    
    final finalClientId = clientId?.isNotEmpty == true 
        ? clientId! 
        : 'apidash_${DateTime.now().millisecondsSinceEpoch}';
        
    final client = MqttServerClient.withPort(host, finalClientId, port);
    client.logging(on: false);
    client.keepAlivePeriod = 60;
    client.secure = useTLS;
    
    client.onDisconnected = () {
      debugPrint('MQTT: disconnected $requestId');
      _mqttClients.remove(requestId);
      onDisconnected?.call();
    };
    
    client.onSubscribed = (String topic) {
      onSubscribed?.call(topic);
    };

    try {
      if (username?.isNotEmpty == true && password?.isNotEmpty == true) {
        await client.connect(username, password);
      } else {
        await client.connect();
      }
    } catch (e) {
      debugPrint('MQTT: exception $e');
      client.disconnect();
      _mqttClients.remove(requestId);
      rethrow;
    }

    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      debugPrint('MQTT: connected to $brokerUrl');
      _mqttClients[requestId] = client;
      
      client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
        final recMess = c![0].payload as MqttPublishMessage;
        final payload = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
        final topic = c[0].topic;
        onMessage?.call(topic, payload);
      });
      
    } else {
      client.disconnect();
      _mqttClients.remove(requestId);
      throw Exception('MQTT Connection failed: ${client.connectionStatus!.state}');
    }

    return client;
  }
  
  void subscribeMqtt(String requestId, String topic, int qos) {
    final client = _mqttClients[requestId];
    if (client == null) return;
    
    final mqttQos = MqttQos.values.firstWhere(
      (q) => q.index == qos,
      orElse: () => MqttQos.atMostOnce,
    );
    client.subscribe(topic, mqttQos);
  }
  
  void unsubscribeMqtt(String requestId, String topic) {
    final client = _mqttClients[requestId];
    if (client == null) return;
    client.unsubscribe(topic);
  }

  void sendMqtt(String requestId, String topic, String message, {bool retain = false, int qos = 0}) {
    final client = _mqttClients[requestId];
    if (client == null) {
      debugPrint('MQTT: no active client for $requestId');
      return;
    }
    
    final builder = MqttClientPayloadBuilder();
    builder.addString(message);
    
    final mqttQos = MqttQos.values.firstWhere(
      (q) => q.index == qos,
      orElse: () => MqttQos.atMostOnce,
    );
    
    client.publishMessage(topic, mqttQos, builder.payload!, retain: retain);
  }

  void disconnectMqtt(String requestId) {
    final client = _mqttClients.remove(requestId);
    if (client != null) {
      debugPrint('MQTT: manually disconnecting $requestId');
      client.disconnect();
    }
  }

  /// Tears down every active connection (used on app shutdown / data clear).
  void disconnectAll() {
    for (final entry in _channels.entries) {
      entry.value.sink.close();
    }
    _channels.clear();
    
    for (final entry in _mqttClients.entries) {
      entry.value.disconnect();
    }
    _mqttClients.clear();
  }
}
