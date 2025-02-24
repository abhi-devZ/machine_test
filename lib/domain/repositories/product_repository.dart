import 'package:dartz/dartz.dart';

abstract class ProductRepository {
  Future<Either<String, dynamic>> fetchAllProducts();
}