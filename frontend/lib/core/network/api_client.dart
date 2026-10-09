import 'dart:io' show Platform;
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;

  late final Dio dio;
  String? authToken;

  ApiClient._internal() {
    String baseUrl = '';
    if (dotenv.isInitialized) {
      baseUrl = dotenv.env['API_BASE_URL'] ?? '';
    }
    if (baseUrl.isEmpty) {
      if (!kIsWeb && Platform.isAndroid) {
        baseUrl = 'http://10.0.2.2:5000/api';
      } else {
        baseUrl = 'http://localhost:5000/api';
      }
    }

    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (authToken != null && authToken!.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $authToken';
          }
          return handler.next(options);
        },
      ),
    );
  }

  void setToken(String token) {
    authToken = token;
  }

  void clearToken() {
    authToken = null;
  }

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    return await dio.get<T>(path, queryParameters: queryParameters);
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    return await dio.post<T>(path, data: data, queryParameters: queryParameters);
  }

  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    return await dio.patch<T>(path, data: data, queryParameters: queryParameters);
  }

  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    return await dio.delete<T>(path, data: data, queryParameters: queryParameters);
  }
}
