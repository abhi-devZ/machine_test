import 'package:dartz/dartz.dart';
import 'package:machine_test/data/datasources/local/secure_storage_local_data_source.dart';
import 'package:machine_test/domain/repositories/auth_repository.dart';

class AuthRepositoryLocal extends AuthRepository {
  final SecureStorageLocalDataSource secureDataSource;

  AuthRepositoryLocal(this.secureDataSource);

  Future<String?> getToken() async {
    String? token = await secureDataSource.getToken();
    return token;
  }

  Future<bool> hasToken() async {
    return await secureDataSource.hasToken();
  }

  Future<void> saveToken({token}) async {
    secureDataSource.saveToken(token: token);
  }

  Future<bool> clearToken() async {
    secureDataSource.clearToken();
    return true;
  }

  @override
  Future<bool> logout() async {
    clearToken();
    return true;
  }
}
