import 'package:dio/dio.dart';
import 'package:face/constants/handleDioException.dart';
import 'package:face/constants/helpers.dart';
import 'package:face/features/home/data/model/getmestudents.dart';
import 'package:face/features/user/data/model/getme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GetmestudentsService{
  final Dio _dio = Dio();

  Future<Getmestudents> getstudents(BuildContext context) async {
    try {

      // Local storage'dan token olish
      final token = await Helpers.getAuthToken(); // Retrieve the token


      final url = '${dotenv.get('BASE_URL')}/admin/students/my-register';

      final   response = await _dio.get(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'multipart/form-data',
          },
        ),

      );

      final responseMessage = response.data['message'] as String?;

      if (response.statusCode == 200) {

        print(response.data);
        return Getmestudents.fromJson(response.data);
      } else {
        // Helpers.showCustomSnackBar(context, responseMessage ?? 'Xatolik yuz berdi');
        throw Exception('Failed to load categories'); // Xatolik holatida istisno tashlash
      }
    } on DioError catch (e) {
      final errorMessage = await handleDioException(e, context);
      // Helpers.showCustomSnackBar(context, errorMessage);
      throw Exception('Failed to load categories'); // Xatolik holatida istisno tashlash
    } catch (e) {
      Helpers.showCustomSnackBar(context, 'Unknown error');
      print('Noma\'lum xato: $e');
      throw Exception('Failed to load categories'); // Xatolik holatida istisno tashlash
    }
  }









}
