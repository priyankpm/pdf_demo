import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'oauth2_client.dart';

class DioClient {
  final Dio _dio;
  final OAuth2Client? _oauth2Client;

  DioClient(
    String baseUrl, {
    Map<String, dynamic>? defaultHeaders,
    OAuth2Client? oauth2Client,
  }) : _dio = Dio(
         BaseOptions(
           baseUrl: baseUrl,
           connectTimeout: const Duration(seconds: 10),
           receiveTimeout: const Duration(seconds: 15),
           headers: defaultHeaders ?? {},
           contentType: 'application/json',
         ),
       ),
       _oauth2Client = oauth2Client {
    // Interceptor to inject token if OAuth2 is provided
    if (_oauth2Client != null) {
      _dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) async {
            try {
              await _oauth2Client.refreshTokenIfNeeded();
              final token = _oauth2Client.client.credentials.accessToken;
              options.headers['Authorization'] = 'Bearer $token';
            } catch (e) {
              return handler.reject(
                DioException(
                  requestOptions: options,
                  error: 'OAuth2 token error: $e',
                  type: DioExceptionType.unknown,
                ),
              );
            }
            return handler.next(options);
          },
        ),
      );
    }

    _dio.interceptors.addAll([
      PrettyDioLogger(
        requestBody: true,
        requestHeader: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
      ),
    ]);
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> post(
    String path, {
    dynamic data,
    Options? options,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.post(
        path,
        data: data,
        options: options,
        queryParameters: queryParameters,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> put(
    String path, {
    dynamic data,
    Options? options,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.put(
        path,
        data: data,
        options: options,
        queryParameters: queryParameters,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> delete(
    String path, {
    dynamic data,
    Options? options,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.delete(
        path,
        data: data,
        options: options,
        queryParameters: queryParameters,
      );
    } catch (e) {
      rethrow;
    }
  }

  Dio get dio => _dio;
}
