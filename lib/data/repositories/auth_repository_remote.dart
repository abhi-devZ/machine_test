import 'package:dartz/dartz.dart';
import 'package:machine_test/data/datasources/remote/remote_data_source.dart';

import '../../../domain/repositories/auth_repository.dart';

class AuthRepositoryRemote extends AuthRepository {
  final RemoteDataSource remoteDataSource;

  AuthRepositoryRemote(this.remoteDataSource);

  Future<Either<String, dynamic>> login(Map<String, dynamic> authParam) {
    return remoteDataSource.login(authParam);
  }

  @override
  Future<bool> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }
}
