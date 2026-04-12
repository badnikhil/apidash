import 'dart:io';
import 'dart:convert';
import 'package:apidash/models/protocols/grpc_model.dart';

class GrpcUtils {
  static Future<Map<String, dynamic>> parseProtoFile(String path) async {
    try {
      final file = File(path);
      if (!await file.exists()) return {};

      final content = await file.readAsString();
      final services = <String>[];
      final methods = <String, List<String>>{};
      final messageFields = <String, List<GrpcParameterModel>>{};

      // Basic regex for services
      final serviceRegex = RegExp(r'service\s+(\w+)\s*\{');
      final matches = serviceRegex.allMatches(content);

      for (final match in matches) {
        final serviceName = match.group(1)!;
        services.add(serviceName);
        
        // Find methods for this service
        // This is a simplified search and won't handle complex nesting well
        final serviceBlockRegex = RegExp('service\\s+$serviceName\\s*\\{([^\\}]*)\\}');
        final serviceBlock = serviceBlockRegex.firstMatch(content)?.group(1) ?? "";
        
        final methodRegex = RegExp(r'rpc\s+(\w+)\s*\(([^)]*)\)\s+returns\s*\(([^)]*)\)');
        final methodMatches = methodRegex.allMatches(serviceBlock);
        
        final serviceMethods = <String>[];
        for (final mMatch in methodMatches) {
          final methodName = mMatch.group(1)!;
          final requestType = mMatch.group(2)!.trim();
          serviceMethods.add(methodName);
          
          // Store request type to map to fields later
          methods["$serviceName/$methodName"] = [requestType];
        }
        methods[serviceName] = serviceMethods;
      }

      // Basic regex for messages (to populate form fields)
      final messageRegex = RegExp(r'message\s+(\w+)\s*\{([^\}]*)\}');
      final msgMatches = messageRegex.allMatches(content);
      
      for (final match in msgMatches) {
        final msgName = match.group(1)!;
        final msgBody = match.group(2)!;
        
        final fields = <GrpcParameterModel>[];
        final fieldLineRegex = RegExp(r'(\w+)\s+(\w+)\s*=\s*(\d+);');
        final fieldLines = fieldLineRegex.allMatches(msgBody);
        
        for (final fMatch in fieldLines) {
          final type = fMatch.group(1)!;
          final name = fMatch.group(2)!;
          
          fields.add(GrpcParameterModel(
            name: name,
            type: type,
            enabled: true,
            value: "",
          ));
        }
        messageFields[msgName] = fields;
      }

      return {
        'services': services,
        'methods': methods,
        'messageFields': messageFields,
      };
    } catch (e) {
      print("Error parsing proto: $e");
      return {};
    }
  }

  static String decodeBinaryResponse(List<int> data) {
    try {
      if (data.isEmpty) return "";
      
      // Try to parse as Protobuf wire format
      final Map<int, dynamic> decoded = _decodeProtobuf(data);
      if (decoded.isEmpty) {
        // Fallback to UTF-8 if it's just a string
        try {
          return utf8.decode(data);
        } catch (_) {
          return data.toString();
        }
      }
      
      return _prettyJson(decoded);
    } catch (e) {
      return data.toString();
    }
  }

  static Map<int, dynamic> _decodeProtobuf(List<int> data) {
    final result = <int, dynamic>{};
    int offset = 0;

    while (offset < data.length) {
      final key = _readVarint(data, offset);
      if (key == null) break;
      offset = key.nextOffset;

      final tag = key.value >> 3;
      final wireType = key.value & 0x07;

      switch (wireType) {
        case 0: // Varint
          final val = _readVarint(data, offset);
          if (val == null) return result;
          result[tag] = val.value;
          offset = val.nextOffset;
          break;
        case 2: // Length-delimited (String, Bytes, Embedded Message)
          final len = _readVarint(data, offset);
          if (len == null) return result;
          offset = len.nextOffset;
          final bytes = data.sublist(offset, offset + len.value);
          offset += len.value;

          // Try to decode as nested message or string
          try {
            final nested = _decodeProtobuf(bytes);
            if (nested.isNotEmpty && _isLikelyProtobuf(bytes)) {
              result[tag] = nested;
            } else {
              result[tag] = utf8.decode(bytes);
            }
          } catch (_) {
            result[tag] = bytes.toString();
          }
          break;
        case 1: // 64-bit
          offset += 8;
          break;
        case 5: // 32-bit
          offset += 4;
          break;
        default:
          return result;
      }
    }
    return result;
  }

  static bool _isLikelyProtobuf(List<int> data) {
      if (data.isEmpty) return false;
      final firstByte = data[0];
      final wireType = firstByte & 0x07;
      return wireType <= 5;
  }

  static _VarintResult? _readVarint(List<int> data, int offset) {
    int value = 0;
    int shift = 0;
    int index = offset;

    while (index < data.length) {
      final b = data[index++];
      value |= (b & 0x7F) << shift;
      if (b < 0x80) return _VarintResult(value, index);
      shift += 7;
      if (shift >= 64) break;
    }
    return null;
  }

  static String _prettyJson(dynamic obj) {
      const encoder = JsonEncoder.withIndent('  ');
      return encoder.convert(obj);
  }
}

class _VarintResult {
  final int value;
  final int nextOffset;
  _VarintResult(this.value, this.nextOffset);
}
