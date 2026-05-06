import 'dart:convert';

import 'package:schoolapp/core/services/interceptors/auth/auth_interceptor.dart';
import 'package:schoolapp/flavor/app_config.dart';
import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:dio/dio.dart' as d;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService extends GetxService {
  ApiService init() => this;

  String get baseUrl => dotenv.env['BASE_URL'] ?? '';
  Logger get logger => Logger.root;

  Future<d.Dio> _dioClient({bool? isShowLoading}) async {
    final client = d.Dio(
      d.BaseOptions(
        followRedirects: false,
        contentType: 'application/json',
        responseType: d.ResponseType.json,
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Charset': 'utf-8',
        },
        baseUrl: baseUrl,
        sendTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        connectTimeout: const Duration(seconds: 30),
      ),
    );

    // client.interceptors.add(LoadingInterceptor(isShow: isShowLoading ?? false));
    //
    client.interceptors.add(
      AuthenticationInterceptor(
        accessToken: AppConfig.shared.authorizationToken,
      ),
    );

    print(client);
    return client;
  }

  Future<d.Response> get(
    String? path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    bool? isShowLoading,
  }) async {
    if (path == null) {
      throw 'Path is null';
    }
    final client = await _dioClient(isShowLoading: isShowLoading);

    if (headers != null) {
      for (MapEntry entry in headers.entries) {
        client.options.headers[entry.key] = entry.value;
      }
    }

    return client.get(path, queryParameters: queryParameters);
  }

  Future<d.Response> post(
    String path,
    dynamic formData, {
    int? retries,
    String? customBaseUrl,
    bool encode = true,
    Map<String, dynamic>? cusHeaders,
    bool? isShowLoading,
  }) async {
    final client = await _dioClient(isShowLoading: isShowLoading);

    if (customBaseUrl != null) {
      client.options.baseUrl = customBaseUrl;
    }

    if (cusHeaders != null) {
      client.options.headers.addEntries(cusHeaders.entries);
    }

    print("BASE URL (ApiService): ${client.options.baseUrl}");

    return client.post(
      path,
      data:
          formData is d.FormData
              ? formData
              : encode
              ? jsonEncode(formData)
              : formData,
    );
  }

  Future<d.Response> put(String path, {dynamic formData}) async {
    final client = await _dioClient();

    return client.put(
      path,
      data: formData is d.FormData ? formData : jsonEncode(formData),
    );
  }

  Future<d.Response> delete(String path, {dynamic data}) async {
    final client = await _dioClient();

    return client.delete(path, data: data);
  }

  Future<d.Response> patch(String path, {dynamic formData}) async {
    final client = await _dioClient();

    return client.patch(
      path,
      data: formData is d.FormData ? formData : jsonEncode(formData),
    );
  }
}
