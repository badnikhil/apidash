import 'package:collection/collection.dart' show mergeMaps;
import 'package:seed/seed.dart';
import '../consts.dart';
import 'http_request_utils.dart';

(String?, bool) getUriScheme(Uri uri) {
  if (uri.hasScheme) {
    if (kSupportedUriSchemes.contains(uri.scheme.toLowerCase())) {
      return (uri.scheme, true);
    }
    return (uri.scheme, false);
  }
  return (null, false);
}

String stripUriParams(Uri uri) {
  return "${uri.scheme}://${uri.authority}${uri.path}";
}

String stripUrlParams(String url) {
  var idx = url.indexOf("?");
  return idx > 0 ? url.substring(0, idx) : url;
}

(Uri?, String?) getValidRequestUri(
    String? url, List<NameValueModel>? requestParams,
    {SupportedUriSchemes defaultUriScheme = kDefaultUriScheme}) {
  url = url?.trim();
  if (url == null || url == "") {
    return (null, "URL is missing!");
  }

  if (kLocalhostRegex.hasMatch(url)) {
    url = '${SupportedUriSchemes.http.name}://$url';
  }
  Uri? uri = Uri.tryParse(url);
  if (uri == null) {
    return (null, "Check URL (malformed)");
  }
  (String?, bool) urlScheme = getUriScheme(uri);

  if (urlScheme.$1 != null) {
    if (!urlScheme.$2) {
      return (null, "Unsupported URL Scheme (${urlScheme.$1})");
    }
  } else {
    url = "${defaultUriScheme.name}://$url";
  }

  uri = Uri.parse(url);
  if (uri.hasFragment) {
    uri = uri.removeFragment();
  }

  Map<String, List<String>> queryParams = uri.queryParametersAll;

  Map<String, dynamic>? requestQueryParams = rowsToRequestMap(requestParams);
  if (requestQueryParams != null) {
    Map<String, List<String>> queryParamsList = requestQueryParams.map((key, value) {
      return MapEntry(key, List<String>.from(value is String ? [value] : value));
    });
    queryParams = mergeMaps(queryParams, queryParamsList, value: (v1, v2) => v1 + v2);
  }
  if (queryParams.isNotEmpty) {
    uri = uri.replace(queryParameters: queryParams);
  }
  return (uri, null);
}
