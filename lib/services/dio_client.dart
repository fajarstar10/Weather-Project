import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:dio/dio.dart';

import '../utils/constants.dart';

class DioClient {
  final Dio _dio;

  DioClient()
      : _dio = Dio(
          BaseOptions(
            baseUrl: Constants.baseUrl,
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 10),
            queryParameters: {
              'appid': Constants.apiKey,
            },
          ),
        ) {
    _dio.interceptors.add(ChuckerDioInterceptor());
  }

  Dio get dio => _dio;
}
