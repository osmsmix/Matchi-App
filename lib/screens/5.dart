import 'dart:io';
//import 'dart:js_util';
import 'package:first_app/screens/profil.dart';
import 'package:first_app/screens/translate.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:path/path.dart';
import 'package:first_app/widgets/mybutton.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class mod extends StatefulWidget {
  static const String screenRoute = '5';
  final String siteCode;
  final String phone;

  const mod({required this.siteCode, required this.phone});

  @override
  State<mod> createState() => _modState();
}

class _modState extends State<mod> {
  final _firestore = FirebaseFirestore.instance;

  String? sitePhoto;
  String? siteText;
  late GeoPoint siteLocalisation;

  List<dynamic> itemList = []; // قائمة العناصر

  // الدالة المسؤولة عن حذف عنصر من القائمة
  Future<void> _deleteItem(int index, List itemList) async {
    setState(() async {
      itemList.removeAt(index); // حذف العنصر بالفهرس المحدد
      await _firestore
          .collection("site")
          .doc(widget.siteCode)
          .update({"Stop": itemList});
    });
  }

  // الدالة المسؤولة عن إضافة عنصر إلى القائمة
  Future<void> _addItem(String item, List itemList) async {
    setState(() async {
      itemList.add(item);
      await _firestore
          .collection("site")
          .doc(widget.siteCode)
          .update({"Stop": itemList});
      // إضافة العنصر إلى نهاية القائمة
    });
  }

