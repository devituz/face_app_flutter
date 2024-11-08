

import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:image/image.dart' as img;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  runApp(MyApp(cameras: cameras));
}

class MyApp extends StatelessWidget {
  final List<CameraDescription> cameras;

  MyApp({required this.cameras});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(cameras: cameras),
    );
  }
}

class HomePage extends StatefulWidget {
  final List<CameraDescription> cameras;

  HomePage({required this.cameras});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _imagePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home Page")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display the captured image in a circular shape if available
            if (_imagePath != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipOval(
                  child: Image.file(
                    File(_imagePath!),
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover, // Make sure the image fits within the circle
                  ),
                ),
              ),
            // Button to open CameraScreen
            ElevatedButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CameraScreen(cameras: widget.cameras),
                  ),
                );
                if (result != null) {
                  setState(() {
                    _imagePath = result;
                  });
                }
              },
              child: Text('Open Camera'),
            ),
          ],
        ),
      ),
    );
  }
}

class CameraScreen extends StatefulWidget {
  final List<CameraDescription> cameras;

  CameraScreen({required this.cameras});

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _cameraController;
  int _selectedCameraIndex = 1;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    _cameraController = CameraController(
      widget.cameras[_selectedCameraIndex],
      ResolutionPreset.high,
    );

    await _cameraController!.initialize();
    if (mounted) {
      setState(() {});
    }
  }

  void _toggleCamera() {
    _selectedCameraIndex = _selectedCameraIndex == 0 ? 1 : 0;
    _initializeCamera();
  }

  Future<void> _captureAndSaveImage() async {
    try {
      // Capture the image
      final image = await _cameraController!.takePicture();
      final directory = await getApplicationDocumentsDirectory();
      final imagePath = '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';

      // Load the image into memory using the `image` package
      final imageFile = File(image.path);
      final imageBytes = await imageFile.readAsBytes();
      final decodedImage = img.decodeImage(Uint8List.fromList(imageBytes));

      // Crop the image to a circle
      if (decodedImage != null) {
        final radius = (decodedImage.width < decodedImage.height
            ? decodedImage.width / 2
            : decodedImage.height / 2).toInt();  // Convert to int

        final croppedImage = img.copyCropCircle(decodedImage, radius: radius); // Corrected usage

        // Save the cropped image to a new file
        final newFilePath = '${directory.path}/cropped_${DateTime.now().millisecondsSinceEpoch}.jpg';
        final newFile = File(newFilePath)..writeAsBytesSync(img.encodeJpg(croppedImage));

        // Convert the image file to Uint8List
        final newImageBytes = await newFile.readAsBytes();

        // Save the cropped image to the gallery using photo_manager
        final result = await PhotoManager.editor.saveImage(
          newImageBytes, // Pass the image bytes
          filename: 'captured_image_${DateTime.now().millisecondsSinceEpoch}.jpg', // Corrected parameter
        );

        // After saving, return the image path back to the home page
        if (result != null) {
          Navigator.pop(context, newFilePath); // Return the path of the cropped image
        } else {
          print("Failed to save image to gallery.");
        }
      }
    } catch (e) {
      print('Error capturing image: $e');
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(title: Text("Camera Screen")),
      body: Stack(
        alignment: Alignment.center,
        children: [
          // Black background to cover areas outside the circular preview
          Container(color: Colors.black),

          // Circular camera preview
          ClipPath(
            clipper: CircleClipper(),
            child: Transform(
              alignment: Alignment.center,
              transform: _selectedCameraIndex == 1
                  ? Matrix4.rotationY(3.14159) // Horizontal flip for front camera
                  : Matrix4.identity(),
              child: CameraPreview(_cameraController!),
            ),
          ),

          // Capture button
          Positioned(
            bottom: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  onPressed: _captureAndSaveImage,  // Capture and save the image
                  child: Icon(Icons.camera),
                ),
                SizedBox(width: 20),
                FloatingActionButton(
                  onPressed: _toggleCamera,  // Toggle between front and back camera
                  child: Icon(Icons.switch_camera),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CircleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.addOval(Rect.fromCircle(
      center: Offset(size.width / 2, size.height / 2),
      radius: 150,
    ));
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
