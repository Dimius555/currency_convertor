import 'package:currency_convertor/config/constants.dart';
import 'package:currency_convertor/data/models/failed_response.dart';
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
  }

  Future<Response<dynamic>> fetchData(String query) async {
    try {
      return await _dio.get(query);
    } on DioException catch (e) {
      throw CustomException.fromDioException(e);
    }
  }
}
