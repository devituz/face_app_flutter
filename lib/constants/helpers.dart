import 'package:face/features/login/screens/login.dart';
import 'package:face/main.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return InitialPage(); // Yangi sahifa (InitialPage)
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0); // Pastdan tepaga ochish
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(position: offsetAnimation, child: child);
        },
      ),
          (route) => false, // Oldingi sahifalarni o'chirish
    );
    debugPrint('Auth token removed');
  }


  static String formatDate(String dateString) {
    try {
      // Parse the string into a DateTime object (assumes it's in UTC)
      DateTime parsedDate = DateTime.parse(dateString).toLocal();

      // Check if the time is AM or PM and format accordingly
      String formattedDate;
      if (parsedDate.hour >= 12) {
        // If it's PM, format in 24-hour format
        formattedDate = DateFormat('MMM d, yyyy HH:mm').format(parsedDate);
      } else {
        // If it's AM, format in 12-hour format (keeping as is)
        formattedDate = DateFormat('MMM d, yyyy h:mm a').format(parsedDate);
      }

      return formattedDate; // Return the formatted date string
    } catch (e) {
      // In case of error, return a fallback message
      return 'Invalid Date';
    }
  }


}
