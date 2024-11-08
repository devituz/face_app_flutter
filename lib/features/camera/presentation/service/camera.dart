import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../../../constants/helpers.dart';

class CameraService {
  final Dio _dio = Dio();

  Future<Map<String, dynamic>> postCamera({
    required File file,
    required BuildContext context,
  }) async {
    final token = await Helpers.getAuthToken(); // Retrieve the token
    final url = '${dotenv.get('BASE_URL')}/admin/student'; // URL manzili
    try {
      // Prepare file for multipart form-data upload
      FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          file.path,
          filename: file.path.split('/').last,
        ),
      });

      // Set the headers with the token
      final response = await _dio.post(
        url,
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token', // Include the Bearer token
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      debugPrint('Full response: ${jsonEncode(response.data)}');
      debugPrint('Status response: ${response.statusCode}');


      if (response.statusCode == 200) {
        // debugPrint('File uploaded successfully');
        debugPrint(response.data.toString());
        return {
          'name': response.data['name'], // Ismni qaytaradi
          'file': response.data['file'], // Faylni qaytaradi
        };
      } else {
        debugPrint('Error uploading file: ${response.statusCode}');
        throw Exception('Error uploading file');
      }
    } catch (e) {
      debugPrint('postCamera error: $e');
      rethrow;
    }
  }
}


