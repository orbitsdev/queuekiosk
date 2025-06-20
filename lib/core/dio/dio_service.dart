
import 'package:dio/dio.dart' as dio;

class DioService {
  // static final DioService _instance = DioService._internal();
  // late dio.Dio _dio;
  // final Share _storage = const FlutterSecureStorage();
  // final Connectivity _connectivity = Connectivity();
  
  // static const String _tokenKey = 'access_token';
  // static final String baseUrl = ApiConfig.baseUrl;
  // static const String apiPrefix = '/api';

  // factory DioService() {
  //   return _instance;
  // }
  
  // DioService._internal() {
  //   _initDio(); 
  // }
  
  // dio.Dio get client => _dio;
  
  // void _initDio() {
  //   _dio = dio.Dio(dio.BaseOptions(
  //     baseUrl: baseUrl,
  //     connectTimeout: const Duration(milliseconds: 15000),
  //     receiveTimeout: const Duration(milliseconds: 15000),
  //     sendTimeout: const Duration(milliseconds: 15000),
  //     headers: {
  //       'Content-Type': 'application/json',
  //       'Accept': 'application/json',
  //     },
  //   ));
    
  //   _dio.interceptors.add(PrettyDioLogger(
  //     requestHeader: true,
  //     requestBody: true,
  //     responseBody: true,
  //     responseHeader: false,
  //     compact: false,
  //   ));
    
  //   _dio.interceptors.add(dio.InterceptorsWrapper(
  //     onRequest: (dio.RequestOptions options, dio.RequestInterceptorHandler handler) async {
  //       final token = await getToken();
  //       if (token != null) {
  //         options.headers['Authorization'] = 'Bearer $token';
  //       }
  //       return handler.next(options);
  //     },
  //     onError: (dio.DioException error, dio.ErrorInterceptorHandler handler) async {
  //       if (error.response?.statusCode == 401) {
  //         await _storage.delete(key: _tokenKey);
  //         // Force logout via AuthController if available
  //         try {
  //           // Import is already available, so we can use Get.find
  //           final authController = Get.isRegistered<AuthController>()
  //               ? Get.find<AuthController>()
  //               : null;
  //           if (authController != null) {
  //             await authController.forceLogout(message: 'Session expired or invalid. Please login again.');
  //           }
  //         } catch (_) {}
  //       }
  //       return handler.next(error);
  //     },
  //   ));
    
  //   _setupConnectivity();
  // }

}