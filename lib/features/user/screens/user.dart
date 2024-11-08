import 'package:cached_network_image/cached_network_image.dart';
import 'package:face/constants/colors.dart';
import 'package:face/constants/helpers.dart';
import 'package:face/features/user/cubit/get/getuser_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
    await Future.wait([
      context.read<GetuserCubit>().getUser(context),
    ]);
    await Future.delayed(Duration(milliseconds: 5));
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppStyles.oq,
      appBar: AppBar(
        backgroundColor: AppStyles.oq,
        elevation: 0,
        title: const Text(
          'My account',
          style: TextStyle(color: Colors.teal, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        backgroundColor: AppStyles.oq,
        color: Colors.teal,
        onRefresh: () => _refresh(),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: BlocBuilder<GetuserCubit, GetuserState>(
            builder: (context, state) {
              return state.when(
                initial: () => Text("Welcome! Please fetch your data."),
                loading: () => Center(
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
                                color: Colors.teal,
                              )
                            : ClipOval(
                                child: CachedNetworkImage(
                                  imageUrl: getuser.image,
                                  placeholder: (context, url) =>
                                      const CircularProgressIndicator(
                                    color: Colors.teal,
                                  ),
                                  errorWidget: (context, url, error) => Icon(
                                    FontAwesomeIcons.user,
                                    size: screenWidth * 0.13,
                                    color: Colors.teal,
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
                        shadowColor: Colors.tealAccent.withOpacity(0.3),
                        color: Colors.white,
                        child: Padding(
                          padding: EdgeInsets.all(screenWidth * 0.05),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildInfoRow(
                                icon: FontAwesomeIcons.user,
                                label: 'Full Name',
                                value: getuser.name, // Display user's name
                                iconSize: screenWidth * 0.06,
                              ),
                              _buildInfoRow(
                                icon: FontAwesomeIcons.envelope,
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
                                    color: Colors.teal,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      isPasswordVisible = !isPasswordVisible;
                                    });
                                  },
                                ),
                              ),
                              _buildInfoRow(
                                icon: FontAwesomeIcons.phone,
                                label: 'Phone Number',
                                value: getuser.phone, // Display user's phone
                                iconSize: screenWidth * 0.06,
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
                          backgroundColor: Colors.teal,
                          padding: EdgeInsets.symmetric(
                            vertical: screenHeight * 0.02,
                            horizontal: screenWidth * 0.3,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: const Text(
                          'Logout',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ],
                  );
                },
                failure: (error) => Center(
                    child: Text("Error: $error")), // Display error message
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
          Icon(icon, color: Colors.teal, size: iconSize),
          SizedBox(width: iconSize * 0.7),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          titlePadding: EdgeInsets.zero,
          title: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.teal.shade100,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(20)),
                ),
                padding: EdgeInsets.all(screenWidth * 0.05),
                child: Column(
                  children: [
                    Icon(
                      Icons.logout,
                      color: Colors.teal.shade700,
                      size: screenWidth * 0.15,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Confirm Logout",
                      style: TextStyle(
                        fontSize: screenWidth * 0.05,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal.shade800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          content: Padding(
            padding: EdgeInsets.all(screenWidth * 0.05),
            child: Text(
              "Are you sure you want to log out?",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: screenWidth * 0.04,
                color: Colors.grey.shade700,
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
                      backgroundColor: Colors.teal.shade100,
                      foregroundColor: Colors.teal.shade800,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text("Cancel"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Helpers.removeToken(context);
                    },
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                      backgroundColor: Colors.teal.shade700,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text("Logout"),
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
