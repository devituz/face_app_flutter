import 'package:cached_network_image/cached_network_image.dart';
import 'package:face/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class ImageDisplayPage extends StatelessWidget {
  final String name;
  final String file;

  const ImageDisplayPage({Key? key, required this.name, required this.file})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppStyles.myColor),
        backgroundColor: AppStyles.oq,
        elevation: 0,
        centerTitle: true,
        title:  Text(
          'Candidate information',
          style: GoogleFonts.exo2(
            color: AppStyles.myColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 50),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LayoutBuilder(
                  builder: (context, constraints) {
                    // Using MediaQuery to get the screen width and height
                    double screenWidth = MediaQuery.of(context).size.width;
                    double screenHeight = MediaQuery.of(context).size.height;

                    // Adjust the image size based on the screen width
                    double imageSize = screenWidth * 0.2; // 50% of screen width

                    return Image(
                      width: imageSize, // Dynamic width
                      height: imageSize, // Dynamic height
                      image: AssetImage("assets/verification/verification.png"),
                    );
                  },
                ),
                 Text(
                  "Verified",
                  style: GoogleFonts.exo2(
                    color: AppStyles.myColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: "$file",
                      width: screenWidth * 0.60,
                      height: screenWidth * 0.60,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      // Yuklash vaqtida ko'rsatiladigan indikator
                      errorWidget: (context, url, error) => const Icon(Icons
                          .error), // Xato yuz berganda ko'rsatiladigan ikonka
                    ),
                  ),
                  const SizedBox(height: 25),
                  Text(
                    'Full name',
                    style: GoogleFonts.exo2(
                      fontWeight: FontWeight.bold,
                      color: AppStyles.qora,
                      fontSize: screenWidth * 0.05,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '$name',
                    style: GoogleFonts.exo2(
                      fontWeight: FontWeight.bold,
                      color: AppStyles.myColor,
                      fontSize: screenWidth * 0.08,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      backgroundColor: AppStyles.oq,
    );
  }
}

