import 'package:dartz/dartz.dart';
import 'package:machine_test/data/datasources/remote/remote_data_source.dart';
import 'package:machine_test/domain/repositories/product_repository.dart';

import '../../../domain/repositories/auth_repository.dart';

class ProductRepositoryRemote extends ProductRepository {
  final RemoteDataSource remoteDataSource;

  ProductRepositoryRemote(this.remoteDataSource);

  @override
  Future<Either<String, dynamic>> fetchAllProducts() {
    return remoteDataSource.fetchAllProducts();
  }
}
