import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A small wrapper that uses secure storage on native and SharedPreferences on web.
class SecureStorageService {
  final FlutterSecureStorage _storage;

  SecureStorageService() : _storage = const FlutterSecureStorage();

  Future<String?> read(String key) async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(key);
    }
    return _storage.read(key: key);
  }

  Future<void> write(String key, String? value) async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      if (value == null) {
        await prefs.remove(key);
      } else {
        await prefs.setString(key, value);
      }
      return;
    }
    await _storage.write(key: key, value: value);
  }

  Future<void> delete(String key) async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(key);
      return;
    }
    await _storage.delete(key: key);
  }

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
