import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:first_app/screens/mat.dart';
import 'package:first_app/screens/translate.dart';
import 'package:first_app/widgets/mybutton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
//import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';

import '../screens/2.dart';
import '../screens/3.dart';
import '../screens/5.dart';
import '../screens/wait.dart';

class p3 extends StatefulWidget {
  final String lang;
  final String phone;

  const p3({required this.lang, required this.phone, Key? key}) : super(key: key);

  @override
  State<p3> createState() => _p3State();
}

class _p3State extends State<p3> {
  final FlutterLocalization localization = FlutterLocalization.instance;
  String? local;
  String? siteText;
  String? siteNom;
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
// mybutton({required this.color,required this.title,required this.onPressed});
// final Color color;
// final String title;
// final VoidCallback onPressed;
  String? a;
  bool isvisible = false;
  DateTime? selectedDate;
  final List<String> _checked = [];
  List<String> itemList = ["Item 1", "Item 2", "Item 3"]; // قائمة العناصر

  final bool _showCalendar = false;

  List<String> itemlist = [
    "Ajouter une autre heur",
    "ن",
    "dhd",
    "sdfifjsf",
    "fshwc"
  ];

  String? selecteditem = "Ajouter une autre heur";
  DateTime? d = DateTime.now();
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
  String? sitePhoto;

  File? file;
  var imagepicker = ImagePicker();
  bool visible = true;
  bool vi = false;
  bool vm = true;
  bool viii = true;

  bool vbn = false;
  int? numberOfDocuments;
  DocumentReference? newDoc;
  bool vis = false;

  int? nombrePhoto;

  String? siteID;

  List<String> deleteds = [];

  int? Document;

  String? siteCode;
  String? texller;
  Position? currentPosition;

