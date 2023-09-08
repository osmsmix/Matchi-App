import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:io';


class CaptureImageScreen extends StatefulWidget {
  static const String screenRoute = 'capture';
  @override
  _CaptureImageScreenState createState() => _CaptureImageScreenState();
}

class _CaptureImageScreenState extends State<CaptureImageScreen> {
  late CameraController _cameraController;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();

    // استعادة قائمة الكاميرات المتاحة
    availableCameras().then((cameras) {
      // تعيين الكاميرا الخلفية ككاميرا افتراضية
      _cameraController = CameraController(cameras[0], ResolutionPreset.medium);
      _initializeControllerFuture = _cameraController.initialize();
    });
  }

  @override
  void dispose() {
    // تحرير موارد الكاميرا
    _cameraController.dispose();
    super.dispose();
  }

  Future<void> _captureImage() async {
    try {
      // انتظار استعداد الكاميرا
      await _initializeControllerFuture;

      // التقاط الصورة
      final XFile imageFile = await _cameraController.takePicture();

      // تحديد حجم الصورة
      final String imagePath = imageFile.path;
      final Image image = Image.file(File(imagePath), width: 300, height: 300);
      
      // استخدام الصورة بحجم محدد
      // يمكنك القيام بأي عملية أخرى مع الصورة هنا، مثل عرضها في واجهة المستخدم
    } catch (e) {
      print('Error capturing image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Capture Image')),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: AspectRatio(
                    aspectRatio: _cameraController.value.aspectRatio,
                    child: CameraPreview(_cameraController),
                  ),
                ),
                ElevatedButton(
                  onPressed: _captureImage,
                  child: Text('Capture Image'),
                ),
              ],
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
