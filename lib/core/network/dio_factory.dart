import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:machine_test/core/constants/constants.dart';

class DioFactory {
  DioFactory();
  var cookieJar = CookieJar();

  Future<Dio> getDio() async {
    Dio dio = Dio();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Cache-control': 'no-cache,no-store',
      'Expires': '0',
      'Pragma': 'no-cache',
    };
    dio.options = BaseOptions(
      baseUrl: BASE_URL,
      headers: headers,
      connectTimeout: const Duration(milliseconds: apiTimeOut),
      receiveTimeout: const Duration(milliseconds: apiTimeOut),
      sendTimeout: const Duration(milliseconds: apiTimeOut),
    );

    // dio.interceptors.add(RetryInterceptor(
    //   dio: dio,
    //   retries: 3,
    //   retryInterval: const Duration(seconds: 5),
    // ));

    // if (!kReleaseMode) {
    //   dio.interceptors.add(PrettyDioLogger(
    //     requestHeader: true,
    //     requestBody: true,
    //     responseHeader: true,
    //   ));
    // }
    dio.interceptors.add(CookieManager(cookieJar));
    return dio;
  }
}
