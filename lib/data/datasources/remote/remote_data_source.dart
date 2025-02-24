import 'package:dartz/dartz.dart';
import 'package:machine_test/core/network/api_service.dart';
import 'package:machine_test/core/utils/routes/url_manager.dart';
import 'package:machine_test/data/datasources/local/secure_storage_local_data_source.dart';

class RemoteDataSource {
  final ApiService _apiService;

  final SecureStorageLocalDataSource secureDataSource;

  RemoteDataSource(this._apiService, this.secureDataSource);

  Future<Either<String, dynamic>> login(authParam) async {
    return await _apiService.post(ApiUrl.login, data: authParam);
  }

  Future<Either<String, dynamic>> fetchAllProducts() async {
    String? token = await secureDataSource.getToken();
    _apiService.token = token;
    return await _apiService.post(ApiUrl.products);
  }
}
