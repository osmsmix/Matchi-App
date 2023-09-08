

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_app/screens/translate.dart';
import 'package:first_app/widgets/mybutton.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_localization/flutter_localization.dart';
//import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

class accueil extends StatefulWidget {
  static const String screenRoute = '3';

  final String siteCode;

  const accueil({required this.siteCode});

  @override
  State<accueil> createState() => _accueilState();
}

final _firestore = FirebaseFirestore.instance;

class _accueilState extends State<accueil> {
  final List<String> images = [
    'images/logo.JPG',
    'images/logo.JPG',
    'images/logo.JPG',
  ];
  //final _auth = FirebaseAuth.instance;
  //late User signedInUser;

  final FlutterLocalization localization = FlutterLocalization.instance;
  User? user = FirebaseAuth.instance.currentUser;

  // void getCurrentUser() {
  //   try {
  //     final user = _auth.currentUser;
  //     if (user != null) {
  //       signedInUser = user;
  //       print(user);
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  Widget buildSectionTitle(BuildContext context, String titleText) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      alignment: localization.currentLocale!.languageCode=='ar'?Alignment.topRight:Alignment.topLeft,
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

  final bool _showCalendar = false;
  List<String> itemlist = ["", "ن", "dhd", "sdfifjsf", "fshwc"];
  String? selecteditem = "";
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

  

  // @override
  // void dispose() {
  //   // يجب تفريغ ال TextController بعد الانتهاء من استخدامه لتجنب تسرب الذاكرة
  //   _textController.dispose();
  //   super.dispose();
  // }

