// Web implementation to remove a query parameter via history.replaceState
import 'dart:html' as html;

bool removeQueryParam(String key) {
  final uri = Uri.base;
  final params = Map<String, String>.from(uri.queryParameters);
  if (!params.containsKey(key)) return false;
  params.remove(key);
  final newUri = uri.replace(queryParameters: params);
  html.window.history.replaceState(null, '', newUri.toString());
  return true;
}
