import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:machine_test/core/network/api_service.dart';
import 'package:machine_test/core/network/dio_factory.dart';
import 'package:machine_test/data/datasources/local/secure_storage_local_data_source.dart';
import 'package:machine_test/data/datasources/remote/remote_data_source.dart';
import 'package:machine_test/data/repositories/auth_repository_local.dart';
import 'package:machine_test/data/repositories/auth_repository_remote.dart';
import 'package:machine_test/data/repositories/product_remote_repository.dart';

final il = GetIt.instance; // instance locator

Future<void> init() async {
  //DioFactory instance
  il.registerLazySingleton<DioFactory>(() => DioFactory());
  final dio = await il.get<DioFactory>().getDio();

  //AppServiceClient instance
  il.registerLazySingleton(() => ApiService(dio));
  il.registerSingleton<FlutterSecureStorage>(const FlutterSecureStorage());

  il.registerSingleton(SecureStorageLocalDataSource(il.get<FlutterSecureStorage>()));
  il.registerLazySingleton<AuthRepositoryLocal>(() => AuthRepositoryLocal(il.get<SecureStorageLocalDataSource>()));

  il.registerSingleton<RemoteDataSource>(
      RemoteDataSource(il.get<ApiService>(), il.get<SecureStorageLocalDataSource>()));


  il.registerLazySingleton<AuthRepositoryRemote>(() => AuthRepositoryRemote(il.get<RemoteDataSource>()));
  il.registerLazySingleton<ProductRepositoryRemote>(() => ProductRepositoryRemote(il.get<RemoteDataSource>()));
}