  int love = 0;
    final _textController = TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    //var ID = ModalRoute.of(context)!.settings.arguments as String ;
    late var ID = widget.siteCode;
    var snap;
    //print(widget.siteCode);
    return StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection("site").snapshots(),
        builder: (context, snapshot) {
          List<Widget> widgets = [];
          String? nom;
          String? text;
          List<String> worklist = [""];

          //List<String> IDs=[];

          if (snapshot.hasData) {
            final documents = snapshot.data!.docs;
            for (var element in documents) {
              if (element.id == widget.siteCode) {
                var data = element.data() as Map<String, dynamic>;
                nom =data.containsKey("nom")? element.get("nom"):"";
                text =data.containsKey("Text")? element.get("Text"):"";
                List images = data.containsKey("photos")?element.get("photos"):[];
                List stoplist =data.containsKey("Stop")? element.get("Stop"):[];
                for (var i = 0; i <= 23; i++) {
                  if (stoplist.contains(i.toString()) == false) {
                    worklist.add(i.toString());
                  }
                }

                //IDs.add(element.id);
                // for (var i = 0; i < 5; i++) {
                  
                //   var imgRef = data.containsKey("photo$i")
                //       ? element.get("photo$i")
                //       : null;
                //   if (imgRef != null) {
                //     images.add(imgRef);
                //   }
                // }
                widgets.add(SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 250,
                        child: PageView.builder(
                          itemCount: images.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.network(
                                images[index],
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () async{
                                                        List love=data.containsKey("love")? element.get("love"):[];
                                                        print(love);
                                                        if (love.contains("${user!.email!.replaceAll("@oussama.com", "")}")) {
                                                          setState(() async{
                                                            love.remove("${user!.email!.replaceAll("@oussama.com", "")}");
                                                            await _firestore.collection("site").doc("${element.id}").update({"love":love});
                                                          });
                                                        }else{
                                                          setState(() async{
                                                            love.add("${user!.email!.replaceAll("@oussama.com", "")}");
                                                            await _firestore.collection("site").doc("${element.id}").update({"love":love});
                                                          });
                                                        }
                                                      
                                                    },
                            icon:  Icon(data.containsKey("love") && element.get("love").contains("${user!.email!.replaceAll("@oussama.com", "")}")?Icons.star:Icons.star_border_outlined),
                          ),
                          Text(data.containsKey("love")?"${element.get("love").length}":""),
                          const SizedBox(
                            width: 200,
                          ),
                          const Icon(Icons.man),
                          Text(data.containsKey("vol")?"${element.get("vol")}":"")
                        ],
                      ),
                    ],
                  ),
                ));
              }
            }
          }
          var nombreMatches;
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
          
              backgroundColor: const Color.fromARGB(255, 172, 154, 100),
                    title: Text('$nom'),
                  ),
                backgroundColor: Color.fromARGB(255, 200, 189, 156),
                  body: SingleChildScrollView(
                    child: Column(children: [
                      Column(
                        children: widgets,
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: 300,
                        height: 200,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey[200],
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Text(
                          "$text",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
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
                                Text(
                                  AppLocale.localisation.getString(context),
                                  style: const TextStyle(color: Colors.blue),
                                )
                              ],
                            ),
                            onTap: () => _launchMaps(18, -15)
                            ),
                      ),
                      const SizedBox(height: 100),
                      buildSectionTitle(context, AppLocale.reserve.getString(context)),
                      SizedBox(
                        width: 300,
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
                            DateTime? selectedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2100),
                              initialDatePickerMode: DatePickerMode.day,
                            );
                            if (selectedDate != null) {
                              setState(() {
                                String j = getFormattedDate(selectedDate);
                                _textController.text = j;
                                selecteditem="";
                              });
          
                              //d = selectedDate;
                              // يمكن استخدام selectedDate لتحديد السنة المختارة
                            }
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      buildSectionTitle(context, AppLocale.reserveexist.getString(context)),
                      Container(
                        child: Center(
                          child: SizedBox(
                            width: 300,
                            child: StreamBuilder<QuerySnapshot>(
                                stream:
                                    _firestore.collection("matches").snapshots(),
                                builder: (context, snapshot) {
                                  snap=snapshot;
                                  if (snapshot.hasData) {
                                    final documents = snapshot.data!.docs;
                                    for (var element in documents) {
                                      if (element.id.contains("${widget.siteCode},")) {
                                        final Matches = element.data() as Map;
                                        nombreMatches = Matches.length.toInt();
                                        for (var i = 1; i <= nombreMatches; i++) {
                                          var match = element.get("match$i") as Map;
                                          // print(match["date"].toString());
                                          if (match["date"].toString() ==_textController.text && worklist.contains(match["heur"].toString())) {
                                                 worklist.remove(match["heur"].toString());
                                          }
                                        }
                                      }
                                    }
          
                                    return DropdownButtonFormField<String>(
                                        decoration: const InputDecoration(
                                            //border: InputBorder.none,
                                            enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    width: 2, color: Colors.green)),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    width: 2, color: Colors.blue))),
                                        value: selecteditem,
                                        items: worklist
                                            .map((item) => DropdownMenuItem(
                                                value: item,
                                                child: Center(
                                                  child: Text(
                                                    item,
                                                    style: const TextStyle(
                                                        fontSize: 25),
                                                  ),
                                                )))
                                            .toList(),
                                        onChanged: (item) => setState(() {
                                              selecteditem = item;
                                            }));
                                  }
                                  return Text("data");
                                }),
                          ),
                        ),
                      ),
                      mybutton(
                          color: Colors.blue,
                          title: AppLocale.reserveit.getString(context),
                          onPressed: () {
                            if (selecteditem != "" &&
                                _textController.text != '') {
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
                                  //print(user!.email);
                                  if (user != null) {
                                    final text=_textController.text;
                                    final heur=selecteditem;
                                     setState(() {
                                      selecteditem = "";
                                      _textController.text = '';
                                                });
                                    if (snap.hasData) {
                                    final docs = snap.data!.docs;
                                    var n=0;
                                    for (var m in docs) {
                                      if (m.id.contains("${widget.siteCode},${user!.email}")) {
                                       // print(3);
                                        n=n+1;
                                        final Mat=m.data() as Map;
                                        final nbrMat=Mat.length.toInt();
                                        var newDoc = _firestore
                                        .collection("matches")
                                        .doc("${m.id}");
                                        final match = {
                                                        "date": "$text",
                                                        "heur": "$heur"
                                                                        };
                                        await newDoc.update({"match${nbrMat + 1}": match});
                                        
                                        
                                      }
                                      
                                    }
                                    if (n==0) {
                                      final match = {
                                      "date": "$text",
                                      "heur": "$heur"
                                                      };
                                                      var newDoc = _firestore
                                        .collection("matches")
                                        .doc("${widget.siteCode},${user!.email}");
                                        await newDoc.set(
                                        {"match1": match});
          
                                    }
                                   
                                  }
                                    
                                  }
          
                                  // الأكشن الذي يتم تنفيذه عند الضغط على "نعم"
                                } else {
                                  setState(() {
                                    selecteditem = "";
                                    _textController.text = '';
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
                          }),
                      // ElevatedButton(
                      //   onPressed: _requestPermission,
                      //   child: const Text('Enable Location Service'),
                      // ),
                      // ElevatedButton(
                      //   onPressed: () => _launchMaps(37, -122),
                      //   child: const Text('View Map'),
                      // ),
                      const SizedBox(height: 10),
                      StreamBuilder(
                          stream: _firestore.collection("matches").snapshots(),
                          builder: (context, snapshot)  {
                            var  n=0;
                            Map myData = {};
                            double height=0;
                            List data=[];
                            if (snapshot.hasData) {
                              //final List matcheslist=[];
                              final documents = snapshot.data!.docs;
                              
                              for (var element in documents) {
                                if (element.id.contains("${widget.siteCode},${user!.email}")) {
                                  n=n+1;
                                 myData = element.data();
                                 }
                              }
                              if (n!=0) {
                                
                              
                               print(myData);
                              for (var i = 0; i < myData.length; i++) {
                                data.add(myData["match${i+1}"]);
                              }
                              height=73.0*data.length;
                              print(data);
                              //if (data.length>=2) {
                                
                              
                               for (var i = 0; i < data.length; i++) {
                                 for (var j = i; j < data.length; j++) {
                                  if (int.tryParse(data[j]["heur"])!<10 && int.tryParse(data[i]["heur"])!<10) {
                                      if (DateTime.parse("${data[i]["date"]} 0${data[i]["heur"]}:00:00.000").isAfter(DateTime.parse("${data[j]["date"]} 0${data[j]["heur"]}:00:00.000"))) {
                                    final kl=data[i];
                                    data[i]=data[j];
                                    data[j]=kl;
                                  }
                                  }
                                  if (int.tryParse(data[j]["heur"])!<10 && int.tryParse(data[i]["heur"])!>=10) {
                                    if (DateTime.parse("${data[i]["date"]} ${data[i]["heur"]}:00:00.000").isAfter(DateTime.parse("${data[j]["date"]} 0${data[j]["heur"]}:00:00.000"))) {
                                    final kl=data[i];
                                    data[i]=data[j];
                                    data[j]=kl;
                                  }
                                  }
                                  if (int.tryParse(data[j]["heur"])!>=10 && int.tryParse(data[i]["heur"])!<10) {
                                    if (DateTime.parse("${data[i]["date"]} 0${data[i]["heur"]}:00:00.000").isAfter(DateTime.parse("${data[j]["date"]} ${data[j]["heur"]}:00:00.000"))) {
                                    final kl=data[i];
                                    data[i]=data[j];
                                    data[j]=kl;
                                  }
                                  }
                                  if (int.tryParse(data[j]["heur"])!>=10 && int.tryParse(data[i]["heur"])!>=10) {
                                    if (DateTime.parse("${data[i]["date"]} ${data[i]["heur"]}:00:00.000").isAfter(DateTime.parse("${data[j]["date"]} ${data[i]["heur"]}:00:00.000"))) {
                                    final kl=data[i];
                                    data[i]=data[j];
                                    data[j]=kl;
                                  }
                                  }
                                }
                              }}
                              //}
                              
                            }
                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: Colors.red)),
                                    height: height,
                                    width: 200,
                                    // child: Text(""),
                                    child: Visibility(
                                      visible: n==0?false:true,
                                      child: ListView.builder(
                                        itemCount: data.length,
                                        itemBuilder: (context, index) {
                                          return ListTile(
                                            title: Text(data[index]["date"]
                                                .toString()),
                                            subtitle: Text("${data[index]
                                                ["heur"]}h:00mn"
                                              .toString()),
                                            leading: IconButton(onPressed: (){
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
                                              if (snapshot.hasData) {
                                              final documents = snapshot.data!.docs;
                                              for (var element in documents) {
                                                if (element.id.contains("${widget.siteCode},${user!.email}")) {
                                                  final de=element.data();
                                                  final d=de.length;
                                                  for (var i = 1; i <= d; i++) {
                                                    if (de["match$i"]["date"]==data[index]["date"] && de["match$i"]["heur"]==data[index]["heur"] ) {
                                                      for (var j = i; j < d; j++) {
                                                         _firestore.collection("matches").doc("${element.id}").update({"match$j":de["match${j+1}"]});
                                                      }
                                                       _firestore.collection("matches").doc("${element.id}").update({"match$d":FieldValue.delete()});
                                                    }
                                                  }
                                                }
                                                
                                              }}}});
                                    
                                            }, icon: Icon(Icons.delete)),
                                              
                                           
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }),
                          const SizedBox(height: 150),
                    ]),
                  ));
            }
          );
        });
  }

  Future<void> _launchMaps(double lat, double lng) async {
    String url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
    final String encodedURL = Uri.encodeFull(url);
    if (await canLaunch(encodedURL)) {
      await launch(encodedURL);
    } else {
      print(encodedURL);
      throw 'Could not launch $url';
    }
  }

  Future<void> _requestPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
    ].request();
    if (statuses[Permission.location] == PermissionStatus.denied) {
      // لم يتم السماح للتطبيق بالوصول إلى الموقع
      // يمكن إظهار رسالة خطأ للمستخدم هنا.
    } else {
      getLocation();
    }
    // السماح للتطبيق بالوصول إلى الموقع تم بنجاح
    // يمكن استخدام حزمة geolocator الآن للوصول إلى الموقع
  }
}
