import 'package:face/constants/colors.dart';
import 'package:face/constants/helpers.dart';
import 'package:face/features/bottomnavigationbar/presentation/widgets.dart';
import 'package:face/features/camera/presentation/screens/camera.dart';
import 'package:face/features/home/home.dart';
import 'package:face/features/user/screens/user.dart';

// import 'package:face/features/user/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../cubit/responsive_navigation_bar/responsive_navigation_bar_cubit.dart';
import '../cubit/responsive_navigation_bar/responsive_navigation_bar_state.dart';

class MyBottomNavigationBar extends StatelessWidget {
  const MyBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return BlocBuilder<ResponsiveNavigationBarCubit,
        ResponsiveNavigationBarState>(builder: (context, state) {
      return Scaffold(
        backgroundColor: AppStyles.oq,
        resizeToAvoidBottomInset: false,
        body: Center(
          child: IndexedStack(
            index: state.currentIndex,
            children: [
              MainPage(),
              const UserPage(),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: AppStyles.oq,
            boxShadow: [
              BoxShadow(
                color: Colors.teal.withOpacity(0.2),
                blurRadius: 10, // Spread radius
                offset: const Offset(0, -4), // Position of the shadow
              ),
            ],
          ),
          height: 80,
          child: BottomNavigationBar(
            onTap: (value) {
              context.read<ResponsiveNavigationBarCubit>().changeIndex(value);
            },
            iconSize: 25,
            type: BottomNavigationBarType.fixed,
            backgroundColor: AppStyles.oq,
            selectedItemColor: AppStyles.myColor,
            unselectedItemColor: AppStyles.icon_colors1,
            unselectedLabelStyle: GoogleFonts.exo2(fontSize: 12),
            selectedLabelStyle: GoogleFonts.exo2(fontSize: 12),
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.userTie),
                label: 'Candidate',
              ),
              BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.cog),
                label: 'Settings',
              ),
            ],
            currentIndex: state.currentIndex,
          ),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) {
                    return CameraPage(); // Destination page
                  },
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    // Custom transition animation
                    const begin =
                        Offset(0.0, 1.0); // Start from bottom (y-axis)
                    const end = Offset.zero; // End at center
                    const curve = Curves.easeInOut;

                    var tween = Tween(begin: begin, end: end)
                        .chain(CurveTween(curve: curve));
                    var offsetAnimation = animation.drive(tween);

                    return SlideTransition(
                        position: offsetAnimation, child: child);
                  },
                ),
              );
            },
            backgroundColor: AppStyles.myColor,
            child:  Image(
              width: screenWidth * 0.1,
              height: screenHeight * 0.1,
              image: AssetImage("assets/facedid/scan.png"),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      );
    });
  }
}
