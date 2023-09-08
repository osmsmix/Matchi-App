import 'dart:io';
//import 'dart:js_interop';
import 'package:first_app/screens/profil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:path/path.dart';
import 'package:first_app/widgets/mybutton.dart';
import 'package:flutter/material.dart';
//import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

 getData(String collection, String document,String aKey) async {
  DocumentReference documentRef = FirebaseFirestore.instance.collection(collection).doc(document);
  DocumentSnapshot snapshot = await documentRef.get();
  
  if (snapshot.exists) {
    // استرداد البيانات
    Map data = await snapshot.data() as Map;
    print(data["nom"]);
    return data[aKey];
  } else {
    print('الوثيقة غير موجودة.');
    return "";
  }
}
