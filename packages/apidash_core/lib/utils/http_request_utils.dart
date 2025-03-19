import 'package:apidash_core/consts.dart';
import 'package:seed/seed.dart';
import '../models/models.dart';
import 'graphql_utils.dart';

Map<String, String>? rowsToMap(
  List<NameValueModel>? kvRows, {
  bool isHeader = false,
}) {
  if (kvRows == null) {
    return null;
  }
  Map<String, String> finalMap = {};
  for (var row in kvRows) {
    if (row.name.trim() != "") {
      String key = row.name;
      if (isHeader) {
        key = key.toLowerCase();
      }
      finalMap[key] = row.value.toString();
    }
  }
  return finalMap;
}

List<NameValueModel>? mapToRows(
  Map<String, String>? kvMap,
) {
  if (kvMap == null) {
    return null;
  }
  List<NameValueModel> finalRows = [];
  for (var k in kvMap.keys) {
    finalRows.add(NameValueModel(name: k, value: kvMap[k]));
  }
  return finalRows;
}

List<Map<String, String>>? rowsToFormDataMapList(
  List<FormDataModel>? kvRows,
) {
  if (kvRows == null) {
    return null;
  }
  List<Map<String, String>> finalMap = kvRows
      .map((FormDataModel formData) =>
          (formData.name.trim().isEmpty && formData.value.trim().isEmpty)
              ? null
              : {
                  "name": formData.name,
                  "value": formData.value,
                  "type": formData.type.name,
                })
      .nonNulls
      .toList();
  return finalMap;
}

List<FormDataModel>? mapListToFormDataModelRows(
  List<Map>? kvMap,
) {
  if (kvMap == null) {
    return null;
  }
  List<FormDataModel> finalRows = kvMap.map(
    (formData) {
      return FormDataModel(
        name: formData["name"],
        value: formData["value"],
        type: getFormDataType(formData["type"]),
      );
    },
  ).toList();
  return finalRows;
}

FormDataType getFormDataType(String? type) {
  return FormDataType.values.firstWhere((element) => element.name == type,
      orElse: () => FormDataType.text);
}

List<NameValueModel>? getEnabledRows(
  List<NameValueModel>? rows,
  List<bool>? isRowEnabledList,
) {
  if (rows == null || isRowEnabledList == null) {
    return rows;
  }
  List<NameValueModel> finalRows =
      rows.where((element) => isRowEnabledList[rows.indexOf(element)]).toList();
  return finalRows == [] ? null : finalRows;
}

String? getRequestBody(APIType type, HttpRequestModel httpRequestModel) {
  return switch (type) {
    APIType.rest =>
      (httpRequestModel.hasJsonData || httpRequestModel.hasTextData)
          ? httpRequestModel.body
          : null,
    APIType.graphql => getGraphQLBody(httpRequestModel),
  };
}
Map<String, dynamic>? rowsToRequestMap(List<NameValueModel>? rows) {
  if (rows == null) {
    return null;
  }
  
  final Map<String, dynamic> finalMap = {};
  
  for (var row in rows) {
    final key = row.name.trim();
    if (key.isEmpty) continue;
    
    final value = row.value.toString();
    
    if (finalMap.containsKey(key)) {
     
      if (finalMap[key] is List) {
        (finalMap[key] as List).add(value);
      } else {
        finalMap[key] = [finalMap[key], value];
      }
    } else {
      
      finalMap[key] = value;
    }
  }
  
  return finalMap;
}

List<NameValueModel>? requestMapToRows(Map<String, dynamic>? requestMap) {
  if (requestMap == null) {
    return null;
  }
  
  final List<NameValueModel> finalRows = [];
  
  requestMap.forEach((key, value) {
    if (value is List) {
      for (var item in value) {
        finalRows.add(NameValueModel(name: key, value: item.toString()));
      }
    } else {
      finalRows.add(NameValueModel(name: key, value: value.toString()));
    }
  });
  
  return finalRows;
}