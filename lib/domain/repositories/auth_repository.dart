import 'package:dartz/dartz.dart';

abstract class AuthRepository {
  Future<bool> logout();
}