  @override
  Widget build(BuildContext context) {
    TextEditingController textController = TextEditingController();
    String? selectedit= localization.currentLocale!=null?localization.currentLocale!.languageCode:widget.lang;
    List<String> itelistm=["ar","en","fr"];

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 212, 203, 158),
      appBar: AppBar(
        actions: [Row(
                children: [
                  SizedBox(
                    width: 70,
                    child: DropdownButtonFormField<String>(
                                                    // decoration: const InputDecoration(
                                                    //   //border: InputBorder.none,
                                                    //   enabledBorder: OutlineInputBorder(
                                                    //       borderSide: BorderSide(color: Colors.green)),
                                                    //   focusedBorder: OutlineInputBorder(
                                                    //       borderSide: BorderSide(color: Colors.blue)),
                                                    // ),
                                                    value: selectedit,
                                                    items: itelistm
                                                        .map((item) => DropdownMenuItem(
                                                            value: item,
                                                            child: Center(
                                                              child: Text(
                                                                item,
                                                              ),
                                                            )))
                                                        .toList(),
                                                    onChanged: (item) => setState(() {
                                                          selectedit = "$item";
                                                          localization.translate('$selectedit');
                                                        })),
                  ),
                  const Icon(Icons.language,color: Colors.black,),
                  SizedBox(width: 20,)
                ],
              ),
              SizedBox(width: 180,),
          IconButton(
              onPressed: () async {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title:  Text(AppLocale.Signout.getString(context)),
                      content:  Text(AppLocale.SignoutText.getString(context)),
                      actions: [
                        TextButton(
                          onPressed: () async {
                            await _auth.signOut();
                            Navigator.pushNamed(context, S.screenRoute);
                            // تنفيذ الإجراء الخاص بالخيار الأول
                            //Navigator.pop(context);
                          },
                          child:  Text(AppLocale.yes.getString(context)),
                        ),
                        TextButton(
                          onPressed: () {
                            // تنفيذ الإجراء الخاص بالخيار الثاني
                            Navigator.pop(context);
                          },
                          child:  Text(AppLocale.cancel.getString(context)),
                        ),
                      ],
                    );
                  },
                );
              },
              icon: const Icon(Icons.logout))
        ],
        backgroundColor: const Color.fromARGB(255, 172, 154, 100),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                const SizedBox(
                  width: 30,
                ),
                InkWell(
                  child: Container(
                      width: 300,
                      decoration: const BoxDecoration(
                          border: Border(
                              top: BorderSide(
                                  color: Color.fromARGB(255, 172, 154, 100)),
                              right: BorderSide(
                                  color: Color.fromARGB(255, 172, 154, 100)),
                              left: BorderSide(
                                  color: Color.fromARGB(255, 172, 154, 100)))),
                      child: Row(
                        children: [
                           Container(
                            width: 240,
                             child: Text(
                              AppLocale.at.getString(context),
                              style: TextStyle(fontSize: 24),
                                                     ),
                           ),
                          const SizedBox(
                            width: 30,
                          ),
                          Icon(vm ? Icons.arrow_right : Icons.arrow_drop_down)
                        ],
                      )),
                  onTap: () {
                    setState(() {
                      vm = !vm;
                    });
                  },
                ),
              ],
            ),
            //             Visibility(
            //                 visible: vm,
            //                 child: Padding(
            //                     padding: const EdgeInsets.symmetric(vertical: 10),
            //                     child: SingleChildScrollView(
            //                         child: Column(children: [
            //                       StreamBuilder<QuerySnapshot>(
            //                           stream: _firestore.collection("matches").snapshots(),
            //                           builder: (context, snapshot) {
            //                             List mesMatches = [];
            //                             List<Widget> w = [];
            //                             if (snapshot.hasData) {
            //                               final documents = snapshot.data!.docs;
            //                               for (var element in documents) {
            //                                 if (element.id.contains(widget.phone)) {
            //                                   final tt = element.data() as Map;
            //                                   for (var i = 1; i <= tt.length; i++) {
            //                                     mesMatches.add({
            //                                       "date": tt["match$i"]["date"],
            //                                       "info": [
            //                                         {
            //                                           "nbst": element.id
            //                                               .replaceAll(widget.phone, "")
            //                                               .replaceAll("@oussama.com", "")
            //                                               .replaceAll(",", ""),
            //                                           "heur": tt["match$i"]["heur"]
            //                                         }
            //                                       ]
            //                                     });
            //                                   }
            //                                 }
            //                               }
            //                               int cb = mesMatches.length;
            //                               for (var i = 0; i < cb; i++) {
            //                                 for (var j = i + 1; j < cb; j++) {
            //                                   if (mesMatches[i]["date"] ==
            //                                       mesMatches[j]["date"]) {
            //                                     for (var nm in mesMatches[j]["info"]) {
            //                                       mesMatches[i]["info"].add(nm);
            //                                     }
            //                                     mesMatches.remove(mesMatches[j]);
            //                                     cb = cb - 1;
            //                                   }
            //                                 }
            //                               }
            //                             }
            //                             for (var mma in mesMatches) {
            //                               w.add(Column(
            //                                 children: [
            //                                   const SizedBox(
            //                                     height: 10,
            //                                   ),
            //                                   Center(
            //                                     child: Text("Date: ${mma["date"]}"),
            //                                   ),
            //                                   const SizedBox(
            //                                     height: 10,
            //                                   ),
            //                                   Container(
            //                                       width: 350,
            //                                       height: 20.0 + mma["info"].length * 70.0,
            //                                       decoration: BoxDecoration(
            //                                           borderRadius:
            //                                               BorderRadius.circular(40),
            //                                           border:
            //                                               Border.all(color: Colors.black)),
            //                                       child: SingleChildScrollView(
            //                                         child: Column(
            //                                           children: [
            //                                             const SizedBox(
            //                                               height: 20,
            //                                             ),
            //                                             const Row(
            //                                               children: [
            //                                                 SizedBox(
            //                                                   width: 60,
            //                                                 ),
            //                                                 Text("HEUR"),
            //                                                 SizedBox(
            //                                                   width: 140,
            //                                                 ),
            //                                                 Text("SITE"),
            //                                               ],
            //                                             ),
            //                                             //SizedBox(height: 100,),
            //                                             ListView.builder(
            //                                               shrinkWrap: true,
            //                                               itemCount: mma["info"].length,
            //                                               itemBuilder:
            //                                                   (BuildContext context,
            //                                                       int index) {
            //                                                 return SingleChildScrollView(
            //                                                   child:
            //                                                       // Column(
            //                                                       //     children: [
            //                                                       ListTile(
            //                                                           title: SizedBox(
            //                                                             width: 10,
            //                                                             child: Text(
            //                                                                 "${mma["info"][index]["heur"]}h:00mn"),
            //                                                           ),
            //                                                           trailing: StreamBuilder<
            //                                                                   QuerySnapshot>(
            //                                                               stream: _firestore
            //                                                                   .collection(
            //                                                                       "site")
            //                                                                   .snapshots(),
            //                                                               builder: (context,
            //                                                                   snapshot) {
            //                                                                 String? nmm;
            //                                                                 String? nmmid;
            //                                                                 if (snapshot
            //                                                                     .hasData) {
            //                                                                   final documents =
            //                                                                       snapshot
            //                                                                           .data!
            //                                                                           .docs;
            //                                                                   for (var element
            //                                                                       in documents) {
            //                                                                     if (element
            //                                                                             .id ==
            //                                                                         mma["info"][index]
            //                                                                             [
            //                                                                             "nbst"]) {
            //                                                                       nmm = element
            //                                                                           .get(
            //                                                                               "nom");
            //                                                                       nmmid =
            //                                                                           element
            //                                                                               .id;
            //                                                                     }
            //                                                                   }
            //                                                                 }
            //                                                                 return Container(
            //                                                                     decoration:
            //                                                                         BoxDecoration(
            //                                                                       border: Border.all(
            //                                                                           color:
            //                                                                               Colors.blue),
            //                                                                       borderRadius:
            //                                                                           BorderRadius.circular(
            //                                                                               15),
            //                                                                     ),
            //                                                                     width: 150,
            //                                                                     height: 30,
            //                                                                     child: Center(
            //                                                                         child: InkWell(
            //                                                                             onTap: () async {
            //                                                                               await Navigator.push(
            //                                                                                 context,
            //                                                                                 MaterialPageRoute(builder: (context) => accueil(siteCode: "$nmmid")),
            //                                                                               );
            //                                                                             },
            //                                                                             child: Text("$nmm"))));
            //                                                               }),
            //                                                           leading: IconButton(
            //                                                               onPressed:
            //                                                                   () async {
            //                                                                 showDialog(
            //                                                                   context:
            //                                                                       context,
            //                                                                   builder:
            //                                                                       (BuildContext
            //                                                                           context) {
            //                                                                     return AlertDialog(
            //                                                                       title: const Text(
            //                                                                           'حذف'),
            //                                                                       content:
            //                                                                           const Text(
            //                                                                               'هل تريد بالتأكيد حذف المبارات ؟'),
            //                                                                       actions: <Widget>[
            //                                                                         TextButton(
            //                                                                           onPressed:
            //                                                                               () {
            //                                                                             Navigator.of(context).pop(false);
            //                                                                           },
            //                                                                           child:
            //                                                                               const Text('لا'),
            //                                                                         ),
            //                                                                         TextButton(
            //                                                                           onPressed:
            //                                                                               () {
            //                                                                             Navigator.of(context).pop(true);
            //                                                                           },
            //                                                                           child:
            //                                                                               const Text('نعم'),
            //                                                                         ),
            //                                                                       ],
            //                                                                     );
            //                                                                   },
            //                                                                 ).then(
            //                                                                     (value) async {
            //                                                                   if (value) {
            //                                                                     if (snapshot
            //                                                                         .hasData) {
            //                                                                       final documents = snapshot
            //                                                                           .data!
            //                                                                           .docs;
            //                                                                       for (var element
            //                                                                           in documents) {
            //                                                                         if (element
            //                                                                             .id
            //                                                                             .contains("${mma["info"][index]["nbst"]},${widget.phone}")) {
            //                                                                           final dt =
            //                                                                               element.data() as Map;
            //                                                                           final dtt =
            //                                                                               dt.length;
            //                                                                           for (var i = 1;
            //                                                                               i <= dtt;
            //                                                                               i++) {
            //                                                                             if (dt["match$i"]["date"] == mma["date"] &&
            //                                                                                 dt["match$i"]["heur"] == mma["info"][index]["heur"]) {
            //                                                                               for (var j = i; j < dtt; j++) {
            //                                                                                 _firestore.collection("matches").doc(element.id).update({
            //                                                                                   "match$j": dt["match${j + 1}"]
            //                                                                                 });
            //                                                                               }
            //                                                                               _firestore.collection("matches").doc(element.id).update({
            //                                                                                 "match$dtt": FieldValue.delete()
            //                                                                               });
            //                                                                             }
            //                                                                           }
            //                                                                         }
            //                                                                       }
            //                                                                     }
            //                                                                   }
            //                                                                 });
            //                                                                 //if (snap.hasdata) {

            //                                                                 //}
            //                                                               },
            //                                                               icon: const Icon(
            //                                                                   Icons
            //                                                                       .delete))),
            //                                                 );
            //                                                 //     ],
            //                                                 //   ),
            //                                               },
            //                                             ),
            //                                           ],
            //                                         ),
            //                                       )),
            //                                 ],
            //                               ));
            //                             }
            //                             return Column(
            //                               children: w,
            //                             );
            //                           })
            //                     ])))),
            //             const SizedBox(
            //               height: 10,
            //             ),
            //             Row(
            //               children: [
            //                 const SizedBox(
            //                   width: 30,
            //                 ),
            //                 InkWell(
            //                   child: Container(
            //                     width: 300,
            //                     decoration: const BoxDecoration(
            //                         border: Border(
            //                             top: BorderSide(
            //                                 color: Color.fromARGB(255, 172, 154, 100)),
            //                             right: BorderSide(
            //                                 color: Color.fromARGB(255, 172, 154, 100)),
            //                             left: BorderSide(
            //                                 color: Color.fromARGB(255, 172, 154, 100)),
            //                             bottom: BorderSide(
            //                                 color: Color.fromARGB(255, 212, 203, 158)))),
            //                     child: Row(
            //                       children: [
            //                         const Text(
            //                           "Mes Sites",
            //                           style: TextStyle(fontSize: 24),
            //                         ),
            //                         const SizedBox(
            //                           width: 160,
            //                         ),
            //                         Icon(
            //                           vi ? Icons.arrow_right : Icons.arrow_drop_down,
            //                         )
            //                       ],
            //                     ),
            //                   ),
            //                   onTap: () {
            //                     setState(() {
            //                       vi = !vi;
            //                     });
            //                   },
            //                 ),
            //               ],
            //             ),
            // Visibility(
            //         visible: vi:false,
            //                   child: Padding(
            //                       padding: const EdgeInsets.symmetric(vertical: 10),
            //                       child: SingleChildScrollView(
            //                           child: Column(children: [
            //                         // const SizedBox(
            //                         //   height: 100,
            //                         // ),
            //                         StreamBuilder<QuerySnapshot>(
            //                             stream: _firestore.collection("Users").snapshots(),
            //                             builder: (context, snapshot) {
            //                               List<Widget> Widgets = [];
            //                               if (snapshot.hasData) {
            //                                 final documents = snapshot.data!.docs;
            //                                 for (var element in documents) {
            //                                   if (element.id == widget.phone) {
            //                                     //for (var i = 0; i <= 5; i++) {
            //                                     var dt = element.data() as Map<String, dynamic>;
            //                                     var data = dt.containsKey("sites")
            //                                         ? element.get("sites")
            //                                         : null;
            //                                     // var Site = data.containsKey("site$i")
            //                                     //     ? element.get("site$i")
            //                                     //     : null;
            //                                     if (data != [] && data != null) {
            //                                       for (var i in data) {
            //                                         Widgets.add(StreamBuilder<QuerySnapshot>(
            //                                             stream: _firestore
            //                                                 .collection("site")
            //                                                 .snapshots(),
            //                                             builder: (context, snapshot) {
            //                                               List<Widget> wid = [];
            //                                               if (snapshot.hasData) {
            //                                                 final docu = snapshot.data!.docs;
            //                                                 for (var element in docu) {
            //                                                   if (element.id == i) {
            //                                                     var dttt = element.data() as Map<String, dynamic>;
            //                                                     var photos=dttt.containsKey("photos")? element.get("photos"):null;
            //                                                       var src =photos!=null && photos!=[]?photos[0]:null;
            //                                                       print(src);
            //                                                       if (src != null ) {
            //                                                         wid.add(
            //                                                           Container(
            //                                                             width: 300,
            //                                                             decoration:
            //                                                                 BoxDecoration(
            //                                                                     border:
            //                                                                         Border.all(
            //                                                                       color: Colors
            //                                                                           .black,
            //                                                                     ),
            //                                                                     borderRadius:
            //                                                                         BorderRadius
            //                                                                             .circular(
            //                                                                                 10)),
            //                                                             child: Center(
            //                                                                 child: Column(
            //                                                               children: [
            //                                                                 SizedBox(
            //                                                                   width: double
            //                                                                       .infinity,
            //                                                                   height: 100,
            //                                                                   child: ClipRRect(
            //                                                                     borderRadius:
            //                                                                         BorderRadius
            //                                                                             .circular(
            //                                                                                 10),
            //                                                                     child:
            //                                                                         FadeInImage(
            //                                                                       placeholder:
            //                                                                           const AssetImage(
            //                                                                               'images/logo.png'), // صورة الاحتياطية التي تظهر أثناء تحميل الصورة
            //                                                                       image:
            //                                                                           NetworkImage(
            //                                                                               src),
            //                                                                       height: 200,
            //                                                                       width: 300,
            //                                                                       fit: BoxFit
            //                                                                           .cover, // رابط الصورة الفعلية
            //                                                                       // طريقة تغيير حجم الصورة لتناسب العنصر الذي يحتويه
            //                                                                     ),
            //                                                                   ),
            //                                                                 ),
            //                                                                 SizedBox(
            //                                                                   width: 300,
            //                                                                   child: Row(
            //                                                                     children: [
            //                                                                       Padding(
            //                                                                         padding:
            //                                                                             const EdgeInsets.all(
            //                                                                                 8.0),
            //                                                                         child:
            //                                                                             Container(
            //                                                                           width:
            //                                                                               133,
            //                                                                           decoration: BoxDecoration(
            //                                                                               color: const Color.fromARGB(
            //                                                                                   255,
            //                                                                                   79,
            //                                                                                   162,
            //                                                                                   230),
            //                                                                               borderRadius:
            //                                                                                   BorderRadius.circular(8)),
            //                                                                           // decoration: BoxDecoration(border: backgroundc),
            //                                                                           child: IconButton(
            //                                                                               // color: Colors.black,
            //                                                                               onPressed: () async {
            //                                                                                 await Navigator.push(
            //                                                                                   context,
            //                                                                                   MaterialPageRoute(
            //                                                                                       builder: (context) => mod(
            //                                                                                             siteCode: element.id,
            //                                                                                             phone: widget.phone,
            //                                                                                           )),
            //                                                                                 );
            //                                                                               },
            //                                                                               icon: const Icon(color: Color.fromARGB(255, 53, 48, 32), Icons.edit)),
            //                                                                         ),
            //                                                                       ),
            //                                                                       // SizedBox(
            //                                                                       //   width: 170,
            //                                                                       // ),
            //                                                                       Padding(
            //                                                                         padding:
            //                                                                             const EdgeInsets.all(
            //                                                                                 8.0),
            //                                                                         child:
            //                                                                             Container(
            //                                                                           width:
            //                                                                               133,
            //                                                                           decoration: BoxDecoration(
            //                                                                               color: const Color.fromARGB(
            //                                                                                   255,
            //                                                                                   184,
            //                                                                                   158,
            //                                                                                   82),
            //                                                                               borderRadius:
            //                                                                                   BorderRadius.circular(8)),
            //                                                                           child: IconButton(
            //                                                                               onPressed: () async {
            //                                                                                 await Navigator.push(
            //                                                                                   context,
            //                                                                                   MaterialPageRoute(
            //                                                                                       builder: (context) => mod2(
            //                                                                                             siteCode: element.id,
            //                                                                                             phone: widget.phone,
            //                                                                                           )),
            //                                                                                 );
            //                                                                               },
            //                                                                               icon: const Icon(color: Color.fromARGB(255, 53, 48, 32), Icons.score)),
            //                                                                         ),
            //                                                                       ),
            //                                                                     ],
            //                                                                   ),
            //                                                                 )
            //                                                               ],
            //                                                             )),
            //                                                           ),
            //                                                         );
            //                                                         wid.add(const SizedBox(
            //                                                           height: 20,
            //                                                         ));
            //                                                       }
            //                                                     }
            //                                                 }
            //                                               }
            //                                               return Column(
            //                                                 children: wid,
            //                                               );
            //                                             }));
            //                                       }
            //                                     }
            //                                   }
            //                                 }
            //                               }
            //                               return Column(
            //                                 children: Widgets,
            //                               );
            //                             }),
            //                         StreamBuilder<QuerySnapshot>(
            //                             stream: _firestore.collection("at").snapshots(),
            //                             builder: (context, snapshot) {
            //                               List<Widget> widgetss = [];
            //                               if (snapshot.hasData) {
            //                                 final du = snapshot.data!.docs;

            //                                 for (var element in du) {
            //                                   var data=element.data() as Map;
            //                                   if (data.containsKey("USER") && element.get("USER") == widget.phone) {
            //                                     //var va=element.data() as Map;
            //                                     List photos = element.get("photos");
            //                                     print(photos);
            //                                     if (photos.isNotEmpty) {
            //                                       widgetss.add(Container(
            //                                           width: 300,
            //                                           decoration: BoxDecoration(
            //                                               border: Border.all(
            //                                                 color: Colors.black,
            //                                               ),
            //                                               borderRadius:
            //                                                   BorderRadius.circular(10)),
            //                                           child: Center(
            //                                               child: Column(children: [
            //                                             SizedBox(
            //                                               width: double.infinity,
            //                                               height: 100,
            //                                               child: ClipRRect(
            //                                                 borderRadius:
            //                                                     BorderRadius.circular(10),
            //                                                 child: FadeInImage(
            //                                                   placeholder: const AssetImage(
            //                                                       'images/logo.png'), // صورة الاحتياطية التي تظهر أثناء تحميل الصورة
            //                                                   image: NetworkImage(photos[0]),
            //                                                   height: 200,
            //                                                   width: 300,
            //                                                   fit: BoxFit
            //                                                       .cover, // رابط الصورة الفعلية
            //                                                   // طريقة تغيير حجم الصورة لتناسب العنصر الذي يحتويه
            //                                                 ),
            //                                               ),
            //                                             ),
            //                                             const Center(
            //                                               child: Text(
            //                                                   "في انتظار المصادقة من قبل إدارة التطبيق "),
            //                                             ),
            //                                             SizedBox(
            //                                                                   width: 300,
            //                                                                   child:Padding(
            //                                                                         padding:
            //                                                                             const EdgeInsets.all(
            //                                                                                 8.0),
            //                                                                         child:
            //                                                                             Container(
            //                                                                           width:
            //                                                                               133,
            //                                                                           decoration: BoxDecoration(
            //                                                                               color: const Color.fromARGB(
            //                                                                                   255,
            //                                                                                   79,
            //                                                                                   162,
            //                                                                                   230),
            //                                                                               borderRadius:
            //                                                                                   BorderRadius.circular(8)),
            //                                                                           // decoration: BoxDecoration(border: backgroundc),
            //                                                                           child: IconButton(
            //                                                                               // color: Colors.black,
            //                                                                               onPressed: () async {
            //                                                                                 await Navigator.push(
            //                                                                                   context,
            //                                                                                   MaterialPageRoute(
            //                                                                                       builder: (context) => mod3(
            //                                                                                             siteCode: element.id,
            //                                                                                             phone: widget.phone,
            //                                                                                           )),
            //                                                                                 );
            //                                                                               },
            //                                                                               icon: const Icon(color: Color.fromARGB(255, 53, 48, 32), Icons.edit)),
            //                                                                         ),
            //                                                                       ),
            //                                                                       // SizedBox(
            //                                                                       //   width: 170,
            //                                                                       // ),

            //                                                                 )
            //                                           ]))));
            //                                     } else {
            //                                       widgetss.add(Container(
            //                                           width: 300,
            //                                           decoration: BoxDecoration(
            //                                               border: Border.all(
            //                                                 color: Colors.black,
            //                                               ),
            //                                               borderRadius:
            //                                                   BorderRadius.circular(10)),
            //                                           child: Center(
            //                                               child: Column(children: [
            //                                             SizedBox(
            //                                               width: double.infinity,
            //                                               height: 100,
            //                                               child: ClipRRect(
            //                                                 borderRadius:
            //                                                     BorderRadius.circular(10),
            //                                                 child: const FadeInImage(
            //                                                   placeholder: AssetImage(
            //                                                       'images/logo.png'), // صورة الاحتياطية التي تظهر أثناء تحميل الصورة
            //                                                   image:
            //                                                       AssetImage('images/logo.png'),
            //                                                   height: 200,
            //                                                   width: 300,
            //                                                   fit: BoxFit
            //                                                       .cover, // رابط الصورة الفعلية
            //                                                   // طريقة تغيير حجم الصورة لتناسب العنصر الذي يحتويه
            //                                                 ),
            //                                               ),
            //                                             ),
            //                                             const Center(
            //                                               child: Text(
            //                                                   "في انتظار المصادقة من قبل إدارة التطبيق "),
            //                                             ),
            //                                             SizedBox(
            //                                                                   width: 300,
            //                                                                   child: Padding(
            //                                                                         padding:
            //                                                                             const EdgeInsets.all(
            //                                                                                 8.0),
            //                                                                         child:
            //                                                                             Container(
            //                                                                           width:
            //                                                                               133,
            //                                                                           decoration: BoxDecoration(
            //                                                                               color: const Color.fromARGB(
            //                                                                                   255,
            //                                                                                   79,
            //                                                                                   162,
            //                                                                                   230),
            //                                                                               borderRadius:
            //                                                                                   BorderRadius.circular(8)),
            //                                                                           // decoration: BoxDecoration(border: backgroundc),
            //                                                                           child: IconButton(
            //                                                                               // color: Colors.black,
            //                                                                               onPressed: () async {
            //                                                                                 await Navigator.push(
            //                                                                                   context,
            //                                                                                   MaterialPageRoute(
            //                                                                                       builder: (context) => mod3(
            //                                                                                             siteCode: element.id,
            //                                                                                             phone: widget.phone,
            //                                                                                           )),
            //                                                                                 );
            //                                                                               },
            //                                                                               icon: const Icon(color: Color.fromARGB(255, 53, 48, 32), Icons.edit)),
            //                                                                         ),
            //                                                                       ),
            //                                                                       // SizedBox(
            //                                                                       //   width: 170,
            //                                                                       // ),

            //                                                                 )
            //                                           ]))));
            //                                     }
            //                                   }
            //                                 }
            //                               }
            //                               widgetss.add(const SizedBox(
            //                                 height: 10,
            //                               ));
            //                               return Column(
            //                                 children: widgetss,
            //                               );
            //                             }),

            //                         const SizedBox(
            //                           height: 10,
            //                         ),
            //                         Visibility(
            //                           visible: visible,
            //                           child: Center(
            //                             child: InkWell(
            //                               child: Container(
            //                                 width: 300,
            //                                 height: 100,
            //                                 decoration: BoxDecoration(
            //                                     border: Border.all(
            //                                       color:
            //                                           const Color.fromARGB(255, 172, 154, 100),
            //                                     ),
            //                                     borderRadius: BorderRadius.circular(100)),
            //                                 child: ClipRRect(
            //                                   borderRadius: BorderRadius.circular(100),
            //                                   child: Image.asset(
            //                                       width: 300,
            //                                       height: 100,
            //                                       "images/download.png",
            //                                       fit: BoxFit.cover),
            //                                 ),
            //                               ),
            //                               onTap: () async {
            //                                 CollectionReference usersCollection =
            //                                     _firestore.collection("at");
            //                                 QuerySnapshot snapshot =
            //                                     await usersCollection.get();
            //                                 numberOfDocuments = snapshot.size;
            //                                 List<DocumentSnapshot> documents = snapshot.docs;
            //                                 final L = [];
            //                                 for (var doc in documents) {
            //                                   L.add(doc.id);
            //                                 }
            //                                 for (var i = 1; i < numberOfDocuments! + 2; i++) {
            //                                   if (!L.contains(i.toString())) {
            //                                     print(i);
            //                                     Document = i;
            //                                     break;
            //                                   }
            //                                 }

            //                                 await _firestore
            //                                     .collection("at")
            //                                     .doc("$Document")
            //                                     .set({"photos": []});

            //                                 nombrePhoto = 0;
            //                                 _checked.clear();
            //                                 // newDoc!.set({"photos": []});
            //                                 for (var i = 0; i < 24; i++) {
            //                                   _checkedItems[i] = false;
            //                                 }
            //                                 // setState(() {
            //                                 // _textController.text =  texller != null ? "$texller" : "";

            //                                 // });
            //                                 // siteText=null;
            //                                 // siteNom=null;
            //                                 // local=null;
            //                                 setState(() {
            //                                   visible = !visible;
            //                                 });
            //                               },
            //                             ),
            //                           ),
            //                         ),
            //                         Visibility(
            //                             visible: !visible,
            //                             child: Center(
            //                               child: Container(
            //                                   width: 300,
            //                                   decoration: BoxDecoration(
            //                                       border: Border.all(
            //                                         color: const Color.fromARGB(
            //                                             255, 172, 154, 100),
            //                                       ),
            //                                       borderRadius: BorderRadius.circular(10)),
            //                                   child: SingleChildScrollView(
            //                                     child: Column(children: [
            //                                       const SizedBox(
            //                                         height: 10,
            //                                       ),
            //                                       Container(
            //                                         width: 200,
            //                                         decoration: BoxDecoration(
            //                                             borderRadius: BorderRadius.circular(8),
            //                                             border:
            //                                                 Border.all(color: Colors.black)),
            //                                         child: TextField(
            //                                           onChanged: (value) {
            //                                             setState(() {
            //                                             siteNom = value;
            //                                             });
            //                                           },
            //                                           keyboardType: TextInputType.multiline,
            //                                           maxLines: null,
            //                                           textAlign: TextAlign.center,
            //                                           style: const TextStyle(
            //                                             fontSize: 18,
            //                                           ),
            //                                           decoration: const InputDecoration(
            //                                             hintText: 'Nom du site',
            //                                           ),
            //                                           textAlignVertical:
            //                                               TextAlignVertical.center,
            //                                         ),
            //                                       ),
            //                                       StreamBuilder<QuerySnapshot>(
            //                                           stream: _firestore
            //                                               .collection('at')
            //                                               .snapshots(),
            //                                           builder: (context, snapshot) {
            //                                             List<Widget> messageWidgets = [];
            //                                             List<String> indexs = [];
            //                                             if (snapshot.hasData) {
            //                                               final messages = snapshot.data!.docs;
            //                                               for (var element in messages) {
            //                                                 if (element.id == "$Document") {
            //                                                   var photos =
            //                                                       element.get("photos");
            //                                                   if (photos != null &&
            //                                                       photos != []) {
            //                                                     for (var photo in photos) {
            //                                                       final Widget messageWidget =
            //                                                           Padding(
            //                                                         padding:
            //                                                             const EdgeInsets.all(
            //                                                                 8.0),
            //                                                         child: Column(
            //                                                           children: [
            //                                                             IconButton(
            //                                                                 onPressed:
            //                                                                     () async {
            //                                                                   await deletephoto(
            //                                                                       "$Document",
            //                                                                       photo);
            //                                                                   print(deleteds);
            //                                                                 },
            //                                                                 icon: const Icon(
            //                                                                     Icons.delete)),
            //                                                             Image.network(
            //                                                               photo,
            //                                                               height: 100,
            //                                                               fit: BoxFit.cover,
            //                                                             ),
            //                                                           ],
            //                                                         ),
            //                                                       );
            //                                                       messageWidgets
            //                                                           .add(messageWidget);
            //                                                     }
            //                                                   }
            //                                                 }
            //                                               }
            //                                             }
            //                                             return Row(
            //                                               children: messageWidgets,
            //                                             );
            //                                           }),
            //                                       mybutton(
            //                                           color: Colors.black,
            //                                           title: "ajouter une photo",
            //                                           onPressed: () async {
            //                                             if (nombrePhoto! < 4) {
            //                                               await _requestPermissioncamera();
            //                                             }
            //                                           }),
            //                                       const SizedBox(height: 10),
            //                                       Container(
            //                                         width: 200,
            //                                         decoration: BoxDecoration(
            //                                             borderRadius: BorderRadius.circular(8),
            //                                             border:
            //                                                 Border.all(color: Colors.black)),
            //                                         child: TextField(
            //                                           onChanged: (value) {
            //                                             setState(() {
            //                                             siteText =value;
            //                                             });
            //                                           },
            //                                           keyboardType: TextInputType.multiline,
            //                                           maxLines: null,
            //                                           textAlign: TextAlign.center,
            //                                           style: const TextStyle(
            //                                             fontSize: 18,
            //                                           ),
            //                                           decoration: const InputDecoration(
            //                                             hintText: 'Entrez votre texte ici',
            //                                           ),
            //                                           textAlignVertical:
            //                                               TextAlignVertical.center,
            //                                         ),
            //                                       ),
            //                                       const SizedBox(height: 10),
            //                                       const Text(
            //                                         "Localisation",
            //                                         style: TextStyle(fontSize: 30),
            //                                       ),
            //                                       Container(
            //                                         width: 250,
            //                                         decoration: BoxDecoration(
            //                                             borderRadius: BorderRadius.circular(8),
            //                                             border:
            //                                                 Border.all(color: Colors.black)),
            //                                         child: TextField(
            //                                           // controller: _textController,
            //                                           onChanged: (value) {
            //                                             setState(() {
            //                                               // _textController.text=value;
            //                                               local = value;
            //                                             });
            //                                           },
            //                                           // keyboardType: TextInputType.multiline,
            //                                           // maxLines: null,
            //                                           textAlign: TextAlign.center,
            //                                           style: const TextStyle(
            //                                             fontSize: 18,
            //                                           ),
            //                                           decoration: const InputDecoration(
            //                                               hintText:
            //                                                   'جاري تسجيل الموقع الحالي....',
            //                                               fillColor: Colors.black),
            //                                           textAlignVertical:
            //                                               TextAlignVertical.center,
            //                                         ),
            //                                       ),
            //                                       const SizedBox(
            //                                         height: 20,
            //                                       ),
            //                                       ElevatedButton(
            //                                         onPressed: () async {
            //                                           setState(() {
            //                                             isvisible = !isvisible;
            //                                           });
            //                                         },
            //                                         child:
            //                                             const Text("Ajouter des heurs d'arrêt"),
            //                                       ),
            //                                       const SizedBox(height: 10),
            //                                       Visibility(
            //                                         visible: isvisible,
            //                                         child: Column(
            //                                           children: [
            //                                             const Text("Les heurs d'arrêt"),
            //                                             Padding(
            //                                               padding: const EdgeInsets.all(8.0),
            //                                               child: Container(
            //                                                 decoration: BoxDecoration(
            //                                                     border: Border.all(
            //                                                         color: Colors.red)),
            //                                                 height: isvisible ? 200 : 0,
            //                                                 child: ListView.builder(
            //                                                   itemCount: _items.length,
            //                                                   itemBuilder:
            //                                                       (BuildContext context,
            //                                                           int index) {
            //                                                     return CheckboxListTile(
            //                                                       title: Text(_items[index]),
            //                                                       value: _checkedItems[index],
            //                                                       onChanged: (bool? value) {
            //                                                         setState(() {
            //                                                           _checkedItems[index] =
            //                                                               value!;
            //                                                           if (value == true) {
            //                                                             _checked
            //                                                                 .add(_items[index]);
            //                                                             _firestore
            //                                                                 .collection('at')
            //                                                                 .doc("$Document")
            //                                                                 .update({
            //                                                               "Stop": _checked
            //                                                             });
            //                                                           } else {
            //                                                             _checked.remove(
            //                                                                 _items[index]);
            //                                                             _firestore
            //                                                                 .collection('at')
            //                                                                 .doc("$Document")
            //                                                                 .update({
            //                                                               "Stop": _checked
            //                                                             });
            //                                                           }
            //                                                         });
            //                                                       },
            //                                                     );
            //                                                   },
            //                                                 ),
            //                                               ),
            //                                             ),
            //                                           ],
            //                                         ),
            //                                       ),
            //                                       Padding(
            //                                         padding: const EdgeInsets.symmetric(
            //                                             horizontal: 30),
            //                                         child: Row(
            //                                           children: [
            //                                             Padding(
            //                                               padding: const EdgeInsets.all(8.0),
            //                                               child: mybutton(
            //                                                   color: const Color.fromARGB(
            //                                                       255, 155, 79, 74),
            //                                                   title: "Cancel",
            //                                                   onPressed: () async {
            //                                                     _firestore
            //                                                         .collection("at")
            //                                                         .doc("$Document")
            //                                                         .delete();
            //                                                     setState(() {
            //                                                       visible = !visible;
            //                                                       isvisible = false;
            //                                                     });
            //                                                   } //, icon: const Icon(Icons.cancel)
            //                                                   ),
            //                                             ),
            //                                             Padding(
            //                                               padding: const EdgeInsets.all(8.0),
            //                                               child: mybutton(
            //                                                   color: const Color.fromARGB(
            //                                                       255, 146, 211, 148),
            //                                                   title: "OK",
            //                                                   onPressed: () async {
            //                                                     _firestore
            //                                                         .collection("at")
            //                                                         .doc("$Document")
            //                                                         .update({
            //                                                       "nom": siteNom,
            //                                                       "Text": siteText,
            //                                                       "USER": widget.phone
            //                                                     });
            //                                                     if (local == null) {
            //                                                       await _requestPermission(
            //                                                           "$Document");
            //                                                       setState(() {
            //                                                         local = null;
            //                                                       });
            //                                                     } else {
            //                                                       await _firestore
            //                                                           .collection("at")
            //                                                           .doc("$Document")
            //                                                           .update({"local": local});
            //                                                       setState(() {
            //                                                         local = null;
            //                                                       });
            //                                                     }
            //                                                     setState(() {
            //                                                       visible = !visible;
            //                                                       isvisible = false;
            //                                                     });
            //                                                     // }
            //                                                   }),
            //                                             )
            //                                           ],
            //                                         ),
            //                                       )
            //                                     ]),
            //                                   )),
            //                             ))
            //                       ]))),
            //                 ),
            Visibility(
              visible: vm,
              child: StreamBuilder<QuerySnapshot>(
                  stream: _firestore.collection("at").snapshots(),
                  builder: (context, sot) {
                    List<Widget> widgetss = [];
                    if (sot.hasData) {
                      final du = sot.data!.docs;
                      for (var element in du) {
                        List photos = element.get("photos");
                        if (photos.isNotEmpty) {
                          widgetss.add(Container(
                              width: 300,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black,
                                  ),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Center(
                                  child: Column(children: [
                                SizedBox(
                                  width: double.infinity,
                                  height: 100,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: FadeInImage(
                                      placeholder: const AssetImage(
                                          'images/logo.png'), // صورة الاحتياطية التي تظهر أثناء تحميل الصورة
                                      image: NetworkImage(photos[0]),
                                      height: 200,
                                      width: 300,
                                      fit: BoxFit.cover, // رابط الصورة الفعلية
                                      // طريقة تغيير حجم الصورة لتناسب العنصر الذي يحتويه
                                    ),
                                  ),
                                ),
                                 Center(
                                  child: Text(
                                      AppLocale.waiting.getString(context)),
                                ),
                                SizedBox(
                                  width: 300,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 133,
                                          decoration: BoxDecoration(
                                              color: const Color.fromARGB(
                                                  255, 79, 162, 230),
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                          // decoration: BoxDecoration(border: backgroundc),
                                          child: IconButton(
                                              // color: Colors.black,
                                              onPressed: () async {
                                                await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          mod3(
                                                            siteCode:
                                                                element.id,
                                                            phone: widget.phone,
                                                            v: false,
                                                          )),
                                                );
                                              },
                                              icon: const Icon(
                                                  color: Color.fromARGB(
                                                      255, 53, 48, 32),
                                                  Icons.edit)),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Container(
                                          width: 133,
                                          decoration: BoxDecoration(
                                              color: const Color.fromARGB(
                                                  255, 79, 162, 230),
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                          // decoration: BoxDecoration(border: backgroundc),
                                          child: IconButton(
                                              onPressed: () async {
                                                var dataaa = element.data()
                                                    as Map<String, dynamic>;
                                                CollectionReference
                                                    usersCollection = _firestore
                                                        .collection("site");
                                                QuerySnapshot snapshot =
                                                    await usersCollection.get();
                                                List<DocumentSnapshot> documents = snapshot.docs;
                                                var siz=snapshot.size;
                                    final L = [];
                                    for (var doc in documents) {
                                      L.add(doc.id);
                                    }
                                    var nvdoc;
                                    for (var i = 1; i < siz + 2; i++) {
                                      if (!L.contains(i.toString())) {
                                        nvdoc = i;
                                        break;
                                      }
                                    }

                                                await _firestore
                                                    .collection("site")
                                                    .doc(
                                                        "$nvdoc")
                                                    .set(dataaa);
                                                 CollectionReference userection =
                                        _firestore.collection("Users");
                                    QuerySnapshot snahot =
                                        await userection.get();
                                    List<DocumentSnapshot> docunts = snahot.docs;
                                    for (var dooc in docunts) {
                                      if (dooc.id==element.get("USER")) {
                                        List sites = dooc.get("sites") as List;
                                        sites.add("$nvdoc");
                                        await _firestore.collection("Users").doc(dooc.id).update({"sites":sites});
                                      }
                                    }
                                    _firestore.collection("at").doc(element.id).delete();
                                    
                                              },
                                              icon: const Icon(
                                                  color: Color.fromARGB(
                                                      255, 10, 241, 110),
                                                  Icons.check)),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // SizedBox(
                                  //   width: 170,
                                  // ),
                                )
                              ]))));
                        } else {
                          widgetss.add(Container(
                              width: 300,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black,
                                  ),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Center(
                                  child: Column(children: [
                                SizedBox(
                                  width: double.infinity,
                                  height: 100,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: const FadeInImage(
                                      placeholder: AssetImage(
                                          'images/logo.png'), // صورة الاحتياطية التي تظهر أثناء تحميل الصورة
                                      image: AssetImage('images/logo.png'),
                                      height: 200,
                                      width: 300,
                                      fit: BoxFit.cover, // رابط الصورة الفعلية
                                      // طريقة تغيير حجم الصورة لتناسب العنصر الذي يحتويه
                                    ),
                                  ),
                                ),
                                 Center(
                                  child: Text(
                                      AppLocale.waiting.getString(context)),
                                ),
                                SizedBox(
                                  width: 300,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 133,
                                          decoration: BoxDecoration(
                                              color: const Color.fromARGB(
                                                  255, 79, 162, 230),
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                          // decoration: BoxDecoration(border: backgroundc),
                                          child: IconButton(
                                              // color: Colors.black,
                                              onPressed: () async {
                                                await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          mod3(
                                                            siteCode:
                                                                element.id,
                                                            phone: widget.phone,
                                                            v: false,
                                                          )),
                                                );
                                              },
                                              icon: const Icon(
                                                  color: Color.fromARGB(
                                                      255, 53, 48, 32),
                                                  Icons.edit)),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Container(
                                          width: 133,
                                          decoration: BoxDecoration(
                                              color: const Color.fromARGB(
                                                  255, 79, 162, 230),
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                          // decoration: BoxDecoration(border: backgroundc),
                                          child: IconButton(
                                              // color: Colors.black,
                                              onPressed: () async {
                                                
                                                var dataaa = element.data()
                                                    as Map<String, dynamic>;
                                                CollectionReference
                                                    usersCollection = _firestore
                                                        .collection("site");
                                                QuerySnapshot snapshot =
                                                    await usersCollection.get();
                                                List<DocumentSnapshot> documents = snapshot.docs;
                                                var siz=snapshot.size;
                                    final L = [];
                                    for (var doc in documents) {
                                      L.add(doc.id);
                                    }
                                    var nvdoc;
                                    for (var i = 1; i < siz + 2; i++) {
                                      if (!L.contains(i.toString())) {
                                        nvdoc = i;
                                        break;
                                      }
                                    }

                                                await _firestore
                                                    .collection("site")
                                                    .doc(
                                                        "$nvdoc")
                                                    .set(dataaa);

                                     _firestore.collection("at").doc(element.id).delete();
                                                 CollectionReference userection =
                                        _firestore.collection("Users");
                                    QuerySnapshot snahot =
                                        await userection.get();
                                    List<DocumentSnapshot> docunts = snahot.docs;
                                    for (var dooc in docunts) {
                                      if (dooc.id==element.get("USER")) {
                                       var eledata=element.data() as Map;
                                        List sites =eledata.containsKey("sites")? dooc.get("sites") as List:[];
                                        sites.add("$nvdoc");
                                        await _firestore.collection("Users").doc(dooc.id).update({"sites":sites});
                                      }
                                    }
                                    
                                              },
                                              icon: const Icon(
                                                  color: Color.fromARGB(
                                                      255, 10, 241, 110),
                                                  Icons.check)),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // SizedBox(
                                  //   width: 170,
                                  // ),
                                )
                              ]))));
                        }
                        // }
                      }
                    }
                    widgetss.add(const SizedBox(
                      height: 10,
                    ));
                    return Column(
                      children: widgetss,
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> deletephoto(String docID, String I) async {
    final messages = await _firestore.collection('at').doc(docID).get();
    var photo = messages.data() as Map;
    List photos = photo["photos"];
    photos.remove(I);
    await _firestore.collection('at').doc(docID).update({"photos": photos});
  }

  String getFormattedDate(DateTime dateTime) {
    final formatter = DateFormat('yyyy-MM-dd HH');
    return formatter.format(dateTime);
  }

  getLocation(String doc) async {
    String? texller;
    currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    texller =
        "${currentPosition?.latitude ?? ''},${currentPosition?.longitude ?? ''}";
    await _firestore.collection("at").doc(doc).update({"local": texller});
    print('Latitude: ${currentPosition?.latitude ?? 'a'}');
    print('Longitude: ${currentPosition?.longitude ?? 'a'}');
    //return texller;
  }

  Future<void> goto(dynamic Page) async {
    await Navigator.push(
      context as BuildContext,
      MaterialPageRoute(builder: (context) => Page),
    );
  }

  void uploadimages() async {
    var imgpicked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (imgpicked != null) {
      file = File(imgpicked.path);
      var nameimage = basename(imgpicked.path);
      var refstorage = FirebaseStorage.instance.ref("/images/$nameimage/");
      await refstorage.putFile(file!);
      var url = await refstorage.getDownloadURL();
      var sitePhoto = url;
      final messages = await _firestore.collection('at').doc("$Document").get();
      var photo = messages.data() as Map;
      print(photo.keys);
      List photos = photo["photos"];
      photos.add(sitePhoto);
      await _firestore
          .collection('at')
          .doc("$Document")
          .update({"photos": photos});
      nombrePhoto = photos.length;
    } else {
      print("please chose image ");
    }
  }

  // الدالة المسؤولة عن إضافة عنصر إلى القائمة
  void _addItem(String item) {
    setState(() {
      itemList.add(item); // إضافة العنصر إلى نهاية القائمة
    });
  }

  // الدالة المسؤولة عن حذف عنصر من القائمة
  void _deleteItem(int index) {
    setState(() {
      itemList.removeAt(index); // حذف العنصر بالفهرس المحدد
    });
  }

  Future<void> _requestPermission(String doc) async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
    ].request();
    if (statuses[Permission.location] == PermissionStatus.denied) {
      // لم يتم السماح للتطبيق بالوصول إلى الموقع
      // يمكن إظهار رسالة خطأ للمستخدم هنا.
    } else {
      getLocation(doc);
      //texller=getLocation();
      //await getLocation();
    }
    // السماح للتطبيق بالوصول إلى الموقع تم بنجاح
    // يمكن استخدام حزمة geolocator الآن للوصول إلى الموقع
  }

  Future<void> _requestPermissioncamera() async {
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
      uploadimages();
    } else {
// الوصول غير مسموح به
      print('الوصول غير مسموح للكاميرا و/أو الملفات');
    }
  }
}
