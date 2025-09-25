import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';

/// 키체인/Keystore 에 안전하게 저장하는 인스턴스
final _secureStorage = const FlutterSecureStorage();

const _kAccessToken = 'access_token';

class SecureStorage {
  Future<void> writeToken(String token) async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_kAccessToken, token);
    } else {
      await _secureStorage.write(key: _kAccessToken, value: token);
    }
  }

  Future<String?> readToken() async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_kAccessToken);
    } else {
      return _secureStorage.read(key: _kAccessToken);
    }
  }

  Future<void> deleteToken() async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_kAccessToken);
    } else {
      await _secureStorage.delete(key: _kAccessToken);
    }
  }
}
