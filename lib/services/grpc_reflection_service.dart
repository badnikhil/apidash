import 'package:protobuf/protobuf.dart';
import 'package:apidash/models/protocols/grpc_model.dart';
import 'package:apidash/services/connection_manager.dart';

// Minimal Descriptor definitions to extract method names
class FileDescriptorProto extends GeneratedMessage {
  static final BuilderInfo _i = BuilderInfo('FileDescriptorProto', package: const PackageName('google.protobuf'))
    ..aOS(1, 'name')
    ..aOS(2, 'package')
    ..pc<ServiceDescriptorProto>(6, 'service', PbFieldType.PM, subBuilder: ServiceDescriptorProto.create)
    ..hasRequiredFields = false;

  FileDescriptorProto() : super();
  factory FileDescriptorProto.fromBuffer(List<int> i,
          [ExtensionRegistry r = ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  static FileDescriptorProto create() => FileDescriptorProto._();
  FileDescriptorProto._() : super();
  @override
  BuilderInfo get info_ => _i;
  @override
  FileDescriptorProto clone() => FileDescriptorProto()..mergeFromMessage(this);
  @override
  FileDescriptorProto createEmptyInstance() => create();
  
  String get package => $_getS(1, '');
  List<ServiceDescriptorProto> get service => $_getList(2);
}

class ServiceDescriptorProto extends GeneratedMessage {
  static final BuilderInfo _i = BuilderInfo('ServiceDescriptorProto', package: const PackageName('google.protobuf'))
    ..aOS(1, 'name')
    ..pc<MethodDescriptorProto>(2, 'method', PbFieldType.PM, subBuilder: MethodDescriptorProto.create)
    ..hasRequiredFields = false;

  ServiceDescriptorProto() : super();
  static ServiceDescriptorProto create() => ServiceDescriptorProto._();
  ServiceDescriptorProto._() : super();
  @override
  BuilderInfo get info_ => _i;
  @override
  ServiceDescriptorProto clone() => ServiceDescriptorProto()..mergeFromMessage(this);
  @override
  ServiceDescriptorProto createEmptyInstance() => create();

  String get name => $_getS(0, '');
  List<MethodDescriptorProto> get method => $_getList(1);
}

class MethodDescriptorProto extends GeneratedMessage {
  static final BuilderInfo _i = BuilderInfo('MethodDescriptorProto', package: const PackageName('google.protobuf'))
    ..aOS(1, 'name')
    ..hasRequiredFields = false;

  MethodDescriptorProto() : super();
  static MethodDescriptorProto create() => MethodDescriptorProto._();
  MethodDescriptorProto._() : super();
  @override
  BuilderInfo get info_ => _i;
  @override
  MethodDescriptorProto clone() => MethodDescriptorProto()..mergeFromMessage(this);
  @override
  MethodDescriptorProto createEmptyInstance() => create();

  String get name => $_getS(0, '');
}

class ServerReflectionRequest extends GeneratedMessage {
  static final BuilderInfo _i = BuilderInfo('ServerReflectionRequest',
      package: const PackageName('grpc.reflection.v1alpha'),
      createEmptyInstance: create)
    ..aOS(1, 'host')
    ..aOS(3, 'fileByFilename')
    ..aOS(4, 'fileBySymbol')
    ..aOS(7, 'listServices')
    ..hasRequiredFields = false;

  ServerReflectionRequest() : super();
  factory ServerReflectionRequest.fromBuffer(List<int> i,
          [ExtensionRegistry r = ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  static ServerReflectionRequest create() => ServerReflectionRequest._();
  ServerReflectionRequest._() : super();

  @override
  BuilderInfo get info_ => _i;
  @override
  ServerReflectionRequest clone() => ServerReflectionRequest()..mergeFromMessage(this);
  @override
  ServerReflectionRequest createEmptyInstance() => create();

  String get host => $_getS(0, '');
  set host(String v) => $_setString(0, v);

  String get fileByFilename => $_getS(1, '');
  set fileByFilename(String v) => $_setString(1, v);

  String get fileBySymbol => $_getS(2, '');
  set fileBySymbol(String v) => $_setString(2, v);

  String get listServices => $_getS(3, '');
  set listServices(String v) => $_setString(3, v);
}

class ListServiceResponse extends GeneratedMessage {
  static final BuilderInfo _i = BuilderInfo('ListServiceResponse',
      package: const PackageName('grpc.reflection.v1alpha'),
      createEmptyInstance: create)
    ..pc<ServiceResponse>(1, 'service', PbFieldType.PM, subBuilder: ServiceResponse.create)
    ..hasRequiredFields = false;

  ListServiceResponse() : super();
  static ListServiceResponse create() => ListServiceResponse._();
  ListServiceResponse._() : super();

  @override
  BuilderInfo get info_ => _i;
  @override
  ListServiceResponse clone() => ListServiceResponse()..mergeFromMessage(this);
  @override
  ListServiceResponse createEmptyInstance() => create();

  List<ServiceResponse> get service => $_getList(0);
}

class ServiceResponse extends GeneratedMessage {
  static final BuilderInfo _i = BuilderInfo('ServiceResponse',
      package: const PackageName('grpc.reflection.v1alpha'),
      createEmptyInstance: create)
    ..aOS(1, 'name')
    ..hasRequiredFields = false;

  ServiceResponse() : super();
  factory ServiceResponse.fromBuffer(List<int> i,
          [ExtensionRegistry r = ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  static ServiceResponse create() => ServiceResponse._();
  ServiceResponse._() : super();

  @override
  BuilderInfo get info_ => _i;
  @override
  ServiceResponse clone() => ServiceResponse()..mergeFromMessage(this);
  @override
  ServiceResponse createEmptyInstance() => create();

  String get name => $_getS(0, '');
}

class FileDescriptorResponse extends GeneratedMessage {
  static final BuilderInfo _i = BuilderInfo('FileDescriptorResponse',
      package: const PackageName('grpc.reflection.v1alpha'),
      createEmptyInstance: create)
    ..p<List<int>>(1, 'fileDescriptorProto', PbFieldType.PY)
    ..hasRequiredFields = false;

  FileDescriptorResponse() : super();
  static FileDescriptorResponse create() => FileDescriptorResponse._();
  FileDescriptorResponse._() : super();

  @override
  BuilderInfo get info_ => _i;
  @override
  FileDescriptorResponse clone() => FileDescriptorResponse()..mergeFromMessage(this);
  @override
  FileDescriptorResponse createEmptyInstance() => create();

  List<List<int>> get fileDescriptorProto => $_getList(0);
}

class ServerReflectionResponse extends GeneratedMessage {
  static final BuilderInfo _i = BuilderInfo('ServerReflectionResponse',
      package: const PackageName('grpc.reflection.v1alpha'),
      createEmptyInstance: create)
    ..aOS(1, 'validHost')
    ..aOM<ServerReflectionRequest>(2, 'originalRequest', subBuilder: ServerReflectionRequest.create)
    ..aOM<FileDescriptorResponse>(4, 'fileDescriptorResponse', subBuilder: FileDescriptorResponse.create)
    ..aOM<ListServiceResponse>(6, 'listServicesResponse', subBuilder: ListServiceResponse.create)
    ..hasRequiredFields = false;

  ServerReflectionResponse() : super();
  factory ServerReflectionResponse.fromBuffer(List<int> i,
          [ExtensionRegistry r = ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  static ServerReflectionResponse create() => ServerReflectionResponse._();
  ServerReflectionResponse._() : super();

  @override
  BuilderInfo get info_ => _i;
  @override
  ServerReflectionResponse clone() => ServerReflectionResponse()..mergeFromMessage(this);
  @override
  ServerReflectionResponse createEmptyInstance() => create();

  ListServiceResponse get listServicesResponse => $_getN(3);
  FileDescriptorResponse get fileDescriptorResponse => $_getN(2);
}

class GrpcReflectionService {
  static Future<List<String>> listServices(String requestId, GrpcRequestModel model) async {
    final request = ServerReflectionRequest()..host = model.host..listServices = "";
    
    try {
      final call = ConnectionManager.instance.callGrpcMethod(
        requestId,
        "grpc.reflection.v1alpha.ServerReflection",
        "ServerReflectionInfo",
        request.writeToBuffer(),
      );

      final services = <String>[];
      await for (final responseBytes in call) {
        final response = ServerReflectionResponse.fromBuffer(responseBytes);
        if (response.hasField(6)) {
          for (final service in response.listServicesResponse.service) {
            services.add(service.name);
          }
          break; 
        }
      }
      return services;
    } catch (e) {
      return [];
    }
  }

  static Future<Map<String, List<String>>> getMethodsForService(String requestId, GrpcRequestModel model, String serviceName) async {
    final request = ServerReflectionRequest()..host = model.host..fileBySymbol = serviceName;
    
    try {
      final call = ConnectionManager.instance.callGrpcMethod(
        requestId,
        "grpc.reflection.v1alpha.ServerReflection",
        "ServerReflectionInfo",
        request.writeToBuffer(),
      );

      final Map<String, List<String>> result = {};
      
      await for (final responseBytes in call) {
        final response = ServerReflectionResponse.fromBuffer(responseBytes);
        if (response.hasField(4)) {
          for (final protoBytes in response.fileDescriptorResponse.fileDescriptorProto) {
            final fileProto = FileDescriptorProto.fromBuffer(protoBytes);
            final package = fileProto.package;
            
            for (final service in fileProto.service) {
              final fullName = package.isNotEmpty ? "$package.${service.name}" : service.name;
              if (fullName == serviceName) {
                final methods = service.method.map((m) => m.name).toList();
                result[fullName] = methods;
              }
            }
          }
          if (result.isNotEmpty) break;
        }
      }
      return result;
    } catch (e) {
      return {};
    }
  }
}
