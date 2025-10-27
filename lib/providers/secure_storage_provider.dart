import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A small wrapper that uses secure storage on mobile and shared_preferences on web.
class SecureStorageService {
  final FlutterSecureStorage _secureStorage;
  SharedPreferences? _prefs;

  SecureStorageService() : _secureStorage = const FlutterSecureStorage();

  Future<void> _initPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  Future<String?> read(String key) async {
    if (kIsWeb) {
      await _initPrefs();
      return _prefs!.getString(key);
    }
    return _secureStorage.read(key: key);
  }

  Future<void> write(String key, String? value) async {
    if (kIsWeb) {
      await _initPrefs();
      if (value == null) {
        await _prefs!.remove(key);
      } else {
        await _prefs!.setString(key, value);
      }
      return;
    }
    await _secureStorage.write(key: key, value: value);
  }

  Future<void> delete(String key) async {
    if (kIsWeb) {
      await _initPrefs();
      await _prefs!.remove(key);
      return;
    }
    await _secureStorage.delete(key: key);
  }

  Future<void> deleteAll() async {
    if (kIsWeb) {
      await _initPrefs();
      await _prefs!.clear();
      return;
    }
    await _secureStorage.deleteAll();
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