  final _auth = FirebaseAuth.instance;
  late User signedInUser;

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        signedInUser = user;
        print(user);
      }
    } catch (e) {
      print(e);
    }
  }

  Widget buildSectionTitle(BuildContext context, String titleText) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      alignment: Alignment.topRight,
      child: Text(
        titleText,
        style: Theme.of(context).textTheme.headlineSmall,
      ),
    );
  }

  Widget buildListViewContainer(Widget child) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      height: 200,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: child,
    );
  }

  // Widget checkr(BuildContext context){
  final List<String> _items = [
    '0',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12',
    '13',
    '14',
    '15',
    '16',
    '17',
    '18',
    '19',
    '20',
    '21',
    '22',
    '23',
  ];

  final List<bool> _checkedItems = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
  ];




  final bool _showCalendar = false;
  List itemlist = [];
  String? selecteditem = "Ajouter une autre heur";
  DateTime? d = DateTime.now();

  Position? currentPosition;
  double? latitude;
  double? longitude;

  void getLocation() async {
    currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print('Latitude: ${currentPosition?.latitude ?? ''}');
    print('Longitude: ${currentPosition?.longitude ?? ''}');
  }

  String getFormattedDate(DateTime dateTime) {
    final formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(dateTime);
  }

  final _textController = TextEditingController(text: "اختر التاريخ");
  String a = "";

  @override
  void dispose() {
    // يجب تفريغ ال TextController بعد الانتهاء من استخدامه لتجنب تسرب الذاكرة
    _textController.dispose();
    super.dispose();
  }

  Future<void> _launchMaps(String local) async {
    // double lat = local.latitude;
    // double lng = local.longitude;
    String url = 'https://www.google.com/maps/search/?api=1&query=$local';
    final String encodedURL = Uri.encodeFull(url);
    if (await canLaunch(encodedURL)) {
      await launch(encodedURL);
    } else {
      print(encodedURL);
      throw 'Could not launch $url';
    }
  }

  final Set<Marker> _markers = {};
  LatLng? _selectedPosition;

  void _onMapCreated(GoogleMapController controller) {
    // Initialisation de la carte
  }

  void _onMarkerTapped(LatLng position) {
    // Mise à jour de la position sélectionnée
    setState(() {
      _selectedPosition = position;
    });
  }

  bool isvisible = false;
  DateTime? selectedDate;
  final List<String> _checked = [];
  File? file;
  var imagepicker = ImagePicker();

  Future<void> _requestPermissioncamera(String type,String document) async {
    PermissionStatus cameraStatus = await Permission.camera.status;
    PermissionStatus storageStatus = await Permission.storage.status;

    if (!cameraStatus.isGranted) {
// لم يتم منح إذن الوصول إلى الكاميرا
      PermissionStatus newCameraStatus = await Permission.camera.request();
      cameraStatus = newCameraStatus;
    }

    if (!storageStatus.isGranted) {
// لم يتم منح إذن الوصول إلى الملفات
      PermissionStatus newStorageStatus = await Permission.storage.request();
      storageStatus = newStorageStatus;
    }

// التحقق من حالة الإذن
    if (storageStatus.isGranted && storageStatus.isGranted) {
// تم منح الوصول بنجاح
      print('تم منح إذن الوصول للكاميرا والملفات');
      uploadimages(type,document);
    } else {
// الوصول غير مسموح به
      print('الوصول غير مسموح للكاميرا و/أو الملفات');
    }
  }

  void uploadimages(String type,String document) async {
    var imgpicked =type=='folder'? await ImagePicker().pickImage(source: ImageSource.gallery):await ImagePicker().pickImage(source: ImageSource.camera);
    if (imgpicked != null) {
      file = File(imgpicked.path);
      var nameimage = basename(imgpicked.path);
      var refstorage = FirebaseStorage.instance.ref().child("/images/$nameimage/");
      print(refstorage);
      await refstorage.putFile(file!);
      var url = await refstorage.getDownloadURL();
      var sitePhoto = url;
      final messages = await _firestore.collection('site').doc(document).get();
      var photo = messages.data() as Map;
      List photos = photo["photos"];
      photos.add(sitePhoto);
      await _firestore
          .collection('site')
          .doc(document)
          .update({"photos": photos});
          // await refstorage.delete();
          
    } else {
      print("please chose image ");
    }
  }

  Future<void> deletephoto(String docID, String I) async {
    final messages = await _firestore.collection('site').doc(docID).get();
    var photo = messages.data() as Map;
    List photos = photo["photos"];
    photos.remove(I);
    await _firestore.collection('site').doc(docID).update({"photos": photos});
    if (!photos.contains(I)) {
    String newI='';
    for (var i = 0; i < I.length-17; i++) {
      print(I.substring(i,i+17));
      if (I.substring(i,i+17)=='?alt=media&token=') {
        newI=I.substring(0,i);
        print(newI);
        break;
      }
    }
    if (newI!='') {
      final ref =  FirebaseStorage.instance.ref().child("/images/${newI.replaceAll('https://firebasestorage.googleapis.com/v0/b/matchi-app-1502e.appspot.com/o/images%2F', '')}/");
    await ref.delete();
    }
  }
  
  }

  TextEditingController _textEditingController = TextEditingController();
  TextEditingController _texteditingController = TextEditingController();
  var local;
  @override
  Widget build(BuildContext context) {
    _texteditingController.text = "";
    late String? item;
    return StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection("site").snapshots(),
        builder: (context, snapshot) {
          late Widget w;
          if (snapshot.hasData) {
            final documents = snapshot.data!.docs;
            for (var element in documents) {
              if (element.id == widget.siteCode) {
               var data = element.data() as Map<String, dynamic>;
                List images =data.containsKey("photos")?element.get("photos"):[];
                _textEditingController.text = data.containsKey("Text")? element.get("Text"):"";
                local=data.containsKey("local")?element.get("local"):null;
                  itemList =data.containsKey("Stop")? element.get("Stop"):[];
                  for (var i = 0; i < itemList.length; i++) {
                  for (var j = i+1; j < itemList.length; j++) {
                  if (int.tryParse(itemList[i])!> int.tryParse(itemList[j])! ) {
                    final nm=itemList[i];
                    itemList[i]=itemList[j];
                    itemList[j]=nm;
                  }
                }
              }

                w= Scaffold(
                    appBar: AppBar(
                      actions: [
                        StreamBuilder<QuerySnapshot>(
                            stream: _firestore.collection("Users").snapshots(),
                            builder: (context, snapshot) {
                              return IconButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text(AppLocale.deletesite.getString(context)),
                                          content: Text(AppLocale.deletesitetext.getString(context)),
                                          actions: [
                                            TextButton(
                                              onPressed: () async {
                                                if (snapshot.hasData) {
                                                  final documents =
                                                      snapshot.data!.docs;
                                                  // final size = documents.length;
                                                  // print(size);

                                                  for (var element
                                                      in documents) {
                                                    if (element.id ==
                                                        widget.phone) {
                                                      int? delet;
                                                      List sites=element.get("sites");
                                                      for (var i = 0;i < sites.length;i++) {
                                                        if (sites[i] ==widget.siteCode) {

                                                          sites.remove(sites[i]);


                                                          await _firestore
                                                            .collection("Users")
                                                            .doc(
                                                                "${widget.phone}")
                                                            .update({
                                                          "sites": sites});



                                                          await _firestore
                                                          .collection("site")
                                                          .doc(
                                                              "${widget.siteCode}")
                                                          .delete();
                                                         
                                                        }
                                                      }
                                                      
                                                      Navigator.pop(context);
                                                      Navigator.pop(context);
                                                      
                                                  
                                   
                                                    }
                                                  }
                                                }
                                              },
                                              child: Row(
                                                children: [
                                                  Icon(Icons.delete),
                                                  Text(AppLocale.delete.getString(context)),
                                                ],
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                // تنفيذ الإجراء الخاص بالخيار الثالث
                                                Navigator.pop(context);
                                              },
                                              child: Row(
                                                children: [
                                                  Icon(Icons.cancel),
                                                  Text(AppLocale.cancel.getString(context)),
                                                ],
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ));
                            })
                      ],
                      title: Text(data.containsKey("nom")? "${element.get("nom")}":""),
                    ),
                    backgroundColor: const Color.fromARGB(255, 212, 203, 158),
                    body: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(border:Border.all(color: Colors.black),borderRadius: BorderRadius.circular(15)),
                            child: SizedBox(
                              width: 310,
                              height: 350,
                              child: PageView.builder(
                                itemCount: images.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Column(
                                    children: [
                                      SizedBox(height: 20,),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: //Stack(children: [
                                          Image.network(
                                            images[index],
                                            height: 275,
                                            width: 150,
                                            fit: BoxFit.cover,
                                          ),
                                      ),
                                      Transform.scale(
                                        scale: 1.2,
                                        child: SizedBox(
                                          width: 150,
                                          child: Row(children: [
                                            IconButton(
                                              onPressed: () {
                                                // if (images.length <= 4) {
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        title: Text(AppLocale.editphoto.getString(context)),
                                                        content: Text(
                                                            AppLocale.whatdo.getString(context)),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () {
                                                              deletephoto(
                                                                  widget.siteCode,
                                                                  images[index]);
                                                              // تنفيذ الإجراء الخاص بالخيار الأول
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: Row(
                                                              children: [
                                                                Icon(
                                                                    Icons.delete),
                                                                Text(AppLocale.delete.getString(context)),
                                                              ],
                                                            ),
                                                          ),
                                                          TextButton(
                                                            onPressed: () {
                                                              // تنفيذ الإجراء الخاص بالخيار الثالث
                                                              Navigator.pop(
                                                                  context);
                                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        title: Text(AppLocale.editphoto.getString(context)),
                                                        content: Text(
                                                            AppLocale.whatdo.getString(context)),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () {
                                                              _requestPermissioncamera('folder',widget.siteCode);
                                                              // تنفيذ الإجراء الخاص بالخيار الأول
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: Row(
                                                              children: [
                                                                Icon(
                                                                    Icons.cloud_upload),
                                                                Text('import photo'),
                                                              ],
                                                            ),
                                                          ),
                                                          TextButton(
                                                            onPressed: () {
                                                              _requestPermissioncamera('camera',widget.siteCode);
                                                              // تنفيذ الإجراء الخاص بالخيار الثالث
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: Row(
                                                              children: [
                                                                Icon(Icons
                                                                    .add_a_photo),
                                                                Text(
                                                                    'take pucture'),
                                                              ],
                                                            ),
                                                          ),
                                                          TextButton(
                                                            onPressed: () {
                                                              // تنفيذ الإجراء الخاص بالخيار الأول
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: Row(
                                                              children: [
                                                                Icon(
                                                                    Icons.cancel),
                                                                Text(AppLocale.cancel.getString(context)),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                            },
                                                            child: Row(
                                                              children: [
                                                                Icon(Icons
                                                                    .add_a_photo),
                                                                Text(
                                                                    AppLocale.addnewp.getString(context)),
                                                              ],
                                                            ),
                                                          ),
                                                          TextButton(
                                                            onPressed: () {
                                                              // تنفيذ الإجراء الخاص بالخيار الأول
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: Row(
                                                              children: [
                                                                Icon(
                                                                    Icons.cancel),
                                                                Text(AppLocale.cancel.getString(context)),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                // } else {
                                                //   showDialog(
                                                //     context: context,
                                                //     builder:
                                                //         (BuildContext context) {
                                                //       return AlertDialog(
                                                //         title: Text('Edit photo'),
                                                //         content: Text(
                                                //             'What would you like to do?'),
                                                //         actions: [
                                                //           TextButton(
                                                //             onPressed: () {
                                                //               deletephoto(
                                                //                   widget.siteCode,
                                                //                   images[index]);
                                                //               // تنفيذ الإجراء الخاص بالخيار الأول
                                                //               Navigator.pop(
                                                //                   context);
                                                //             },
                                                //             child: Row(
                                                //               children: [
                                                //                 Icon(
                                                //                     Icons.delete),
                                                //                 Text('Delete'),
                                                //               ],
                                                //             ),
                                                //           ),
                                                //           Text(
                                                //               "you can't add a new photo because you have the maximum (5 photos)")
                                                //         ],
                                                //       );
                                                //     },
                                                //   );
                                                // }
                                              },
                                              icon: const Icon(Icons.edit),
                                            ),
                                            Text(AppLocale.editphoto.getString(context))
                                          ]),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),

                        
                          const SizedBox(height: 10),
                          Container(
                            decoration: BoxDecoration(border: Border.all(color: Colors.black), borderRadius: BorderRadius.circular(30)),
                            child: Column(
                            children: [
                              Icon(Icons.star,size: 100,),
                          Text(data.containsKey("love")? "${element.get("love").length}":""),
                            ],
                          )),
                          const SizedBox(height: 10),
                          TextField(
                            controller: _textEditingController,
                            onChanged: (value) {
                              siteText = value;
                            },
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                            decoration:  InputDecoration(
                              hintText: AppLocale.Entrezvotretexteici.getString(context),
                            ),
                            textAlignVertical: TextAlignVertical.center,
                          ),
                          mybutton(
                              color: Colors.black,
                              title: AppLocale.sync.getString(context),
                              onPressed: () async {
                                await _firestore
                                    .collection("site")
                                    .doc(widget.siteCode)
                                    .update({"Text": siteText});
                              }),
                          const SizedBox(height: 10),
                          Container(
                            width: 300,
                            //height: 200,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.grey[200],
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(1),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: InkWell(
                                child:  Row(
                                  children: [
                                    const Icon(Icons.map),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Text(AppLocale.localisation.getString(context),
                                      style: TextStyle(color: Colors.blue),
                                    )
                                  ],
                                ),
                                onTap: () async{ 
                                  await 
                                  _launchMaps(local);}),
                          ),
                          // Container(
                          //   child: GoogleMap(
                          //         onMapCreated: _onMapCreated,
                          //         initialCameraPosition: CameraPosition(
                          //           target: LatLng(48.8534, 2.3488),
                          //           zoom: 12,
                          //         ),
                          //         markers: _markers,
                          //         onTap: _onMarkerTapped,
                          //       ),

                          // ),

                          mybutton(
                              color: Colors.black,
                              title: AppLocale.mdl.getString(context),
                              onPressed: () {}),
                          const SizedBox(height: 10),
                         
                          const SizedBox(
                            height: 20,
                          ),
                          buildSectionTitle(context, AppLocale.temarret.getString(context)),
                          const SizedBox(height: 10),

                          // عرض القائمة باستخدام ListView.builder
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 240,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black)),
                              child:ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: itemList.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return SingleChildScrollView(
                                          child: Column(
                                            children: [
                                              ListTile(
                                                title: Text(itemList[index]),
                                                trailing: IconButton(
                                                  icon:
                                                      const Icon(Icons.delete),
                                                  onPressed: () async {
                                                    showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title:  Text(AppLocale.alert.getString(context)),
                                content:
                                Text(AppLocale.alerttext.getString(context)),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(false);
                                    },
                                    child:  Text(AppLocale.no.getString(context)),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(true);
                                    },
                                    child:  Text(AppLocale.yes.getString(context)),
                                  ),
                                ],
                              );
                            },
                          ).then((value) async {
                            if (value) {
                              await _deleteItem(
                                                        index, itemList);
                            }});
                                                    
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    )
                                  ),
                            ),
                          

                          SizedBox(
                            width: 100,
                            child: Center(
                              child: TextField(
                                controller: _texteditingController,
                                decoration: const InputDecoration(
                                  hintText: '',
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 10,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                ),
                                onChanged: (value) {
                                  item = value;
                                },
                              ),
                            ),
                          ),
                          ElevatedButton(
                              onPressed: () {showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title:  Text(AppLocale.alert.getString(context)),
                                content:
                                Text(AppLocale.alerttext.getString(context)),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(false);
                                    },
                                    child:  Text(AppLocale.no.getString(context)),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(true);
                                    },
                                    child:  Text(AppLocale.yes.getString(context)),
                                  ),
                                ],
                              );
                            },
                          ).then((value) async {
                            if (value) {
                              _addItem(item.toString(), itemList);
                              _texteditingController.text = "";
                            }});
                                
                              },
                              child: Icon(Icons.add)),
                          const SizedBox(height: 10),

                          // const SizedBox(height: 10),
                          // Visibility(
                          //   visible: isvisible,
                          //   child: Column(
                          //     children: [
                          //       Padding(
                          //         padding: const EdgeInsets.all(8.0),
                          //         child: Container(
                          //           decoration: BoxDecoration(
                          //               border: Border.all(color: Colors.red)),
                          //           height: isvisible ? 200 : 0,
                          //           child: ListView.builder(
                          //             itemCount: _items.length,
                          //             itemBuilder:
                          //                 (BuildContext context, int index) {
                          //               return CheckboxListTile(
                          //                 title: Text(_items[index]),
                          //                 value: _checkedItems[index],
                          //                 onChanged: (bool? value) {
                          //                   setState(() {
                          //                     _checkedItems[index] = value!;
                          //                     if (_checkedItems[index] ==
                          //                         true) {
                          //                       _checked.add(_items[index]);
                          //                     } else {
                          //                       _checked.remove(_items[index]);
                          //                     }
                          //                   });
                          //                 },
                          //               );
                          //             },
                          //           ),
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          const SizedBox(height: 150),
                        ],
                      ),
                    ));
              } 
              
            }
          }else{
            w=Text("");
          } 
          return w;
        });
  }
}
