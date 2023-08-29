import 'dart:developer';

import 'package:dio/dio.dart';

class CustomException implements Exception {
  final String reason;
  final String text;
  final int? statusCode;

  CustomException({required this.reason, required this.text, this.statusCode});

  static CustomException fromDioException(DioException exception) {
    final String reason = exception.response?.data['error']['code'];
    final String text = exception.response?.data['error']['message'];
    final int? statusCode = exception.response?.statusCode;
    log('🔥 $statusCode $reason:\n🔥 $text');
    return CustomException(reason: reason, text: text, statusCode: statusCode);
  }
}
