import 'package:apidash_core/apidash_core.dart';
import 'package:jinja/jinja.dart' as jj;
import 'package:path/path.dart' as path;

class SwiftURLSessionCodeGen {
  final String kTemplateStart = """
import Foundation

""";

  final String kTemplateFormDataImport = """
import MultipartFormData

""";

  final String kTemplateFormData = '''
let boundary = try! Boundary()
let multipartFormData = try! MultipartFormData(boundary: boundary) {
{% for param in formData %}
    {% if param.type == 'text' %}
    Subpart {
        ContentDisposition(name: "{{param.name}}")
    } body: {
        Data("{{param.value}}".utf8)
    }
    {% elif param.type == 'file' %}
    try Subpart {
        ContentDisposition(name: "{{param.name}}", filename: "{{param.filename}}")
        ContentType(mimeType: MimeType(pathExtension: "{{param.extension}}"))
    } body: {
        try Data(contentsOf: URL(fileURLWithPath: "{{param.filepath}}"))
    }
    {% endif %}
{% endfor %}
}

''';

  final String kTemplateJsonData = '''
let parameters = "{{jsonData}}"
let postData = parameters.data(using: .utf8)

''';

  final String kTemplateTextData = '''
let parameters = "{{textData}}"
let postData = parameters.data(using: .utf8)

''';

final String kTemplateRequest = """
var urlComponents = URLComponents(string: "{{url}}")!
var queryItems = [URLQueryItem]()

{% for param in params %}
queryItems.append(URLQueryItem(name: "{{param.key}}", value: "{{param.value}}")){% if not loop.last %}{% else %}{% endif %}{% endfor %}

urlComponents.queryItems = queryItems
let requestUrl = urlComponents.url!
var request = URLRequest(url: requestUrl)
request.httpMethod = "{{method}}"
""";

  final String kTemplateHeaders = """
{% for header, value in headers %}
request.addValue("{{value}}", forHTTPHeaderField: "{{header}}")
{% endfor %}

""";

  final String kTemplateBody = """
request.httpBody = try! multipartFormData.encode()

""";

  final String kTemplateEnd = """

let semaphore = DispatchSemaphore(value: 0) 

let task = URLSession.shared.dataTask(with: request) { data, response, error in 
    defer { semaphore.signal() }  

    if let error = error {
        print("Error: \\(error.localizedDescription)")
        return
    }
    guard let data = data else {
        print("No data received")
        return
    }
    if let responseString = String(data: data, encoding: .utf8) {
        print("Response: \\(responseString)")
    }
}

task.resume()

semaphore.wait()
""";

  String? getCode(HttpRequestModel requestModel) {
    try {
      String result = kTemplateStart;

      if (requestModel.hasFormData) {
        result += kTemplateFormDataImport;
      }

      var rec = 
      getValidRequestUri(requestModel.url, requestModel.enabledParams);
      Uri? uri = rec.$1;

    var params = requestModel.enabledParamsMap.entries.expand((entry) {

    var values = entry.value is Iterable ? entry.value : [entry.value];
    
    return values.map((value) {
      return {'key': entry.key, 'value': value};
    });
  }).toList();




      if (requestModel.hasFormData) {
        var formDataList = requestModel.formDataMapList.map((param) {
          if (param['type'] == 'file') {
            final filePath = param['value'] as String;
            final fileName = path.basename(filePath);
            final fileExtension =
                path.extension(fileName).toLowerCase().replaceFirst('.', '');
            return {
              'type': 'file',
              'name': param['name'],
              'filename': fileName,
              'extension': fileExtension,
              'filepath': filePath
            };
          } else {
            return {
              'type': 'text',
              'name': param['name'],
              'value': param['value']
            };
          }
        }).toList();

        var templateFormData = jj.Template(kTemplateFormData);
        result += templateFormData.render({
          "formData": formDataList,
        });
      } else if (requestModel.hasJsonData) {
        var templateJsonData = jj.Template(kTemplateJsonData);
        result += templateJsonData.render({
          "jsonData":
              requestModel.body!.replaceAll('"', '\\"').replaceAll('\n', '\\n'),
        });
      } else if (requestModel.hasTextData) {
        var templateTextData = jj.Template(kTemplateTextData);
        result += templateTextData.render({
          "textData":
              requestModel.body!.replaceAll('"', '\\"').replaceAll('\n', '\\n'),
        });
      }

      var templateRequest = jj.Template(kTemplateRequest);
      result += templateRequest.render({
        "url": uri.toString().split('?').first,
        "method": requestModel.method.name.toUpperCase(),
        "params": params, 
      });

      var headers = requestModel.enabledHeadersMap;
      if (requestModel.hasFormData) {
        headers.putIfAbsent("Content-Type",
            () => "multipart/form-data; boundary=\\(boundary.stringValue)");
      } else if (requestModel.hasJsonData || requestModel.hasTextData) {
        headers.putIfAbsent(
            kHeaderContentType, () => requestModel.bodyContentType.header);
      }
      if (headers.isNotEmpty) {
        var templateHeader = jj.Template(kTemplateHeaders);
        result += templateHeader.render({"headers": headers});
      }

      if (requestModel.hasFormData || requestModel.hasBody) {
        result += kTemplateBody;
      }

      result += kTemplateEnd;

      return result;
    } catch (e) {
      return null;
    }
  }
}
