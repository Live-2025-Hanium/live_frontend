import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// 키체인/Keystore 에 안전하게 저장하는 인스턴스
final _secureStorage = FlutterSecureStorage();

const _kAccessToken = 'access_token';

class SecureStorage {
  Future<void> writeToken(String token) =>
      _secureStorage.write(key: _kAccessToken, value: token);

  Future<String?> readToken() => _secureStorage.read(key: _kAccessToken);

  Future<void> deleteToken() => _secureStorage.delete(key: _kAccessToken);
}
