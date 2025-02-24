import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class ApiService<T> {
  final Dio dio;
  String _token = "";

  ApiService(this.dio);

  String get token => _token;

  set token(String? value) {
    if (value != null && value.isNotEmpty) {
      _token = value;
    }
  }

  Future<Either<String, dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onReceiveProgress,
  }) async {
    try {
      Response response = await dio.get(dio.options.baseUrl + path,
          onReceiveProgress: onReceiveProgress,
          cancelToken: cancelToken,
          options: options,
          queryParameters: queryParameters);
      return right(response.data);
    } on DioException catch (err) {
      log("DioException: ${err.toString()}");
      return Left("Something went wrong");
    } catch (err) {
      log("Dio get ${err.toString()}");
      return Left("Something Went Wrong!");
    }
  }

  Future<Either<String, dynamic>> post(String path,
      {dynamic data,
      Map<String, dynamic>? queryParameters,
      Options? options,
      CancelToken? cancelToken,
      void Function(int, int)? onSendProgress,
      void Function(int, int)? onReceiveProgress,
      bool addRequestInterceptor = false}) async {
    try {
      if (addRequestInterceptor) {
        dio.interceptors.add(RequestInterceptor(token: token));
      }
      Response response = await dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
        onSendProgress: onSendProgress,
      );
      if (response.statusCode == 200) {
        return Right(response.data);
      } else {
        return Left("Invalid User Name or Password.");
      }
    } on DioException catch (err) {
      log("DioException: ${err.toString()}");
      return Left("Something went wrong");
    } catch (err) {
      log("Dio get ${err.toString()}");
      return Left("Something Went Wrong!");
    }
  }
}

class RequestInterceptor extends Interceptor {
  final String token;

  RequestInterceptor({required this.token});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['Authorization'] = 'Bearer $token';
    return handler.next(options);
  }
}
