import 'package:dio/dio.dart';
import 'package:face/constants/handleDioException.dart';
import 'package:face/features/home/home.dart';
import 'package:face/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../constants/helpers.dart';

class OtpService {
  final Dio _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 20), // Ulanish uchun 10 sekund
    receiveTimeout: const Duration(seconds: 20), // Ma'lumot qabul qilish uchun 10 sekund
  ));

  // OTP tasdiqlash metodi
  Future<void> otp(String phone, String password, BuildContext context) async {
    final url = '${dotenv.get('BASE_URL')}/face/login'; // URL manzili

    try {
      // POST so'rovini yuborish
      final response = await _dio.post(
        url,
        data: {
          'phone': phone, // Telefon raqami
          'password': password, // Parol
        },
        options: Options(
          contentType: 'application/x-www-form-urlencoded', // Kontent turi
        ),
      );

      final statusCode = response.statusCode; // Status kodi
      final responseMessage = response.data['message'] as String?; // Javob xabari

      // Agar status kodi 200 bo'lsa
      if (statusCode == 200) {
        final token = response.data['token'] as String?; // Tokenni olish

        debugPrint('Status Code: $statusCode'); // Status kodini konsolga chiqarish

        if (token != null) {
          await Helpers.AuthToken(token); // Tokenni saqlash

          // Asosiy sahifaga o'tish
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => InitialPage()),
                (route) => false, // Oldingi sahifalarni o'chirish
          );
        }
      } else {
        // Xato xabarini ko'rsatish
        Helpers.showCustomSnackBar(context, responseMessage ?? 'Xatolik yuz berdi');
      }
    } on DioException catch (e) {
      // DioException xatosi
      print('Noma\'lum xato: $e'); // Xatoni konsolga chiqarish
      final errorMessage = await handleDioException(e, context);
      Helpers.showCustomSnackBar(context, errorMessage);
    } catch (e) {
      // Noma'lum xato
      Helpers.showCustomSnackBar(context, 'Noma\'lum xato');
      print('Noma\'lum xato: $e'); // Xatoni konsolga chiqarish
    }
  }
}
