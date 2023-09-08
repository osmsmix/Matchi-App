
import 'dart:io';
//import 'dart:js_util';
import 'package:first_app/screens/profil.dart';
import 'package:first_app/screens/translate.dart';
import 'package:flutter/foundation.dart';
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

class mod2 extends StatefulWidget {
  static const String screenRoute = 'mat';
  final String siteCode;
  final String phone;

  const mod2({required this.siteCode, required this.phone});

  @override
  State<mod2> createState() => _mod2State();
}

class _mod2State extends State<mod2> {
  final FlutterLocalization localization = FlutterLocalization.instance;
  final _firestore = FirebaseFirestore.instance;

  String? sitePhoto;
  String? siteText;
  late GeoPoint siteLocalisation;
  Widget buildSectionTitle(BuildContext context, String titleText) {
  final String language=localization.currentLocale==null?'en':localization.currentLocale!.languageCode;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      alignment: language=='ar'?Alignment.topRight:Alignment.topLeft,
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

  Future<bool> checkIfAccountExists(String email) async {
  try {
    List<String> signInMethods = await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
    return signInMethods.isNotEmpty;
  } catch (e) {
    print('Error checking account existence: $e');
    return false;
  }
}

  List<String> itemlist = [];
  String? selecteditem = "";

  String getFormattedDate(DateTime dateTime) {
    final formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(dateTime);
  }

  final _texteditingController = TextEditingController(text: "");
  String? joueur;
  // @override
  // void dispose() {
  //   // يجب تفريغ ال TextController بعد الانتهاء من استخدامه لتجنب تسرب الذاكرة
  //   _textController.dispose();
  //   super.dispose();
  // }
  final _textController = TextEditingController(text: '');
  @override
  Widget build(BuildContext context) {

    var stoplist;
          var snap;
          final List<String> worklist = [""];
          for (var i = 0; i <= 23; i++) {
            worklist.add(i.toString());
          }
    return StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection("site").snapshots(),
        builder: (context, snapshot) {
          String? nom;
          if (snapshot.hasData) {
            final documents = snapshot.data!.docs;
            for (var element in documents) {
              if (element.id == widget.siteCode) {
                var data = element.data() as Map<String, dynamic>;
                // final List<String> images = [];
                nom =data.containsKey("nom")? element.get("nom"):"";
                // for (var i = 0; i <= 5; i++) {
                  
                //   var imgRef = data.containsKey("photo$i")
                //       ? element.get("photo$i")
                //       : null;
                //   if (imgRef != null) {
                //     images.add(imgRef);
                //   }
                // }

                 stoplist =data.containsKey("Stop")? element.get("Stop"):[];

 //               if (_textController.text!="اختر التاريخ") {
  
//}
              }
            }
          }
          return StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection("matches").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final documents = snapshot.data!.docs;
            List mtches = [];
            var tt3;
            for (var element in documents) {
              if (element.id == "archif") {
                tt3 = element.data() as Map;
              } else {
                final tt = element.data() as Map;
                for (var i = 1; i <= tt.length; i++) {
                  String date = tt["match$i"]["date"];
                  // String heur =tt["match$i"]["heur"];
                  int? heur = int.tryParse(tt["match$i"]["heur"]);
                  String Date = heur! < 10
                      ? "$date 0${heur + 1}:00:00.000"
                      : "$date ${heur + 1}:00:00.000";
                  int comparisonResult =
                      DateTime.now().compareTo(DateTime.parse(Date));
                  if (comparisonResult > 0) {
                    var match = element.get("match$i");
                    mtches.add([element.id, match]);
                    for (var j = i; j < tt.length; j++) {
                      _firestore
                          .collection("matches")
                          .doc(element.id)
                          .update({"match$j": tt["match${j + 1}"]});
                    }
                    _firestore
                        .collection("matches")
                        .doc(element.id)
                        .update({"match${tt.length}": FieldValue.delete()});
                  }
                }
              }
            }
            for (var mt = 0; mt < mtches.length; mt++) {
              if (!tt3.keys
                  .contains(mtches[mt][0].replaceAll("@oussama.com", ""))) {
                var ky =
                    mtches[mt][0].toString().replaceAll("@oussama.com", "");
                _firestore.collection("matches").doc("archif").update({
                  ky: {"match1": mtches[mt][1]}
                });
              } else {
                for (var element in tt3.keys) {
                  if (mtches[mt][0].contains(element)) {
                    var nouveau = tt3[element];
                    var siz = nouveau.length;
                    nouveau.addAll({"match${siz + 1}": mtches[mt][1]});
                    var ky =
                        mtches[mt][0].toString().replaceAll("@oussama.com", "");
                    // nouveau.update("match${siz+1}", (value) => mtches[mt][1]);
                    _firestore
                        .collection("matches")
                        .doc("archif")
                        .update({ky: nouveau});
                  }
                }
              }
            }
          }

          return Scaffold(
                  appBar: AppBar(
                    actions: [],
                    title: Text("$nom"),
                  ),
                  backgroundColor: const Color.fromARGB(255, 212, 203, 158),
                  body: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        buildSectionTitle(context, AppLocale.matchs.getString(context)),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: StreamBuilder<QuerySnapshot>(
                              stream: _firestore.collection("matches").snapshots(),
                              builder: (context, snapshot) {
                                snap=snapshot;
                                List<Widget> col = [];
                                if (snapshot.hasData) {
                                  final docs = snapshot.data!.docs;
                                  var ll=[];
                                  for (var e in docs) {
                                      if (e.id.contains("${widget.siteCode},")) {
                                        print(e.id);
          
                                    var eata = e.data() as Map;
                                    print(eata);
                                      
                                    
                                    final dd = eata.length;
                                      for (var i = 1; i <= dd; i++) {
                                        if (ll.contains({
                                          "date": e.get("match$i")["date"],
                                          "info":[{
                                          "user": e.id
                                              .replaceAll("${widget.siteCode},", "")
                                              .replaceAll("@oussama.com", ""),
                                          "heur": e.get("match$i")["heur"],
                                          "add":e.get("match$i").containsKey("add")?e.get("match$i")["add"]:null
                                          }]
                                          
                                        })==false) {
                                          
                                        
                                        ll.add({
                                          "date": e.get("match$i")["date"],
                                          "info":[{
                                          "user": e.id
                                              .replaceAll("${widget.siteCode},", "")
                                              .replaceAll("@oussama.com", ""),
                                          "heur": e.get("match$i")["heur"],
                                          "add":e.get("match$i").containsKey("add")?e.get("match$i")["add"]:null
                                          }]});
                                        }
                                      }
          
                                      int count = ll.length;
                                  for (var i = 0; i < count; i++) {
                                    print(count);
                                    for (var j = i+1; j < count; j++) {
                                      if (ll[i]["date"]==ll[j]["date"]) {
                                        for (var n in ll[j]["info"]) {
                                          print(n);
                                          ll[i]["info"].add(n);
                                          print(ll[i]["info"]);
                                        }
                                        for (var k = j+1; k < count; k++) {
                                          var d=ll[k-1];
                                          ll[k-1]=ll[k];
                                          ll[k]=d;
                                        }
                                        ll.remove(ll[ll.length-1]);
                                        count=count-1;
                                      }
                                    }
                                    for (var i = 0; i < count; i++) {
                                      for (var j = 0; j < ll[i]["info"].length; j++) {
                                        for (var x = j+1; x < ll[i]["info"].length; x++) {
                                          if (int.tryParse(ll[i]["info"][j]["heur"]) !> int.tryParse(ll[i]["info"][x]["heur"])!) {
                                            final xc=ll[i]["info"][j];
                                            ll[i]["info"][j]=ll[i]["info"][x];
                                            ll[i]["info"][x]=xc;
                                          }
                                        }
                                      }
                                      
                                    }
                                  }
          
          
                                      }
          
          
                                         // for (var i = 0; i <= 23; i++) {
                                          int c=worklist.length;
                                            for (var i = 0; i < worklist.length; i++) {
                                              
                                            
                  if (stoplist.contains(worklist[i])) {
              worklist.remove(worklist[i]);
                  }
                }
          
          
          
                                       final Matches = e.data() as Map;
                                      final nombreMatches = Matches.length.toInt();
                                      for (var i = 1; i <= nombreMatches; i++) {
                                        var match =Matches.containsKey("match$i")? e.get("match$i") as Map:{};
                                         print(match["date"].toString());
                                        if (match!={} && match["date"].toString() ==
                                                _textController.text &&
                                            worklist.contains(
                                                match["heur"].toString())) {
                                          worklist.remove(match["heur"].toString());
                                        }
                                      }
                                      ////////
                                  }
                                  
                                    
                                  
                                  
                                  for (var i = 0; i < ll.length; i++) {
                                    for (var j = i+1; j < ll.length; j++) {
                                      DateTime date1=DateTime.parse(ll[i]["date"]);
                                      DateTime date2=DateTime.parse(ll[j]["date"]);
                                      if (date1.isAfter(date2)) {
                                        final c=ll[j];
                                        ll[j]=ll[i];
                                        ll[i]=c;
                                      }
                                    }
                                    
                                  }
          
          
                                  print(ll);
          
          
                                  
                                      for (var q in ll) {
                                        col.add(Column(
                                          children: [
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Center(
                                              child: Text("${AppLocale.date.getString(context)}: ${q["date"]}"),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                                width: 260,
                                                height: 20.0+q["info"].length*70.0,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(40),
                                                    border: Border.all(
                                                        color: Colors.black)),
                                                child: SingleChildScrollView(
                                                  child: Column(
                                                    children: [
                                                      SizedBox(
                                                        height: 20,
                                                      ),
                                                      Row(
                                                        children: [
                                                          SizedBox(
                                                            width: 80,
                                                          ),
                                                          Container(
                                                            width: 67,
                                                            child: Center(child: Text(AppLocale.hour.getString(context)))),
                                                          SizedBox(
                                                            width: 30,
                                                          ),
                                                          Container(
                                                            width: 70,
                                                            // child: Center(
                                                              child: Text(AppLocale.joueur.getString(context))),
                                                        ],
                                                      ),
                                                      //SizedBox(height: 100,),
                                                      ListView.builder(
                                                        shrinkWrap: true,
                                                        itemCount:
                                                            q["info"].length,
                                                        itemBuilder:
                                                            (BuildContext context,
                                                                int index) {
                                                          return 
                                                          SingleChildScrollView(
                                                            child:
                                                          // Column(
                                                          //     children: [
                                                                ListTile(
                                                                  title: Text(
                                                                      "${q["info"][index]["heur"]}h:00mn"),
                                                                  trailing: Text(q["info"][index]["user"]),
                                                                  leading: Visibility(
                                                                    visible: q["info"][index]["add"]==""?true:false,
                                                                    child: IconButton(onPressed: ()async{
                                                                      showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title:  Text(AppLocale.delete.getString(context)),
                                    content:
                                         Text(AppLocale.deleteText.getString(context)),
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
                                  final dc = snap.data!.docs;
                                                                        for (var nt in dc) {
                                                                          if (nt.id.contains("${widget.siteCode},${q["info"][index]["user"]}")) {
                                                                            final mtches=nt.data() as Map;
                                                                            final nmtches=mtches.length;
                                                                            for (var i = 1; i <= nmtches; i++) {
                                                                              if (mtches["match$i"]["date"]==q["date"] && mtches["match$i"]["heur"]==q["info"][index]["heur"]) {
                                                                                for (var j = i; j < nmtches; j++) {
                                                                                  await _firestore.collection("matches").doc("${nt.id}").update({"match$j":nt.get("match${j+1}")});
                                                                                }
                                                                                await _firestore.collection("matches").doc("${nt.id}").update({"match$nmtches":FieldValue.delete()});
                                                                              }
                                                                            }
                                                                          }
                                                                        }
          
                                }});
                                                                      //if (snap.hasdata) {
                                                                        
                                                                      //}
                                                                      
                                                                    }, icon: Icon(Icons.delete))),
                                                                ),
                                                          //     ],
                                                          //   ),
                                                          );
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                )),
                                          ],
                                        ));
                                      }
                                    // }
                                    // //////////
                                    // if (e.id.contains("${widget.siteCode},")) {
                                     
                                    }
                                    /////////
                                    itemlist = worklist.toSet().toList();
                                //   }
                                // }
                                //itemlist = worklist.toSet().toList();
                                return Column(
                                  children: col,
                                );
                              }),
                        ),
                        SizedBox(height: 100,),
                        Container(
                          width: 300,
                          height: 200,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                              border: Border.all(
                                  color: const Color.fromRGBO(0, 0, 0, 1))),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    SizedBox(width: 20,),
                                    SizedBox(
                                      width: 200,
                                      child: InkWell(
                                        child: TextField(
                                          controller: _textController,
                                          decoration:  InputDecoration(
                                            hintText: 'ygyg',
                                            enabled: false,
                                            labelText: AppLocale.date.getString(context),
                                            suffixIcon: const Icon(Icons.calendar_month),
                                          ),
                                        ),
                                        onTap: () async {
                                          DateTime? selectedDate =
                                              await showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime.now(),
                                            lastDate: DateTime(2100),
                                            initialDatePickerMode:
                                                DatePickerMode.day,
                                          );
                                          if (selectedDate != null) {
                                            setState(() {
                                              String j =
                                                  getFormattedDate(selectedDate);
                                              _textController.text = j;
                                              selecteditem="";
                                            });
          
                                            //d = selectedDate;
                                            // يمكن استخدام selectedDate لتحديد السنة المختارة
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 20,
                                    ),
                                    SizedBox(
                                      width: 120,
                                      height: 50,
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
                                            joueur=value;
                                            
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10,),
                                    Container(
                                      width: 100,
                                      height: 100,
                                      child: Center(
                                        child: SizedBox(
                                            child: DropdownButtonFormField<String>(
                                                decoration: const InputDecoration(
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                            borderSide: BorderSide(
                                                                width: 1,
                                                                color: Colors
                                                                    .green)),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                            borderSide: BorderSide(
                                                                width: 1,
                                                                color:
                                                                    Colors.blue))),
                                                value: selecteditem,
                                                items:  worklist
                                                    .toSet()
                                                    .toList()
                                                    .map((item) => DropdownMenuItem(
                                                        value: item,
                                                        child: Center(
                                                          child: Text(
                                                            item,
                                                            style: const TextStyle(
                                                                fontSize: 15),
                                                          ),
                                                        )))
                                                    .toList(),
                                                onChanged: (item) => setState(() {
                                                      selecteditem = item;
                                                    }))),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        ElevatedButton(onPressed: () {
                            if (selecteditem != "" &&
                                _textController.text !='') {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title:  Text(AppLocale.confirm.getString(context)),
                                    content:
                                         Text(AppLocale.confirmtext.getString(context)),
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
                                  if (snap.hasData) {
                                    final docs = snap.data!.docs;
                                    int n=0;
                                    for (var m in docs) {
          
                                      if (m.id.contains("${widget.siteCode},$joueur")) {
                                        var Mat=m.data() as Map;
                                        var nbrMat=Mat.length.toInt();
                                        //print(nbrMat);
                                        var newDoc = _firestore
                                        .collection("matches")
                                        .doc("${m.id}");
                                        final match = {
                                      "date": "${_textController.text}",
                                      "heur": "$selecteditem",
                                      "add":""
                                                      };
                                        await newDoc.update(
                                        {"match${nbrMat+1}": match});
                                        
                                                n=n+1;
                                      }
                                      
                                    }
                                    if (n==0) {
                                      final match = {
                                      "date": "${_textController.text}",
                                      "heur": "$selecteditem",
                                      "add":""
                                                      };
                                                      var newDoc = _firestore
                                        .collection("matches")
                                        .doc("${widget.siteCode},$joueur");
                                        await newDoc.set(
                                        {"match1": match});
          
                                    }
                                    setState(() {
                                      selecteditem = "";
                                      _textController.text = '';
                                      _texteditingController.text="";
                                                });
                                  }
                                    // print(1);
                                    
                                  //print(user!.email);
                                 // if (joueur!.length==8 &&(joueur![0]==2 ||joueur![0]==3||joueur![0]==4 )) {
                                    var newDoc = _firestore
                                        .collection("matches")
                                        .doc("${widget.siteCode},$joueur");
                                    var neDoc = _firestore
                                        .collection("matches")
                                        .doc("${widget.siteCode},$joueur").get() as Map;
                                        final nbrMatches=neDoc.length;
                                    // await newDoc.set({"data": ""});
                                    final match = {
                                      "date": "${_textController.text}",
                                      "heur": "$selecteditem"
                                    };
                                    if (nbrMatches==0) {
                                      await newDoc.set(
                                        {"match${nbrMatches + 1}": match});
                                    }
          
                                    await newDoc.update(
                                        {"match${nbrMatches + 1}": match});
                                    
                                    
                                  //}
          
                                  // الأكشن الذي يتم تنفيذه عند الضغط على "نعم"
                                } else {
                                  setState(() {
                                    selecteditem = "";
                                    _textController.text = '';
                                    _texteditingController.text="";
                                  });
          
                                  // الأكشن الذي يتم تنفيذه عند الضغط على "لا"
                                }
                              });
                            } else {
                              final nackBar = SnackBar(
                                  content: Text(
                                      AppLocale.erreur2.getString(context)));
                              ScaffoldMessenger.of(context).showSnackBar(nackBar);
                            }
                          }, child: Icon(Icons.add)),
                        const SizedBox(height: 10),
                        const SizedBox(height: 150),
                      ],
                    ),
                  ));
            }
          );
        });
  }
}
