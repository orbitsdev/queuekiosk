import 'package:dio/dio.dart' as dio;
import 'package:kiosk/models/failure.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:fpdart/fpdart.dart';

import 'app_string.dart';
import 'response_codes.dart';
import 'response_messages.dart';

class DioService {
  static final DioService _instance = DioService._internal();
  late final dio.Dio _dio;

  // 🔑 Change this to match your backend base URL for the kiosk endpoints
  static const String _baseUrl = "https://your-domain.com/api/kiosk";

  factory DioService() {
    return _instance;
  }

  DioService._internal() {
    _initDio();
  }

  dio.Dio get client => _dio;

  void _initDio() {
    _dio = dio.Dio(
      dio.BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        sendTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      compact: true,
    ));
  }

  /// 🔑 Generic request wrapper using Either (Success: dio.Response, Failure: Failure)
  Future<Either<Failure, dio.Response>> request({
    required String path,
    required String method,
    Map<String, dynamic>? queryParameters,
    dynamic data,
  }) async {
    try {
      final dio.Response response = await _dio.request(
        path,
        queryParameters: queryParameters,
        data: data,
        options: dio.Options(method: method),
      );
      return Right(response);
    } on dio.DioException catch (e) {
      return Left(_handleError(e));
    } catch (_) {
      return Left(Failure(
        code: ResponseCode.defaultError,
        message: ResponseMessage.defaultError,
      ));
    }
  }

  /// 🔑 Centralized Dio error to Failure
  Failure _handleError(dio.DioException error) {
    switch (error.type) {
      case dio.DioExceptionType.connectionTimeout:
      case dio.DioExceptionType.sendTimeout:
      case dio.DioExceptionType.receiveTimeout:
        return Failure(
          code: ResponseCode.connectTimeout,
          message: ResponseMessage.connectTimeout,
        );

      case dio.DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode ?? 0;
        return Failure(
          code: statusCode,
          message: _handleStatusCode(statusCode),
        );

      case dio.DioExceptionType.cancel:
        return Failure(
          code: ResponseCode.cancel,
          message: ResponseMessage.cancel,
        );

      case dio.DioExceptionType.unknown:
        return Failure(
          code: ResponseCode.noInternetConnection,
          message: ResponseMessage.noInternetConnection,
        );

      default:
        return Failure(
          code: ResponseCode.defaultError,
          message: ResponseMessage.defaultError,
        );
    }
  }

  /// 🔑 Match status codes to user-friendly messages
  String _handleStatusCode(int? statusCode) {
    switch (statusCode) {
      case ResponseCode.badRequest:
        return ResponseMessage.badRequest;
      case ResponseCode.unauthorized:
        return ResponseMessage.unauthorized;
      case ResponseCode.forbidden:
        return ResponseMessage.forbidden;
      case ResponseCode.notFound:
        return ResponseMessage.notFound;
      case ResponseCode.internalServerError:
        return ResponseMessage.internalServerError;
      default:
        return ResponseMessage.defaultError;
    }
  }
}
