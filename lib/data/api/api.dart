import 'dart:developer';
import 'dart:io';

import 'package:currency_convertor/config/constants.dart';
import 'package:currency_convertor/data/models/custom_exception.dart';
import 'package:dio/dio.dart';

class API {
  late Dio _dio;

  static final instance = API._();

  API._() {
    BaseOptions options = BaseOptions(
      baseUrl: Constants.baseURL,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 15),
    );

    _dio = Dio(options);

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        log('🚀🚀🚀---------------------------------🚀🚀🚀');
        log('| REQUEST SENT:');
        log('|    🟡 FULL URL: ${options.uri.toString()}');
        log('|    🟡 PARAMETERS: ${options.data.toString()}');
        log('|    🟡 PATH/QUERY: ${options.path.toString()}');
        log('|    🟡 HEADERS: ${options.headers.toString()}');
        log('🚀🚀🚀---------------------------------🚀🚀🚀');
        log('\n');
        handler.next(options);
      },
      onResponse: (e, handler) {
        if (e.data.containsKey('error')) {
          log('-----------------❌❌❌❌❌❌-----------------');
          log('| RESPONSE RECIEVED:');
          log('|    🔴 REQUEST: ${e.realUri.toString()}');
          log('|    🔴 DATA: ${e.data.toString()}');
          log('-----------------❌❌❌❌❌-----------------');
          log('\n');
        } else {
          log('-----------------✅✅✅✅✅-----------------');
          log('| RESPONSE RECIEVED:');
          log('|    🟢 REQUEST: ${e.realUri.toString()}');
          log('|    🟢 DATA: ${e.data.toString()}');
          log('-----------------✅✅✅✅✅-----------------');
          log('\n');
          handler.next(e);
        }
      },
    ));
  }

  Future<Response<dynamic>> fetchData(String query) async {
    try {
      return await _dio.get(query);
    } on DioException catch (e) {
      if (e.error is! SocketException) {
        throw CustomException.fromDioException(e);
      }
      rethrow;
    }
  }
}
