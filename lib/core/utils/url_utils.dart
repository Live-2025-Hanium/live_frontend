// Conditional exports for web and non-web implementations
export 'url_utils_stub.dart' if (dart.library.html) 'url_utils_web.dart';
