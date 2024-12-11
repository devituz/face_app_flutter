import 'package:dio/dio.dart';
import 'package:face/constants/helpers.dart';
import 'package:face/features/login/screens/login.dart';
import 'package:flutter/material.dart';

Future<String> handleDioException(DioException e, BuildContext context) async {
  String message;
  if (e.response != null) {
    final statusCode = e.response?.statusCode;
    switch (statusCode) {
      case 400:
        final errorMessage =
            e.response?.data['message'] as String? ?? 'Field error';
        message = '$errorMessage';
        print('Unauthorized: ${e.response?.data}');
        break;
      case 401:
        message = e.response?.data['message'] ?? 'An error occurred'; // Directly taking 'message'
        print('Message: $message'); // Print the new 'message'
        break;

      case 403:
        message = 'Forbidden';
        await Helpers.removeToken(context);
        print('Forbidden: ${e.response?.data}');
        break;
      case 404:
        message = 'Not found';
        print('Not found: ${e.response?.data}');
        break;
      case 422:
        message = "Input is required";
        print('Not found: ${e.response?.data}');
        break;
      case 429:
        final responseData = e.response?.data as Map<String, dynamic>?;
        message =
            responseData?['message'] ?? 'Unexpected status code: $statusCode';
        print('Not found: ${e.response?.data}');
        break;
      case 500:
        message = 'Login redirect';
        await Helpers.removeToken(context);
        print(
            'Internal server error: ${e.response?.statusCode} ${e.response?.data}');
        break;
      default:
        message = 'Unexpected status code';
        print('Unexpected status code: $statusCode ${e.response?.data}');
        break;
    }
  } else {
    switch (e.type) {
      case DioExceptionType.cancel:
        message = 'Request was canceled.';
        print('Request canceled: ${e.message}');
        break;
      case DioExceptionType.connectionTimeout:
        message = 'Connection timeout.';
        print('Connection timeout: ${e.message}');
        break;
      case DioExceptionType.sendTimeout:
        message = 'Send timeout.';
        print('Send timeout: ${e.message}');
        break;
      case DioExceptionType.receiveTimeout:
        message = 'Receive timeout.';
        print('Receive timeout: ${e.message}');
        break;
      case DioExceptionType.connectionError:
        message = "No internet connection";
        print("No internet connection ${e}");
        break;
      case DioExceptionType.badResponse:
        message = 'Bad response';
        print('Bad response: ${e.message}');
        break;
      default:
        message = 'Internet connection is very poor';
        break;
    }
  }
  return message;
}
