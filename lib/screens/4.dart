
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/screens/3.dart';
import 'package:first_app/screens/translate.dart';
import 'package:flutter/material.dart';
//import 'package:location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_localization/flutter_localization.dart';


Map<String, String> siteNoms = {};

final _firestore = FirebaseFirestore.instance;

class site extends StatefulWidget {
  static const String screenRoute = '4';

  static var phone;
  const site({super.key, required String phone});

  @override
  State<site> createState() => _siteState();
}

class _siteState extends State<site> {
  String? sitenom;
  void getinfo() async {
    print(sitenom);
  }

  Map? info;
  User? user = FirebaseAuth.instance.currentUser;
  final bool _showCalendar = false;
  List<String> itemlist = [""];
  String? selecteditem = "";
  List<String> itelist = [""];
  String? selectedite = "";
  DateTime? d = DateTime.now();
  bool Value = false;
  int love = 0;
  bool v = false;
  List<String> volume=[];
  List<String> cartier=[];

  @override
  Widget build(BuildContext context) {
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
          backgroundColor: Color.fromARGB(255, 200, 189, 156),
            appBar: AppBar(
              backgroundColor: const Color.fromARGB(255, 172, 154, 100),
              actions: [
                Container(
                  width: 200,
                  child: Row(
                            children: [
                              Transform.scale(
                                scale: 0.6,
                                child: Switch(
                                  value: Value,
                                  onChanged: (value) {
                                    setState(() {
                                      getinfo();
                                      if (value==false) {
                                        setState(() {
                                          selectedite="";
                                          selecteditem="";
                                        });
                                      }
                                      Value = value;
                        
                                    });
                                  },
                                ),
                              ),
                               Text(AppLocale.filtrage.getString(context)),
                            ],
                          ),
                ),
                        SizedBox(width: 100,),
                IconButton(
                    onPressed: () {
                      showSearch(context: context, delegate: DataSearch());
                    },
                    icon: Icon(Icons.search))
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                        
                        Visibility(
                          visible: Value,
                          child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: const Color.fromARGB(255, 103, 103, 109))),
                              height: 60,
                              width: 210,
                              child: Row(
                                children: [
                                  // Center(child: Text("Filtrage")),
                                  Transform.scale(
                                    scale: 0.7,
                                    child: 
                                    StreamBuilder<QuerySnapshot>(
                                  stream: _firestore.collection("site").snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      final documents = snapshot.data!.docs;
                                      for (var element in documents) {
                                        var elements=element.data() as Map;
                                        if (elements.containsKey("place")) {
                                          if (itemlist.contains(element.get("place"))==false) {
                                            itemlist.add(element.get("place"));
                                          }
                                        }
                                        
            
                                      }}
                                        return Container(
                                          width: 100,
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
                                  stream: _firestore.collection("site").snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      final documents = snapshot.data!.docs;
                                      for (var element in documents) {
                                        var elements=element.data() as Map;
                                       
                                        if (elements.containsKey("vol")) {
                                          if (itelist.contains(element.get("vol"))==false) {
                                            itelist.add(element.get("vol"));
                                          }
                                        }
            
                                      }}
                                        return Container(
                                          width: 100,
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
                                                    selectedite = item;
                                                  })),
                                        );
                                      }
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          
                        ),
                  Container(
                    height: 500,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          
                          const SizedBox(
                            height: 10,
                          ),
                          StreamBuilder<QuerySnapshot>(
                            stream: _firestore.collection("site").snapshots(),
                            builder: (context, snapshot) {
                              List<Widget> widgets = [];
                              Map<String, String> noms = {};
                              if (snapshot.hasData) {
                                final documents = snapshot.data!.docs;
                                for (var element in documents) {
                                  var data = element.data() as Map;
                                  var nom =data.containsKey("nom") && element.get("nom")!=null? element.get("nom"):"";
                                  noms.update(element.id, (value) => nom,
                                      ifAbsent: () => nom);
                                  var images = data.containsKey("photos")
                                        ? element.get("photos")
                                        : [];
                                  Widget widget = SingleChildScrollView(
                                    child: Visibility(
                                      visible: (selectedite!="" && data.containsKey("vol") && element.get("vol")!=selectedite)|| (selecteditem!="" && data.containsKey("place") && element.get("place")!=selecteditem)?false:true,
                                      child: Column(
                                        children: [
                                          Center(
                                            child: Container(
                                              width: 320,
                                              decoration: BoxDecoration(border: Border.all(width: 1.0),borderRadius: BorderRadius.circular(20)),
                                              
                                              child: Column(
                                                children: [
                                                  InkWell(
                                                    onTap: () async {
                                                              await Navigator.push(
                                                                context as BuildContext,
                                                                MaterialPageRoute(
                                                                    builder: (context) => accueil(
                                                                          siteCode: element.id
                                                                        )),
                                                              );
                                                            },
                                                    child: Text("$nom",style: TextStyle(fontSize: 24),)),
                                                  InkWell(
                                                    onTap: () async {
                                                              await Navigator.push(
                                                                context as BuildContext,
                                                                MaterialPageRoute(
                                                                    builder: (context) => accueil(
                                                                          siteCode: element.id
                                                                        )),
                                                              );
                                                            },
                                                    child: Container(
                                                      decoration: BoxDecoration(border: Border.all(width: 1.0),borderRadius: BorderRadius.circular(15),),
                                                      child: SizedBox(
                                                        width: double.infinity,
                                                        height: 250,
                                                        child: PageView.builder(
                                                          itemCount: images.length,
                                                          itemBuilder: (BuildContext context, int index) {
                                                            return ClipRRect(
                                                                  borderRadius: BorderRadius.circular(15),
                                                                  child: FadeInImage(
                                                                    placeholder: AssetImage(
                                                                        'images/logo.png'), // صورة الاحتياطية التي تظهر أثناء تحميل الصورة
                                                                    image: NetworkImage(images[
                                                                        index]), // رابط الصورة الفعلية
                                                                    fit: BoxFit
                                                                        .cover, // طريقة تغيير حجم الصورة لتناسب العنصر الذي يحتويه
                                                                  ));
                                                          },
                                                        ),
                                                      ),
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
                                                        icon: Icon(data.containsKey("love") && element.get("love").contains("${user!.email!.replaceAll("@oussama.com", "")}")?Icons.star:Icons.star_border_outlined),
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
                                            ),
                                          ),
                                          SizedBox(height: 20,)
                                        ],
                                      ),
                                    ),
                                  );
                                  widgets.add(widget);
                                }
                                siteNoms.addEntries(noms.entries);
                              }
                          
                              return Column(
                                children: widgets,
                              );
                            },
                          ),
                          SizedBox(height: 300,)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ));
      }
    );
  }
}

class DataSearch extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            query = "";
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List names = siteNoms.values.toList();
    List IDs = siteNoms.keys.toList();
    List filternames =
        names.where((element) => element.contains(query)).toList();
    List filterIDs =
        IDs.where((element) => siteNoms[element]!.contains(query)).toList();
    return ListView.builder(
        itemCount: query == "" ? names.length : filternames.length,
        itemBuilder: (context, i) {
          return InkWell(
            onTap: () async{
              await Navigator.push(
                                        context as BuildContext,
                                        MaterialPageRoute(
                                            builder: (context) => accueil(
                                                 siteCode: query == "" ? IDs[i].toString() : filterIDs[i].toString()
                                                )),
                                      );
              // Navigator.pushNamed(context, accueil,
              //     arguments: query == "" ? IDs[i].toString() : filterIDs[i].toString());
              //print(query == "" ? IDs[i] : filterIDs[i]);
              //print(siteNoms);
            },
            child: Container(
                padding: EdgeInsets.all(10),
                child: query == ""
                    ? Text(
                        "${names[i]}",
                        style: TextStyle(fontSize: 25),
                      )
                    : // Text
                    Text(
                        "${filternames[i]}",
                        style: TextStyle(fontSize: 25),
                      )),
          );
        });
  }
}
