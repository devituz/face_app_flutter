import 'dart:io';
import 'package:camera/camera.dart';
import 'package:face/features/display/display.dart';
import 'package:face/main2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:face/features/camera/presentation/cubit/post_cubit.dart';
import 'dart:math';

List<CameraDescription> cameras = [];
CameraController? _controller;

class CameraPage extends StatefulWidget {
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late Future<void> _initializeControllerFuture;
  int selectedCameraIdx = 0;
  bool isFlashOn = false;
  XFile? capturedImage;

  final double previewSize = 300; // Define a fixed size for the camera preview

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    _controller = CameraController(
      cameras[selectedCameraIdx],
      ResolutionPreset.high,
    );
    _initializeControllerFuture = _controller!.initialize();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    try {
      await _initializeControllerFuture; // Ensure the camera is initialized
      capturedImage = await _controller!.takePicture(); // Capture image

      // Upload the image using PostCubit
      File imageFile = File(capturedImage!.path);
      context.read<PostCubit>().postcamera(
            file: imageFile,
            context: context,
          );
    } catch (e) {
      print(e); // Handle any errors
    }
  }

  Future<void> _toggleFlash() async {
    isFlashOn = !isFlashOn; // Toggle flash state
    await _controller!.setFlashMode(
      isFlashOn ? FlashMode.torch : FlashMode.off,
    );
    setState(() {}); // Update UI
  }

  Future<void> _switchCamera() async {
    selectedCameraIdx =
        (selectedCameraIdx + 1) % cameras.length; // Switch camera
    await _initializeCamera();
    setState(() {}); // Update UI
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.teal),
        centerTitle: true,
        backgroundColor: Colors.white,
        title: const Text(
          'Face recognition',
          style: TextStyle(color: Colors.teal),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: FutureBuilder<void>(
          future: _initializeControllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Stack(
                children: [
                  Positioned(
                    bottom: MediaQuery.of(context).size.height * 0.75, // Ekran balandligining 10% o'rnida joylashadi
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Builder(
                        builder: (context) {
                          // MediaQuery yordamida ekran kengligi va balandligiga qarab matn o'lchamini belgilash
                          double screenWidth = MediaQuery.of(context).size.width;

                          return Text(
                            'Please look at the camera! Come closer. Keep your face within the circle and stay still!',
                            style: TextStyle(
                              fontSize: screenWidth < 600 ? 14 : 16, // Ekran kengligi 600px dan kichik bo'lsa font o'lchamini 14 qilish
                              color: Colors.red,
                            ),
                            textAlign: TextAlign.center,
                          );
                        },
                      ),
                    ),
                  ),
                  Padding(

                    padding: EdgeInsets.only(bottom: 150),
                    child: ClipPath(
                      clipper: CircleClipper(),
                      child: Transform(
                        alignment: Alignment.center,
                        transform: selectedCameraIdx ==
                                1 // Assuming index 1 is the front camera
                            ? Matrix4.rotationY(3.14159) // Flip for front camera
                            : Matrix4.identity(),
                        // No transformation for back camera
                        child: CameraPreview(
                          _controller!,
                        ),
                      ),
                    ),
                  ),
                  // Overlay widgets (like buttons)




                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.72, // 72% from top (adjust as needed)
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Flash Button
                          Container(
                            width: MediaQuery.of(context).size.width * 0.15, // Button width relative to screen width
                            height: MediaQuery.of(context).size.width * 0.15, // Button height relative to screen width
                            decoration: BoxDecoration(
                              color: Colors.teal,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.teal.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                              shape: BoxShape.circle, // Ensures the container is circular like the button
                            ),
                            child: FloatingActionButton(
                              heroTag: 'flash',
                              backgroundColor: Colors.teal,
                              onPressed: _toggleFlash,
                              child: Icon(
                                isFlashOn ? Icons.flash_on : Icons.flash_off,
                                color: Colors.white,
                              ),
                            ),
                          ),

                          // Capture Button
                          Container(
                            width: MediaQuery.of(context).size.width * 0.15, // Button width relative to screen width
                            height: MediaQuery.of(context).size.width * 0.15, // Button height relative to screen width
                            decoration: BoxDecoration(
                              color: Colors.teal,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.teal.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                              shape: BoxShape.circle, // Ensures the container is circular like the button
                            ),
                            child: FloatingActionButton(
                              heroTag: 'capture',
                              backgroundColor: Colors.teal,
                              onPressed: _takePicture,
                              child: const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                              ),
                            ),
                          ),

                          // Switch Button
                          Container(
                            width: MediaQuery.of(context).size.width * 0.15, // Button width relative to screen width
                            height: MediaQuery.of(context).size.width * 0.15, // Button height relative to screen width
                            decoration: BoxDecoration(
                              color: Colors.teal,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.teal.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                              shape: BoxShape.circle, // Ensures the container is circular like the button
                            ),
                            child: FloatingActionButton(
                              heroTag: 'switch',
                              backgroundColor: Colors.teal,
                              onPressed: _switchCamera,
                              child: const Icon(
                                Icons.switch_camera,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Add other widgets or BlocConsumer as needed
                  // BlocConsumer for loading and success/error states
                  BlocConsumer<PostCubit, PostState>(
                    listener: (context, state) {
                      state.maybeWhen(
                        success: (name, file) {
                          // Navigate to image display page
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ImageDisplayPage(name: name, file: file),
                            ),
                          );
                        },
                        error: (message) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.red,
                              duration: const Duration(seconds: 3),
                              behavior: SnackBarBehavior.floating,
                              margin: const EdgeInsets.all(16),
                              content: Text(
                                message,
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          );
                        },
                        orElse: () {},
                      );
                    },
                    builder: (context, state) {
                      return state.maybeWhen(
                        loading: () {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoadingScreen(),
                              ),
                            );
                          });
                          return const SizedBox
                              .shrink(); // Do not show anything while loading
                        },
                        orElse: () =>
                            const SizedBox.shrink(), // No loading state
                      );
                    },
                  ),
                ],
              );
            } else {
              return const Center(
                  child: CircularProgressIndicator(
                color: Colors.teal,
              ));
            }
          },
        ),
      ),
    );
  }
}

// Loading screen widget
class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          color: Colors.teal,
        ),
      ),
    );
  }
}
