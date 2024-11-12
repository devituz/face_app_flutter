import 'package:cached_network_image/cached_network_image.dart';
import 'package:face/constants/helpers.dart';
import 'package:face/features/bottomnavigationbar/presentation/cubit/responsive_navigation_bar/responsive_navigation_bar_cubit.dart';
import 'package:face/features/camera/presentation/cubit/post_cubit.dart';
import 'package:face/features/camera/presentation/screens/camera.dart';
import 'package:face/features/home/cubit/getstudents/getmestudent_cubit.dart';
import 'package:face/features/home/home.dart';
import 'package:face/features/login/cubit/auth_cubit.dart';
import 'package:face/features/login/screens/login.dart';
import 'package:face/features/user/cubit/get/getuser_cubit.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'features/bottomnavigationbar/presentation/screens/bottomnavigationbar_screen.dart';


void main() async {
  CachedNetworkImage.logLevel = CacheManagerLogLevel.debug;
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras(); // Get available cameras


  runApp(MyApp());
  await dotenv.load(fileName: 'lib/constants/.env');
}

// Future<void> _requestPermissions() async {
//   await Permission.camera.request();
// }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => PostCubit()),
        BlocProvider(create: (context) => AuthCubit()),
        BlocProvider(create: (context) => ResponsiveNavigationBarCubit()),
        BlocProvider(create: (context) => GetuserCubit()),
        BlocProvider(create: (context) => GetmestudentCubit()),
        // Add more cubits as needed
      ],
      child: MaterialApp(
        title: 'Camera App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: InitialPage(),
      ),
    );
  }
}




class InitialPage extends StatefulWidget {
  const InitialPage({super.key});

  @override
  _InitialPageState createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  @override
  void initState() {
    super.initState();
    requestPermissions();
  }

  Future<void> requestPermissions() async {
    await [
      Permission.camera,
      Permission.storage,
      Permission.microphone,
    ].request();
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: Helpers.isAuthTokenAvailable(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData && snapshot.data == true) {
          return const MyBottomNavigationBar();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}


