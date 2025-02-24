import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageLocalDataSource {
  final FlutterSecureStorage _secureStorage;
  final String _tokenKey = 'auth_token';

  SecureStorageLocalDataSource(this._secureStorage);

  AndroidOptions _getAndroidOptions() => const AndroidOptions(
    encryptedSharedPreferences: true,
  );

  IOSOptions _getIOSOptions() => const IOSOptions(accountName: "rm-employee-app-v2");

  Future<String?> getToken() async {
    return await _secureStorage.read(key: _tokenKey, aOptions: _getAndroidOptions(), iOptions: _getIOSOptions());
  }

  Future<bool> hasToken() async {
    var value = await _secureStorage.read(key: _tokenKey, aOptions: _getAndroidOptions(), iOptions: _getIOSOptions());
    return value != null;
  }

  Future<void> clearToken() async {
    await _secureStorage.delete(key: _tokenKey, aOptions: _getAndroidOptions(), iOptions: _getIOSOptions());
  }

  Future<void> saveToken({token}) async {
    await _secureStorage.write(
        key: _tokenKey, value: token, aOptions: _getAndroidOptions(), iOptions: _getIOSOptions());
  }
}