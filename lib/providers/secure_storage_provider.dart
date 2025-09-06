import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A small wrapper around FlutterSecureStorage that centralizes token helpers
class SecureStorageService {
  final FlutterSecureStorage _storage;

  SecureStorageService() : _storage = const FlutterSecureStorage();

  Future<String?> read(String key) => _storage.read(key: key);
  Future<void> write(String key, String? value) =>
      _storage.write(key: key, value: value);
  Future<void> delete(String key) => _storage.delete(key: key);

  // token specific helpers
  Future<String?> readAccess() => read(TokenKeys.access);
  Future<String?> readRefresh() => read(TokenKeys.refresh);
  Future<void> writeTokens(String access, String refresh) async {
    await write(TokenKeys.access, access);
    await write(TokenKeys.refresh, refresh);
  }
}

/// A provider that exposes the secure storage service
final secureStorageProvider = Provider<SecureStorageService>((ref) {
  return SecureStorageService();
});

/// Helper keys for token storage
class TokenKeys {
  static const access = 'access_token';
  static const refresh = 'refresh_token';
}
