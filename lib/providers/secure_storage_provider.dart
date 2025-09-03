import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A simple wrapper provider for FlutterSecureStorage.
final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});

/// Helper keys for token storage
class TokenKeys {
  static const access = 'access_token';
  static const refresh = 'refresh_token';
}
