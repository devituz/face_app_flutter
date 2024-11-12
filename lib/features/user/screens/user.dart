import 'package:cached_network_image/cached_network_image.dart';
import 'package:face/constants/colors.dart';
import 'package:face/constants/helpers.dart';
import 'package:face/features/user/cubit/get/getuser_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  bool isPasswordVisible = false;

  @override
  void initState() {
    context.read<GetuserCubit>().getUser(context);
    super.initState();
  }

  Future<void> _refresh() async {
    context.read<GetuserCubit>().getUser(context);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppStyles.oq,
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppStyles.myColor),
        backgroundColor: AppStyles.oq,
        elevation: 0,
        title:  Text(
          'My account',
          style: GoogleFonts.exo2(color: AppStyles.myColor, fontSize: 18,
            fontWeight: FontWeight.bold,),
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        backgroundColor: AppStyles.oq,
        color: AppStyles.myColor,
        onRefresh: () => _refresh(),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: BlocBuilder<GetuserCubit, GetuserState>(
            builder: (context, state) {
              return state.when(
                initial: () => const Text("Welcome! Please fetch your data."),
                loading: () => const Center(
                    // child: const CircularProgressIndicator(
                    //   color: Colors.teal,
                    // ),
                    ),
                success: (getuser) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: screenWidth * 0.13,
                        backgroundColor: Colors.greenAccent.withOpacity(0.2),
                        child: getuser.image.isEmpty
                            ? Icon(
                                FontAwesomeIcons.user,
                                size: screenWidth * 0.13,
                                color: AppStyles.myColor
                              )
                            : ClipOval(
                                child: CachedNetworkImage(
                                  imageUrl: getuser.image,
                                  placeholder: (context, url) =>
                                      const CircularProgressIndicator(
                                    color: AppStyles.myColor
                                  ),
                                  errorWidget: (context, url, error) => Icon(
                                    FontAwesomeIcons.user,
                                    size: screenWidth * 0.13,
                                    color: AppStyles.myColor
                                  ),
                                  fit: BoxFit.cover,
                                  width: screenWidth * 0.26,
                                  // Diameter of the CircleAvatar
                                  height: screenWidth * 0.26,
                                ),
                              ),
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 5,
                        shadowColor: AppStyles.myColor.withOpacity(0.3),
                        color: Colors.white,
                        child: Padding(
                          padding: EdgeInsets.all(screenWidth * 0.05),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildInfoRow(
                                icon: FontAwesomeIcons.userTie,
                                label: 'Full Name',
                                value: getuser.name, // Display user's name
                                iconSize: screenWidth * 0.06,
                              ),
                              _buildInfoRow(
                                icon: FontAwesomeIcons.phone,
                                label: 'Phone Number',
                                value: getuser.phone, // Display user's phone
                                iconSize: screenWidth * 0.06,
                              ),
                              _buildInfoRow(
                                icon: FontAwesomeIcons.envelopeCircleCheck,
                                label: 'Email',
                                value: getuser.email, // Display user's email
                                iconSize: screenWidth * 0.06,
                              ),
                              _buildInfoRow(
                                icon: FontAwesomeIcons.lock,
                                label: 'Password',
                                value: isPasswordVisible
                                    ? getuser.password
                                    : '••••••••',
                                // Use user password only for demonstration
                                iconSize: screenWidth * 0.06,
                                trailing: IconButton(
                                  icon: Icon(
                                    isPasswordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: AppStyles.myColor,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      isPasswordVisible = !isPasswordVisible;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.1),
                      ElevatedButton(
                        onPressed: () {
                          _showLogoutDialog(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppStyles.myColor,
                          padding: EdgeInsets.symmetric(
                            vertical: screenHeight * 0.02,
                            horizontal: screenWidth * 0.3,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child:  Text(
                          'Logout',
                          style: GoogleFonts.exo2(fontSize: 16, color: Colors.white,fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  );
                },
                failure: (error) => Center(
                    child: Text("Error: $error",)), // Display error message
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    required double iconSize,
    Widget? trailing,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: AppStyles.myColor, size: iconSize),
          SizedBox(width: iconSize * 0.7),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style:   GoogleFonts.exo2(fontSize: 12, color: Colors.black54),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style:   GoogleFonts.exo2(
                      fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          if (trailing != null) trailing,
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppStyles.oq,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          titlePadding: EdgeInsets.zero,
          title: Column(
            children: [
              Column(
                children: [
                  const SizedBox(height: 10),
                  Text(
                    "Confirm Logout",
                    style: GoogleFonts.exo2(
                      fontSize: screenWidth * 0.05,
                      fontWeight: FontWeight.bold,
                      color: AppStyles.myColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
          content: Padding(
            padding: EdgeInsets.all(screenWidth * 0.05),
            child:  Text(
              "Are you sure you want to log out?",
              textAlign: TextAlign.center,
              style: GoogleFonts.exo2(
                fontWeight: FontWeight.bold,
                color: AppStyles.myColor,
              ),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                      backgroundColor: Colors.blue.shade100,
                      foregroundColor: AppStyles.myColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child:  Text("Cancel",  style: GoogleFonts.exo2(
                      fontWeight: FontWeight.bold,
                      color: AppStyles.myColor,
                    ),),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Helpers.removeToken(context);
                    },
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                      backgroundColor: AppStyles.myColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child:  Text("Logout",  style: GoogleFonts.exo2(
                      fontWeight: FontWeight.bold,
                      color: AppStyles.oq,
                    )),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
