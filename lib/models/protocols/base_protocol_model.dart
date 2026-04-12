import 'package:apidash_core/apidash_core.dart';
import 'package:json_annotation/json_annotation.dart';
import 'websocket_model.dart';
import 'mqtt_model.dart';
import 'grpc_model.dart';


/// Abstract base class for all protocol-specific request models.
abstract class ProtocolModel {}

/// Polymorphic converter for [ProtocolModel] to handle JSON serialization.
class ProtocolModelConverter
    implements JsonConverter<ProtocolModel?, Map<String, dynamic>?> {
  const ProtocolModelConverter();

  @override
  ProtocolModel? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    final typeStr = json['type'] as String?;
    if (typeStr == APIType.websocket.name) {
      return WebSocketRequestModel.fromJson(json);
    } else if (typeStr == APIType.mqtt.name) {
      return MQTTRequestModel.fromJson(json);
    } else if (typeStr == APIType.grpc.name) {
      return GrpcRequestModel.fromJson(json);
    }

    return null;
  }

  @override
  Map<String, dynamic>? toJson(ProtocolModel? object) {
    if (object == null) return null;
    if (object is WebSocketRequestModel) {
      return object.toJson();
    } else if (object is MQTTRequestModel) {
      return object.toJson();
    } else if (object is GrpcRequestModel) {
      return object.toJson();
    }

    return null;
  }
}
