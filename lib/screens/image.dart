import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;


class MyImageScreen extends StatelessWidget {
  static const String screenRoute='image';

  const MyImageScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Storage Image'),
      ),
      body: Center(
        child: FutureBuilder(
          future: getImageUrl(),  // استدعاء دالة للحصول على رابط التنزيل للصورة
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return const Text('حدث خطأ أثناء جلب الصورة');
              }
              return Image.network("${snapshot.data}");  // عرض الصورة باستخدام الرابط المستلم
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }

  Future<String?> getImageUrl() async {
    String imageFileName = 'gs://matchi-app-1502e.appspot.com/images/39448881-fa97-4368-a5f5-2512e78d06643946450314552002242.jpg';  // استبدل path/to/image.jpg بالمسار الفعلي للصورة

    try {
      // الحصول على رابط التنزيل للصورة من Firebase Storage
      final ref = firebase_storage.FirebaseStorage.instance.ref(imageFileName);
      final url = await ref.getDownloadURL();

      return url;
    } catch (e) {
      print('حدث خطأ: $e');
       return null;
    }
  }
}
