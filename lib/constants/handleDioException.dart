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
            e.response?.data['message'] as String? ?? 'No\'maydon xatosi';
        message = '$errorMessage';
        print('Ruxsat etilmagans: ${e.response?.data}');
        break;
      case 401:
        message = e.response?.data['message'] ?? 'Xatolik yuz berdi'; // To'g'ridan-to'g'ri 'message' ni olish
        print('Message: $message'); // Yangi 'message' ni chop etish
        break;

      case 403:
        message = 'Ta’qiqlangan:';
        print('Ta’qiqlangan: ${e.response?.data}');
        break;
      case 404:
        message = 'Topilmadi';
        print('Topilmadi: ${e.response?.data}');
        break;
      case 422:
        message = "Inputni to'ldirish majburiy";
        print('Topilmadi: ${e.response?.data}');
        break;
      case 429:
        final responseData = e.response?.data as Map<String, dynamic>?;
        message =
            responseData?['message'] ?? 'Kutilmagan status kodi: $statusCode';
        print('Topilmadi: ${e.response?.data}');
        break;
      case 500:
        message = 'Login redirekt';
        print(
            'Ichki server xatosi: ${e.response?.statusCode} ${e.response
                ?.data} ');
        if (e.response?.data.contains('Route [login] not defined')) {
          await Helpers.removeToken(context);


          print(
              'Login yo\'riqnomasining aniqlanmaganligi: ${e.response?.data}');
          // Redirect to login or handle accordingly
        }
        break;
      default:
        message = 'Kutilmagan status kodi';
        print('Kutilmagan status kodi: $statusCode ${e.response?.data}');
        break;
    }
  } else {
    switch (e.type) {
      case DioExceptionType.cancel:
        message = 'So\'rov bekor qilindi.';
        print('So\'rov bekor qilindi: ${e.message}');
        break;
      case DioExceptionType.connectionTimeout:
        message = 'Ulanish vaqtida xato.';
        print('Ulanish vaqtida xato: ${e.message}');
        break;
      case DioExceptionType.sendTimeout:
        message = 'Yuborish vaqtida xato.';
        print('Yuborish vaqtida xato: ${e.message}');
        break;
      case DioExceptionType.receiveTimeout:
        message = 'Qabul qilish vaqtida xato.';
        print('Qabul qilish vaqtida xato: ${e.message}');
        break;
      case DioExceptionType.connectionError:
        message = "Internet aloqasi yo'q";
        print("Internet aloqasi yo'q ${e}");
        break;
      case DioExceptionType.badResponse:
        message = 'Yomon javob';
        print('Yomon javob: ${e.message}');
        break;
      default:
        message = 'Negadur internet aloqasi juda past';
        break;
    }
  }
  return message;
}
