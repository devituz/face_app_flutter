import 'package:face/features/login/screens/login.dart';
import 'package:face/main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Helpers {
  // Show a SnackBar with a message
  static void showCustomSnackBar(BuildContext context, String message) {
    final screenWidth = MediaQuery.of(context).size.width;

    final snackBar = SnackBar(
      width: screenWidth * 0.9,
      // Ekran kengligining 90%ini qo'llash
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.red,
      // Xabar rangini o'zgartirish (qizil)
      content: Text(
        message,
        style: TextStyle(color: Colors.white), // Matn rangini o'zgartirish
      ),
      duration: const Duration(seconds: 5), // 5 seconds duration
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static Future<void> AuthToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token); // Store the token
    debugPrint('Token saved: $token'); // Log for debugging
  }



// Method to retrieve the token (if needed)
  static Future<String?> getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    final apiToken = prefs.getString('auth_token');
    debugPrint('Received Token: $apiToken');
    return apiToken; // Return the token
  }



  static Future<bool> isAuthTokenAvailable() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    return token != null;
  }

  // Tokenni lokal saqlashdan o'chirish metodi
  static Future<void> removeToken(context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) =>  InitialPage()),
          (route) => false,
    );
    debugPrint('Auth token removed');
  }





}
