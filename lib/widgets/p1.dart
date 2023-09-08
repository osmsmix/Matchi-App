import 'dart:io';
import 'dart:ui';

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

class p1 extends StatefulWidget {
  final String phone;
  final String lang;

  const p1({required this.lang, required this.phone, Key? key}) : super(key: key);

  @override
  State<p1> createState() => _p1State();
}

class _p1State extends State<p1> {
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
  
  // List<String> itemList = ["Item 1", "Item 2", "Item 3"]; 
  
  String? selectedite="";
  String? selecteditem = "";
  List<String> itelist=[""];
  List<String> itemlist = [""];

final bool _showCalendar = false;


  
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
  bool viii=true;
  bool v2=false;

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
    
    
    

    return StreamBuilder<QuerySnapshot>(
                              stream: _firestore.collection("employers").snapshots(),
                              builder: (context, snapshot) {
                                bool vep=false;
                                if (snapshot.hasData) {
                                  final documents = snapshot.data!.docs;
                                  List ids=[];
                                  for (var element in documents) {
                                    ids.add(element.id);
                                  }

                                if (!ids.contains(widget.phone)) {
                                  vep=true;
                                }}
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
                    Visibility(
                      visible: vep,
                      child: Visibility(
                        visible: v2,
                        child: Row(
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
                                          width: 150,
                                           child: Text(
                                            AppLocale.mesmatches.getString(context),
                                            style: TextStyle(fontSize: 24),
                                                                                 ),
                                         ),
                                        const SizedBox(
                                          width: 100,
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
                      ),
                      
                    ),
                    Visibility(
                      visible: vep,
                      child: Visibility(
                          visible: v2==false?!v2:vm,
                          child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: SingleChildScrollView(
                                  child: Column(children: [
                                StreamBuilder<QuerySnapshot>(
                                    stream: _firestore.collection("matches").snapshots(),
                                    builder: (context, snapshot) {
                                      List mesMatches = [];
                                      List<Widget> w = [];
                                      if (snapshot.hasData) {
                                        final documents = snapshot.data!.docs;
                                        for (var element in documents) {
                                          if (element.id.contains(widget.phone)) {
                                            final tt = element.data() as Map;
                                            for (var i = 1; i <= tt.length; i++) {
                                              mesMatches.add({
                                                "date": tt["match$i"]["date"],
                                                "info": [
                                                  {
                                                    "nbst": element.id
                                                        .replaceAll(widget.phone, "")
                                                        .replaceAll("@oussama.com", "")
                                                        .replaceAll(",", ""),
                                                    "heur": tt["match$i"]["heur"]
                                                  }
                                                ]
                                              });
                                            }
                                          }
                                        }
                                        int cb = mesMatches.length;
                                        for (var i = 0; i < cb; i++) {
                                          for (var j = i + 1; j < cb; j++) {
                                            if (mesMatches[i]["date"] ==
                                                mesMatches[j]["date"]) {
                                              for (var nm in mesMatches[j]["info"]) {
                                                mesMatches[i]["info"].add(nm);
                                              }
                                              mesMatches.remove(mesMatches[j]);
                                              cb = cb - 1;
                                            }
                                          }
                                        }
                                      }
                                      for (var mma in mesMatches) {
                                        w.add(Column(
                                          children: [
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Center(
                                              child: Text("${AppLocale.date.getString(context)}: ${mma["date"]}"),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                                width: 350,
                                                height: 20.0 + mma["info"].length * 75.0,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(40),
                                                    border:
                                                        Border.all(color: Colors.black)),
                                                child: SingleChildScrollView(
                                                  child: Column(
                                                    children: [
                                                      const SizedBox(
                                                        height: 20,
                                                      ),
                                                       Row(
                                                        children: [
                                                          SizedBox(
                                                            width: 60,
                                                          ),
                                                          Text(AppLocale.hour.getString(context)),
                                                          SizedBox(
                                                            width: 140,
                                                          ),
                                                          Text(AppLocale.site.getString(context)),
                                                        ],
                                                      ),
                                                      //SizedBox(height: 100,),
                                                      ListView.builder(
                                                        shrinkWrap: true,
                                                        itemCount: mma["info"].length,
                                                        itemBuilder:
                                                            (BuildContext context,
                                                                int index) {
                                                          return SingleChildScrollView(
                                                            child:
                                                                // Column(
                                                                //     children: [
                                                                ListTile(
                                                                    title: SizedBox(
                                                                      width: 10,
                                                                      child: Text(
                                                                          "${mma["info"][index]["heur"]}h:00mn"),
                                                                    ),
                                                                    trailing: StreamBuilder<
                                                                            QuerySnapshot>(
                                                                        stream: _firestore
                                                                            .collection(
                                                                                "site")
                                                                            .snapshots(),
                                                                        builder: (context,
                                                                            snapshot) {
                                                                          String? nmm;
                                                                          String? nmmid;
                                                                          if (snapshot
                                                                              .hasData) {
                                                                            final documents =
                                                                                snapshot
                                                                                    .data!
                                                                                    .docs;
                                                                            for (var element
                                                                                in documents) {
                                                                              if (element
                                                                                      .id ==
                                                                                  mma["info"][index]
                                                                                      [
                                                                                      "nbst"]) {
                                                                                nmm = element
                                                                                    .get(
                                                                                        "nom");
                                                                                nmmid =
                                                                                    element
                                                                                        .id;
                                                                              }
                                                                            }
                                                                          }
                                                                          return Container(
                                                                              decoration:
                                                                                  BoxDecoration(
                                                                                border: Border.all(
                                                                                    color:
                                                                                        Colors.blue),
                                                                                borderRadius:
                                                                                    BorderRadius.circular(
                                                                                        15),
                                                                              ),
                                                                              width: 150,
                                                                              height: 30,
                                                                              child: Center(
                                                                                  child: InkWell(
                                                                                      onTap: () async {
                                                                                        await Navigator.push(
                                                                                          context,
                                                                                          MaterialPageRoute(builder: (context) => accueil(siteCode: "$nmmid")),
                                                                                        );
                                                                                      },
                                                                                      child: Text("$nmm"))));
                                                                        }),
                                                                    leading: IconButton(
                                                                        onPressed:
                                                                            () async {
                                                                          showDialog(
                                                                            context:
                                                                                context,
                                                                            builder:
                                                                                (BuildContext
                                                                                    context) {
                                                                              return AlertDialog(
                                                                                title:  Text(AppLocale.delete.getString(context)),
                                                                                content:
                                                                                     Text(AppLocale.deleteText.getString(context)),
                                                                                actions: <Widget>[
                                                                                  TextButton(
                                                                                    onPressed:
                                                                                        () {
                                                                                      Navigator.of(context).pop(false);
                                                                                    },
                                                                                    child:
                                                                                         Text(AppLocale.no.getString(context)),
                                                                                  ),
                                                                                  TextButton(
                                                                                    onPressed:
                                                                                        () {
                                                                                      Navigator.of(context).pop(true);
                                                                                    },
                                                                                    child:
                                                                                         Text(AppLocale.yes.getString(context)),
                                                                                  ),
                                                                                ],
                                                                              );
                                                                            },
                                                                          ).then(
                                                                              (value) async {
                                                                            if (value) {
                                                                              if (snapshot
                                                                                  .hasData) {
                                                                                final documents = snapshot
                                                                                    .data!
                                                                                    .docs;
                                                                                for (var element
                                                                                    in documents) {
                                                                                  if (element
                                                                                      .id
                                                                                      .contains("${mma["info"][index]["nbst"]},${widget.phone}")) {
                                                                                    final dt =
                                                                                        element.data() as Map;
                                                                                    final dtt =
                                                                                        dt.length;
                                                                                    for (var i = 1;
                                                                                        i <= dtt;
                                                                                        i++) {
                                                                                      if (dt["match$i"]["date"] == mma["date"] &&
                                                                                          dt["match$i"]["heur"] == mma["info"][index]["heur"]) {
                                                                                        for (var j = i; j < dtt; j++) {
                                                                                          _firestore.collection("matches").doc(element.id).update({
                                                                                            "match$j": dt["match${j + 1}"]
                                                                                          });
                                                                                        }
                                                                                        _firestore.collection("matches").doc(element.id).update({
                                                                                          "match$dtt": FieldValue.delete()
                                                                                        });
                                                                                      }
                                                                                    }
                                                                                  }
                                                                                }
                                                                              }
                                                                            }
                                                                          });
                                                                          //if (snap.hasdata) {
                            
                                                                          //}
                                                                        },
                                                                        icon: const Icon(
                                                                            Icons
                                                                                .delete))),
                                                          );
                                                          //     ],
                                                          //   ),
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                )),
                                          ],
                                        ));
                                      }
                                      return Column(
                                        children: w,
                                      );
                                    })
                              ])))),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Visibility(
                      visible: vep,
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 30,
                          ),
                          StreamBuilder<QuerySnapshot>(
                        
                                    stream: _firestore.collection("Users").snapshots(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        final documents = snapshot.data!.docs;
                                        List ids=[];
                                        for (var element in documents) {
                                          ids.add(element.id);
                                        }
                        
                                      if (ids.contains(widget.phone)) {
                                        v2=true;
                                      }}
                              return Visibility(
                                visible: v2,
                                child: InkWell(
                                  child: Container(
                                    width: 300,
                                    decoration: const BoxDecoration(
                                        border: Border(
                                            top: BorderSide(
                                                color: Color.fromARGB(255, 172, 154, 100)),
                                            right: BorderSide(
                                                color: Color.fromARGB(255, 172, 154, 100)),
                                            left: BorderSide(
                                                color: Color.fromARGB(255, 172, 154, 100)),
                                            bottom: BorderSide(
                                                color: Color.fromARGB(255, 212, 203, 158)))),
                                    child: Row(
                                      children: [
                                         Container(
                                          width: 150,
                                           child: Text(AppLocale.messites.getString(context),
                                            style: TextStyle(fontSize: 24),
                                                                                 ),
                                         ),
                                        const SizedBox(
                                          width: 100,
                                        ),
                                        Icon(
                                          vi ? Icons.arrow_right : Icons.arrow_drop_down,
                                        )
                                      ],
                                    ),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      vi = !vi;
                                    });
                                  },
                                ),
                              );
                            }
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                            visible:vi,
                          child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: SingleChildScrollView(
                                  child: Column(children: [
                                // const SizedBox(
                                //   height: 100,
                                // ),
                                StreamBuilder<QuerySnapshot>(
                                    stream: _firestore.collection("Users").snapshots(),
                                    builder: (context, snapshot) {
                                      List<Widget> Widgets = [];
                                      if (snapshot.hasData) {
                                        final documents = snapshot.data!.docs;
                                        for (var element in documents) {
                                          if (element.id == widget.phone) {
                                            //for (var i = 0; i <= 5; i++) {
                                            var dt = element.data() as Map<String, dynamic>;
                                            var data = dt.containsKey("sites")
                                                ? element.get("sites")
                                                : null;
                                            // var Site = data.containsKey("site$i")
                                            //     ? element.get("site$i")
                                            //     : null;
                                            if (data != [] && data != null) {
                                              for (var i in data) {
                                                Widgets.add(StreamBuilder<QuerySnapshot>(
                                                    stream: _firestore
                                                        .collection("site")
                                                        .snapshots(),
                                                    builder: (context, snapshot) {
                                                      List<Widget> wid = [];
                                                      if (snapshot.hasData) {
                                                        final docu = snapshot.data!.docs;
                                                        for (var element in docu) {
                                                          if (element.id == i) {
                                                            var dttt = element.data() as Map<String, dynamic>;
                                                            var photos=dttt.containsKey("photos")? element.get("photos"):null;
                                                              var src =(photos!=null && photos.length!=0)?photos[0]:null;
                                                              print(src);
                                                              if (src != null ) {
                                                                wid.add(
                                                                  Container(
                                                                    width: 300,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                            border:
                                                                                Border.all(
                                                                              color: Colors
                                                                                  .black,
                                                                            ),
                                                                            borderRadius:
                                                                                BorderRadius
                                                                                    .circular(
                                                                                        10)),
                                                                    child: Center(
                                                                        child: Column(
                                                                      children: [
                                                                        SizedBox(
                                                                          width: double
                                                                              .infinity,
                                                                          height: 100,
                                                                          child: ClipRRect(
                                                                            borderRadius:
                                                                                BorderRadius
                                                                                    .circular(
                                                                                        10),
                                                                            child:
                                                                                FadeInImage(
                                                                              placeholder:
                                                                                  const AssetImage(
                                                                                      'images/logo.png'), // صورة الاحتياطية التي تظهر أثناء تحميل الصورة
                                                                              image:
                                                                                  NetworkImage(
                                                                                      src),
                                                                              height: 200,
                                                                              width: 300,
                                                                              fit: BoxFit
                                                                                  .cover, // رابط الصورة الفعلية
                                                                              // طريقة تغيير حجم الصورة لتناسب العنصر الذي يحتويه
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          width: 300,
                                                                          child: Row(
                                                                            children: [
                                                                              Padding(
                                                                                padding:
                                                                                    const EdgeInsets.all(
                                                                                        8.0),
                                                                                child:
                                                                                    Container(
                                                                                  width:
                                                                                      133,
                                                                                  decoration: BoxDecoration(
                                                                                      color: const Color.fromARGB(
                                                                                          255,
                                                                                          79,
                                                                                          162,
                                                                                          230),
                                                                                      borderRadius:
                                                                                          BorderRadius.circular(8)),
                                                                                  // decoration: BoxDecoration(border: backgroundc),
                                                                                  child: IconButton(
                                                                                      // color: Colors.black,
                                                                                      onPressed: () async {
                                                                                        await Navigator.push(
                                                                                          context,
                                                                                          MaterialPageRoute(
                                                                                              builder: (context) => mod(
                                                                                                    siteCode: element.id,
                                                                                                    phone: widget.phone,
                                                                                                  )),
                                                                                        );
                                                                                      },
                                                                                      icon: const Icon(color: Color.fromARGB(255, 53, 48, 32), Icons.edit)),
                                                                                ),
                                                                              ),
                                                                              // SizedBox(
                                                                              //   width: 170,
                                                                              // ),
                                                                              Padding(
                                                                                padding:
                                                                                    const EdgeInsets.all(
                                                                                        8.0),
                                                                                child:
                                                                                    Container(
                                                                                  width:
                                                                                      133,
                                                                                  decoration: BoxDecoration(
                                                                                      color: const Color.fromARGB(
                                                                                          255,
                                                                                          184,
                                                                                          158,
                                                                                          82),
                                                                                      borderRadius:
                                                                                          BorderRadius.circular(8)),
                                                                                  child: IconButton(
                                                                                      onPressed: () async {
                                                                                        await Navigator.push(
                                                                                          context,
                                                                                          MaterialPageRoute(
                                                                                              builder: (context) => mod2(
                                                                                                    siteCode: element.id,
                                                                                                    phone: widget.phone,
                                                                                                  )),
                                                                                        );
                                                                                      },
                                                                                      icon: const Icon(color: Color.fromARGB(255, 53, 48, 32), Icons.score)),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        )
                                                                      ],
                                                                    )),
                                                                  ),
                                                                );
                                                                wid.add(const SizedBox(
                                                                  height: 20,
                                                                ));
                                                              }else{
                                                                wid.add(
                                                                  Container(
                                                                    width: 300,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                            border:
                                                                                Border.all(
                                                                              color: Colors
                                                                                  .black,
                                                                            ),
                                                                            borderRadius:
                                                                                BorderRadius
                                                                                    .circular(
                                                                                        10)),
                                                                    child: Center(
                                                                        child: Column(
                                                                      children: [
                                                                        SizedBox(
                                                                          width: double
                                                                              .infinity,
                                                                          height: 100,
                                                                          child: ClipRRect(
                                                                            borderRadius:
                                                                                BorderRadius
                                                                                    .circular(
                                                                                        10),
                                                                            child:
                                                                                const FadeInImage(
                                                                              placeholder:
                                                                                   AssetImage(
                                                                                      'images/logo.png'), // صورة الاحتياطية التي تظهر أثناء تحميل الصورة
                                                                              image:
                                                                                  AssetImage(
                                                                                      'images/logo.png'),
                                                                              height: 200,
                                                                              width: 300,
                                                                              fit: BoxFit
                                                                                  .cover, // رابط الصورة الفعلية
                                                                              // طريقة تغيير حجم الصورة لتناسب العنصر الذي يحتويه
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          width: 300,
                                                                          child: Row(
                                                                            children: [
                                                                              Padding(
                                                                                padding:
                                                                                    const EdgeInsets.all(
                                                                                        8.0),
                                                                                child:
                                                                                    Container(
                                                                                  width:
                                                                                      133,
                                                                                  decoration: BoxDecoration(
                                                                                      color: const Color.fromARGB(
                                                                                          255,
                                                                                          79,
                                                                                          162,
                                                                                          230),
                                                                                      borderRadius:
                                                                                          BorderRadius.circular(8)),
                                                                                  // decoration: BoxDecoration(border: backgroundc),
                                                                                  child: IconButton(
                                                                                      // color: Colors.black,
                                                                                      onPressed: () async {
                                                                                        await Navigator.push(
                                                                                          context,
                                                                                          MaterialPageRoute(
                                                                                              builder: (context) => mod(
                                                                                                    siteCode: element.id,
                                                                                                    phone: widget.phone,
                                                                                                  )),
                                                                                        );
                                                                                      },
                                                                                      icon: const Icon(color: Color.fromARGB(255, 53, 48, 32), Icons.edit)),
                                                                                ),
                                                                              ),
                                                                              // SizedBox(
                                                                              //   width: 170,
                                                                              // ),
                                                                              Padding(
                                                                                padding:
                                                                                    const EdgeInsets.all(
                                                                                        8.0),
                                                                                child:
                                                                                    Container(
                                                                                  width:
                                                                                      133,
                                                                                  decoration: BoxDecoration(
                                                                                      color: const Color.fromARGB(
                                                                                          255,
                                                                                          184,
                                                                                          158,
                                                                                          82),
                                                                                      borderRadius:
                                                                                          BorderRadius.circular(8)),
                                                                                  child: IconButton(
                                                                                      onPressed: () async {
                                                                                        await Navigator.push(
                                                                                          context,
                                                                                          MaterialPageRoute(
                                                                                              builder: (context) => mod2(
                                                                                                    siteCode: element.id,
                                                                                                    phone: widget.phone,
                                                                                                  )),
                                                                                        );
                                                                                      },
                                                                                      icon: const Icon(color: Color.fromARGB(255, 53, 48, 32), Icons.score)),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        )
                                                                      ],
                                                                    )),
                                                                  ),
                                                                );
                                                                wid.add(const SizedBox(
                                                                  height: 20,
                                                                ));

                                                              }
                                                            }
                                                        }
                                                      }
                                                      return Column(
                                                        children: wid,
                                                      );
                                                    }));
                                              }
                                            }
                                          }
                                        }
                                      }
                                      return Column(
                                        children: Widgets,
                                      );
                                    }),
                                StreamBuilder<QuerySnapshot>(
                                    stream: _firestore.collection("at").snapshots(),
                                    builder: (context, snapshot) {
                                      List<Widget> widgetss = [];
                                      if (snapshot.hasData) {
                                        final du = snapshot.data!.docs;
                                        
                                        for (var element in du) {
                                          var data=element.data() as Map;
                                          if (data.containsKey("USER") && element.get("USER") == widget.phone) {
                                            //var va=element.data() as Map;
                                            List photos = element.get("photos");
                                            print(photos);
                                            if (photos.isNotEmpty) {
                                              widgetss.add(Container(
                                                  width: 300,
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: Colors.black,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(10)),
                                                  child: Center(
                                                      child: Column(children: [
                                                    SizedBox(
                                                      width: double.infinity,
                                                      height: 100,
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius.circular(10),
                                                        child: FadeInImage(
                                                          placeholder: const AssetImage(
                                                              'images/logo.png'), // صورة الاحتياطية التي تظهر أثناء تحميل الصورة
                                                          image: NetworkImage(photos[0]),
                                                          height: 200,
                                                          width: 300,
                                                          fit: BoxFit
                                                              .cover, // رابط الصورة الفعلية
                                                          // طريقة تغيير حجم الصورة لتناسب العنصر الذي يحتويه
                                                        ),
                                                      ),
                                                    ),
                                                     Center(
                                                      child: Text(AppLocale.waiting.getString(context)),
                                                    ),
                                                    SizedBox(
                                                                          width: 300,
                                                                          child:Padding(
                                                                                padding:
                                                                                    const EdgeInsets.all(
                                                                                        8.0),
                                                                                child:
                                                                                    Container(
                                                                                  width:
                                                                                      133,
                                                                                  decoration: BoxDecoration(
                                                                                      color: const Color.fromARGB(
                                                                                          255,
                                                                                          79,
                                                                                          162,
                                                                                          230),
                                                                                      borderRadius:
                                                                                          BorderRadius.circular(8)),
                                                                                  // decoration: BoxDecoration(border: backgroundc),
                                                                                  child: IconButton(
                                                                                      // color: Colors.black,
                                                                                      onPressed: () async {
                                                                                        await Navigator.push(
                                                                                          context,
                                                                                          MaterialPageRoute(
                                                                                              builder: (context) => mod3(
                                                                                                    siteCode: element.id,
                                                                                                    phone: widget.phone,
                                                                                                    v: false,
                                                                                                  )),
                                                                                        );
                                                                                      },
                                                                                      icon: const Icon(color: Color.fromARGB(255, 53, 48, 32), Icons.edit)),
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
                                                      borderRadius:
                                                          BorderRadius.circular(10)),
                                                  child: Center(
                                                      child: Column(children: [
                                                    SizedBox(
                                                      width: double.infinity,
                                                      height: 100,
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius.circular(10),
                                                        child: const FadeInImage(
                                                          placeholder: AssetImage(
                                                              'images/logo.png'), // صورة الاحتياطية التي تظهر أثناء تحميل الصورة
                                                          image:
                                                              AssetImage('images/logo.png'),
                                                          height: 200,
                                                          width: 300,
                                                          fit: BoxFit
                                                              .cover, // رابط الصورة الفعلية
                                                          // طريقة تغيير حجم الصورة لتناسب العنصر الذي يحتويه
                                                        ),
                                                      ),
                                                    ),
                                                     Center(
                                                      child: Text(AppLocale.waiting.getString(context)),
                                                    ),
                                                    SizedBox(
                                                                          width: 300,
                                                                          child: Padding(
                                                                                padding:
                                                                                    const EdgeInsets.all(
                                                                                        8.0),
                                                                                child:
                                                                                    Container(
                                                                                  width:
                                                                                      133,
                                                                                  decoration: BoxDecoration(
                                                                                      color: const Color.fromARGB(
                                                                                          255,
                                                                                          79,
                                                                                          162,
                                                                                          230),
                                                                                      borderRadius:
                                                                                          BorderRadius.circular(8)),
                                                                                  // decoration: BoxDecoration(border: backgroundc),
                                                                                  child: IconButton(
                                                                                      // color: Colors.black,
                                                                                      onPressed: () async {
                                                                                        await Navigator.push(
                                                                                          context,
                                                                                          MaterialPageRoute(
                                                                                              builder: (context) => mod3(
                                                                                                    siteCode: element.id,
                                                                                                    phone: widget.phone,
                                                                                                    v: false,
                                                                                                  )),
                                                                                        );
                                                                                      },
                                                                                      icon: const Icon(color: Color.fromARGB(255, 53, 48, 32), Icons.edit)),
                                                                                ),
                                                                              ),
                                                                              // SizedBox(
                                                                              //   width: 170,
                                                                              // ),
                                                                              
                                                                           
                                                                          
                                                                        )
                                                  ]))));
                                            }
                                          }
                                        }
                                      }
                                      widgetss.add(const SizedBox(
                                        height: 10,
                                      ));
                                      return Column(
                                        children: widgetss,
                                      );
                                    }),
                    
                                const SizedBox(
                                  height: 10,
                                ),
                                Visibility(
                                  visible: visible,
                                  child: Center(
                                    child: InkWell(
                                      child: Container(
                                        width: 300,
                                        height: 100,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              color:
                                                  const Color.fromARGB(255, 172, 154, 100),
                                            ),
                                            borderRadius: BorderRadius.circular(100)),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(100),
                                          child: Image.asset(
                                              width: 300,
                                              height: 100,
                                              "images/download.png",
                                              fit: BoxFit.cover),
                                        ),
                                      ),
                                      onTap: () async {
                                        CollectionReference usersCollection =
                                            _firestore.collection("at");
                                        QuerySnapshot snapshot =
                                            await usersCollection.get();
                                        numberOfDocuments = snapshot.size;
                                        List<DocumentSnapshot> documents = snapshot.docs;
                                        final L = [];
                                        for (var doc in documents) {
                                          L.add(doc.id);
                                        }
                                        for (var i = 1; i < numberOfDocuments! + 2; i++) {
                                          if (!L.contains(i.toString())) {
                                            print(i);
                                            Document = i;
                                            break;
                                          }
                                        }
                    
                                        await _firestore
                                            .collection("at")
                                            .doc("$Document")
                                            .set({"photos": []});
                    
                                        nombrePhoto = 0;
                                        _checked.clear();
                                        // newDoc!.set({"photos": []});
                                        for (var i = 0; i < 24; i++) {
                                          _checkedItems[i] = false;
                                        }
                                        itemlist=[""];
                                        itelist=[""];
                                        selectedite="";
                                        selecteditem="";
                                        // setState(() {
                                        // _textController.text =  texller != null ? "$texller" : "";
                    
                                        // });
                                        // siteText=null;
                                        // siteNom=null;
                                        // local=null;
                                        setState(() {
                                          visible = !visible;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                Visibility(
                                    visible: !visible,
                                    child: Center(
                                      child: Container(
                                          width: 300,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                color: const Color.fromARGB(
                                                    255, 172, 154, 100),
                                              ),
                                              borderRadius: BorderRadius.circular(10)),
                                          child: SingleChildScrollView(
                                            child: Column(children: [
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Container(
                                                width: 200,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(8),
                                                    border:
                                                        Border.all(color: Colors.black)),
                                                child: TextField(
                                                  onChanged: (value) {
                                                    setState(() {
                                                    siteNom = value;
                                                    });
                                                  },
                                                  keyboardType: TextInputType.multiline,
                                                  maxLines: null,
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                  ),
                                                  decoration:  InputDecoration(
                                                    hintText: AppLocale.sitenom.getString(context),
                                                  ),
                                                  textAlignVertical:
                                                      TextAlignVertical.center,
                                                ),
                                              ),
                                              SizedBox(height: 20,),
                                              SizedBox(
                                                width: 150,
                                                child: StreamBuilder<QuerySnapshot>(
                                                    stream: _firestore
                                                        .collection('at')
                                                        .snapshots(),
                                                    builder: (context, snapshot) {
                                                      List<Widget> messageWidgets = [];
                                                      List photos = [];
                                                      if (snapshot.hasData) {
                                                        final messages = snapshot.data!.docs;
                                                        for (var element in messages) {
                                                          if (element.id == "$Document") {
                                                             photos =
                                                                element.get("photos");}}}
                                                                  return     
                                                    //               InkWell(
                                                    // onTap: () async {
                                                    //         },
                                                    // child:
                                                     Container(
                                                      decoration: BoxDecoration(border: Border.all(width: 1.0),borderRadius: BorderRadius.circular(15),),
                                                      child: SizedBox(
                                                        width: 100,
                                                        height: 150,
                                                        child: PageView.builder(
                                                          itemCount: photos.length,
                                                          itemBuilder: (BuildContext context, int index) {
                                                            return 
                                                            // SizedBox(
                                                            //   width: 0,
                                                            //   child: 
                                                              Column(
                                                                children: [
                                                                  ClipRRect(
                                                                        borderRadius: BorderRadius.circular(15),
                                                                        child: 
                                                                        SizedBox(
                                                                          width: 100,
                                                                          height: 100,
                                                                          child: FadeInImage(
                                                                            placeholder: AssetImage(
                                                                                'images/logo.png'), // صورة الاحتياطية التي تظهر أثناء تحميل الصورة
                                                                            image: NetworkImage(photos[
                                                                                index]), // رابط الصورة الفعلية
                                                                            fit: BoxFit
                                                                                .cover, // طريقة تغيير حجم الصورة لتناسب العنصر الذي يحتويه
                                                                          ),
                                                                        )
                                                                        ),
                                                                       
                                                                        IconButton(icon: Icon(Icons.delete),onPressed: ()async{
                                                                           deletephoto("$Document", photos[index]);
                                                                        },)
                                                                ],
                                                              );
                                                          },
                                                        )));
                                                                      //   ],
                                                                      // );
                                                                      }
                                                                    ),
                                                                  // );}),
                                              ),
                                                  //                  ) ;
                                                  //             // messageWidgets
                                                  //             //     .add(messageWidget);
                                                  //           // }
                                                  //         }
                                                  //       }
                                                  //     }
                                                  //   }
                                                  //   return Row(
                                                  //     children: messageWidgets,
                                                  //   );
                                                  // }),
                                              mybutton(
                                                  color: Colors.black,
                                                  title: AppLocale.addphoto.getString(context),
                                                  onPressed: () async {
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
                                                              _requestPermissioncamera('folder');
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
                                                              _requestPermissioncamera('camera');
                                                              // تنفيذ الإجراء الخاص بالخيار الثالث
                                                              Navigator.pop(
                                                                  context);
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
                                                  }),
                                              const SizedBox(height: 10),
                                              Container(
                                                width: 200,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(8),
                                                    border:
                                                        Border.all(color: Colors.black)),
                                                child: TextField(
                                                  onChanged: (value) {
                                                    setState(() {
                                                    siteText =value;
                                                    });
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
                                                  textAlignVertical:
                                                      TextAlignVertical.center,
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                               Center(
                                                 child: Container(
                                                  width: 200,
                                                   child: Text(AppLocale.localisation.getString(context),
                                                    style: const TextStyle(fontSize: 25),
                                                                                               ),
                                                 ),
                                               ),
                                              Container(
                                                width: 250,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(8),
                                                    border:
                                                        Border.all(color: Colors.black)),
                                                child: TextField(
                                                  // controller: _textController,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      // _textController.text=value;
                                                      local = value;
                                                    });
                                                  },
                                                  // keyboardType: TextInputType.multiline,
                                                  // maxLines: null,
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                  ),
                                                  decoration:  InputDecoration(
                                                      hintText:AppLocale.localisationtext.getString(context),
                                                      fillColor: Colors.black),
                                                  textAlignVertical:
                                                      TextAlignVertical.center,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              ElevatedButton(
                                                onPressed: () async {
                                                  setState(() {
                                                    isvisible = !isvisible;
                                                  });
                                                },
                                                child:
                                                     Text(AppLocale.shutdown.getString(context)),
                                              ),
                                              const SizedBox(height: 10),
                                              Visibility(
                                                visible: isvisible,
                                                child: Column(
                                                  children: [
                                                     Text(AppLocale.shutdowntext.getString(context)),
                                                    Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                color: Colors.red)),
                                                        height: isvisible ? 200 : 0,
                                                        child: ListView.builder(
                                                          itemCount: _items.length,
                                                          itemBuilder:
                                                              (BuildContext context,
                                                                  int index) {
                                                            return CheckboxListTile(
                                                              title: Text(_items[index]),
                                                              value: _checkedItems[index],
                                                              onChanged: (bool? value) {
                                                                setState(() {
                                                                  _checkedItems[index] =
                                                                      value!;
                                                                  if (value == true) {
                                                                    _checked
                                                                        .add(_items[index]);
                                                                    _firestore
                                                                        .collection('at')
                                                                        .doc("$Document")
                                                                        .update({
                                                                      "Stop": _checked
                                                                    });
                                                                  } else {
                                                                    _checked.remove(
                                                                        _items[index]);
                                                                    _firestore
                                                                        .collection('at')
                                                                        .doc("$Document")
                                                                        .update({
                                                                      "Stop": _checked
                                                                    });
                                                                  }
                                                                });
                                                              },
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              
                                  // Center(child: Text("Filtrage")),
                                  Transform.scale(
                                    scale: 0.7,
                                    child: 
                                    StreamBuilder<QuerySnapshot>(
                                  stream: _firestore.collection("variables").snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      final documents = snapshot.data!.docs;
                                      for (var element in documents) {
                                        if (element.id=="places") {
                                          
                                        
                                        var elements=element.data() as Map;
                                        if (elements.containsKey("list")) {
                                          
                                            
                                          for (var el in element.get("list")) {
                                            if (itemlist.contains(el)==false) {
                                              itemlist.add(el);
                                            }
                                            
                                          }
                                          
                                        }}
                                        
            
                                      }}
                                        return Container(
                                          width: 120,
                                          child: DropdownButtonFormField<String>(
                                              decoration: const InputDecoration(
                                                //border: InputBorder.none,
                                                enabledBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        width: 2, color: Colors.green)),
                                                focusedBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        width: 5, color: Colors.blue)),
                                              ),
                                              value: selecteditem,
                                              items: itemlist
                                                  .map((item) => DropdownMenuItem(
                                                      value: item,
                                                      child: Center(
                                                        child: Text(
                                                          item,
                                                        ),
                                                      )))
                                                  .toList(),
                                              onChanged: (item) => setState(() {
                                                    selecteditem = item;
                                                  })),
                                        );
                                      }
                                    ),
                                  ),
                                  Transform.scale(
                                    scale: 0.7,
                                    child: 
                                    StreamBuilder<QuerySnapshot>(
                                  stream: _firestore.collection("variables").snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      final documents = snapshot.data!.docs;
                                      for (var element in documents) {
                                        if (element.id=="volme") {
                                          
                                        
                                        var elements=element.data() as Map;
                                       
                                        if (elements.containsKey("list")) {
                                          
                                          for (var el in element.get("list")) {
                                            if (itelist.contains(el)==false) {
                                              
                                            
                                            itelist.add(el);
                                            }
                                          }

                                          
                                        }
            
                                      }}}
                                        return Container(
                                          width: 120,
                                          child: DropdownButtonFormField<String>(
                                              decoration: const InputDecoration(
                                                //border: InputBorder.none,
                                                enabledBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        width: 2, color: Colors.green)),
                                                focusedBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        width: 5, color: Colors.blue)),
                                              ),
                                              value: selectedite,
                                              items: itelist
                                                  .map((item) => DropdownMenuItem(
                                                      value: item,
                                                      child: Center(
                                                        child: Text(
                                                          item,
                                                        ),
                                                      )))
                                                  .toList(),
                                              onChanged: (item) => setState(() {
                                                    selectedite = "$item";
                                                  })),
                                        );
                                      }
                                    ),
                                  ),
                             
                                              Padding(
                                                padding: const EdgeInsets.symmetric(
                                                    horizontal: 30),
                                                child: Row(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: mybutton(
                                                          color: const Color.fromARGB(
                                                              255, 155, 79, 74),
                                                          title: AppLocale.cancel.getString(context),
                                                          onPressed: () async {
                                                            _firestore
                                                                .collection("at")
                                                                .doc("$Document")
                                                                .delete();
                                                            setState(() {
                                                              visible = !visible;
                                                              isvisible = false;
                                                            });
                                                          } //, icon: const Icon(Icons.cancel)
                                                          ),
                                                    ),
                                                    Padding(
                                                      padding:  const EdgeInsets.all(8.0),
                                                      child: mybutton(
                                                          color: const Color.fromARGB(
                                                              255, 146, 211, 148),
                                                          title: AppLocale.confirm.getString(context),
                                                          onPressed: () async {
                                                            _firestore
                                                                .collection("at")
                                                                .doc("$Document")
                                                                .update({
                                                              "nom": siteNom,
                                                              "Text": siteText,
                                                              "USER": widget.phone,
                                                              "place":selecteditem,
                                                              "vol":selectedite
                                                            });
                                                            if (local == null) {
                                                              await _requestPermission(
                                                                  "$Document");
                                                              setState(() {
                                                                local = null;
                                                              });
                                                            } else {
                                                              await _firestore
                                                                  .collection("at")
                                                                  .doc("$Document")
                                                                  .update({"local": local});
                                                              setState(() {
                                                                local = null;
                                                              });
                                                            }
                                                            setState(() {
                                                              visible = !visible;
                                                              isvisible = false;
                                                            });
                                                            // }
                                                          }),
                                                    )
                                                  ],
                                                ),
                                              )
                                            ]),
                                          )),
                                    ))
                              ]))),
                        ),
                        // //////////////////////////////////////

                        Visibility(
                            visible:!vep,
                          child: Center(
                            child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                child: SingleChildScrollView(
                                    child: Column(children: [
                                  // const SizedBox(
                                  //   height: 100,
                                  // ),
                                  StreamBuilder<QuerySnapshot>(
                                      stream: _firestore.collection("employers").snapshots(),
                                      builder: (context, snapshot) {
                                        List<Widget> Widgets = [];
                                        if (snapshot.hasData) {
                                          final documents = snapshot.data!.docs;
                                          for (var element in documents) {
                                            if (element.id == widget.phone) {
                                              //for (var i = 0; i <= 5; i++) {
                                              var dt = element.data() as Map<String, dynamic>;
                                              var data = dt.containsKey("sites")
                                                  ? element.get("sites")
                                                  : null;
                                              // var Site = data.containsKey("site$i")
                                              //     ? element.get("site$i")
                                              //     : null;
                                              if (data != [] && data != null) {
                                                for (var i in data) {
                                                  Widgets.add(StreamBuilder<QuerySnapshot>(
                                                      stream: _firestore
                                                          .collection("site")
                                                          .snapshots(),
                                                      builder: (context, snapshot) {
                                                        List<Widget> wid = [];
                                                        if (snapshot.hasData) {
                                                          final docu = snapshot.data!.docs;
                                                          for (var element in docu) {
                                                            if (element.id == i) {
                                                              var dttt = element.data() as Map<String, dynamic>;
                                                              var photos=dttt.containsKey("photos")? element.get("photos"):null;
                                                                var src =photos!=null && photos!=[]?photos[0]:null;
                                                                print(src);
                                                                if (src != null ) {
                                                                  wid.add(
                                                                    
                                                                    Column(
                                                                      children: [
                                                                        Center(child: Text(dttt.containsKey("nom")?element.get("nom"):"",),),
                                                                        SizedBox(
                                                                          height: 10,
                                                                        ),
                                                                        Container(
                                                                          width: 300,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                                  border:
                                                                                      Border.all(
                                                                                    color: Colors
                                                                                        .black,
                                                                                  ),
                                                                                  borderRadius:
                                                                                      BorderRadius
                                                                                          .circular(
                                                                                              10)),
                                                                          child: Center(
                                                                              child: Column(
                                                                            children: [
                                                                              SizedBox(
                                                                                width: double
                                                                                    .infinity,
                                                                                height: 100,
                                                                                child: ClipRRect(
                                                                                  borderRadius:
                                                                                      BorderRadius
                                                                                          .circular(
                                                                                              10),
                                                                                  child:
                                                                                      FadeInImage(
                                                                                    placeholder:
                                                                                        const AssetImage(
                                                                                            'images/logo.png'), // صورة الاحتياطية التي تظهر أثناء تحميل الصورة
                                                                                    image:
                                                                                        NetworkImage(
                                                                                            src),
                                                                                    height: 200,
                                                                                    width: 300,
                                                                                    fit: BoxFit
                                                                                        .cover, // رابط الصورة الفعلية
                                                                                    // طريقة تغيير حجم الصورة لتناسب العنصر الذي يحتويه
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              SizedBox(
                                                                                width: 300,
                                                                                child: 
                                                                                    Padding(
                                                                                      padding:
                                                                                          const EdgeInsets.all(
                                                                                              8.0),
                                                                                      child:
                                                                                          Container(
                                                                                        width:
                                                                                            133,
                                                                                        decoration: BoxDecoration(
                                                                                            color: const Color.fromARGB(
                                                                                                255,
                                                                                                184,
                                                                                                158,
                                                                                                82),
                                                                                            borderRadius:
                                                                                                BorderRadius.circular(8)),
                                                                                        child: IconButton(
                                                                                            onPressed: () async {
                                                                                              await Navigator.push(
                                                                                                context,
                                                                                                MaterialPageRoute(
                                                                                                    builder: (context) => mod2(
                                                                                                          siteCode: element.id,
                                                                                                          phone: widget.phone,
                                                                                                        )),
                                                                                              );
                                                                                            },
                                                                                            icon: const Icon(color: Color.fromARGB(255, 53, 48, 32), Icons.score)),
                                                                                      ),
                                                                                    ),
                                                                                  
                                                                                
                                                                              )
                                                                            ],
                                                                          )),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  );
                                                                  wid.add(const SizedBox(
                                                                    height: 20,
                                                                  ));
                                                                }
                                                              }
                                                          }
                                                        }
                                                        return Column(
                                                          children: wid,
                                                        );
                                                      }));
                                                }
                                              }
                                            }
                                          }
                                        }
                                        return Column(
                                          children: Widgets,
                                        );
                                      }),
                                  
                                              
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  
                                  
                                ]))),
                          ),
                        )


                                  
                  ],
                ),
              ),
            );
      }
    );
      }
 
  Future<void> deletephoto(String docID, String I) async {
    final messages = await _firestore.collection('at').doc(docID).get();
    var photo = messages.data() as Map;
    List photos = photo["photos"];
    photos.remove(I);
    await _firestore.collection('at').doc(docID).update({"photos": photos});
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

  void uploadimages(String type) async {
    var imgpicked =type=='folder'? await ImagePicker().pickImage(source: ImageSource.gallery):await ImagePicker().pickImage(source: ImageSource.camera);
    if (imgpicked != null) {
      file = File(imgpicked.path);
      var nameimage = basename(imgpicked.path);
      var refstorage = FirebaseStorage.instance.ref().child("/images/$nameimage/");
      print(refstorage);
      await refstorage.putFile(file!);
      var url = await refstorage.getDownloadURL();
      var sitePhoto = url;
      final messages = await _firestore.collection('at').doc("$Document").get();
      var photo = messages.data() as Map;
      List photos = photo["photos"];
      photos.add(sitePhoto);
      await _firestore
          .collection('at')
          .doc("$Document")
          .update({"photos": photos});
          nombrePhoto=photos.length;
          // await refstorage.delete();
          
    } else {
      print("please chose image ");
    }
  }

  // الدالة المسؤولة عن إضافة عنصر إلى القائمة
  // void _addItem(String item) {
  //   setState(() {
  //     itemList.add(item); // إضافة العنصر إلى نهاية القائمة
  //   });
  // }

  // الدالة المسؤولة عن حذف عنصر من القائمة
  // void _deleteItem(int index) {
  //   setState(() {
  //     itemList.removeAt(index); // حذف العنصر بالفهرس المحدد
  //   });
  // }
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

  Future<void> _requestPermissioncamera(String type) async {
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
      uploadimages(type);
    } else {
// الوصول غير مسموح به
      print('الوصول غير مسموح للكاميرا و/أو الملفات');
    }
  }
}
