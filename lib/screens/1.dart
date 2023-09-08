import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_app/screens/3.dart';
import 'package:flutter/material.dart';
import 'package:first_app/widgets/mybutton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_localization/flutter_localization.dart';

import '2.dart';
import 'otp.dart';


class R extends StatefulWidget {
  static const String screenRoute='1';


  const R({super.key});


  @override
  State<R> createState() => _RState();
}

class _RState extends State<R> {
  final FlutterLocalization localization = FlutterLocalization.instance;
  final _auth = FirebaseAuth.instance;
  final _firestore=FirebaseFirestore.instance;


  late String phone;
  late String password1;
  late String password2;
Future<bool> checkIfAccountExists(String email) async {
  try {
    List<String> signInMethods = await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
    return signInMethods.isNotEmpty;
  } catch (e) {
    print('Error checking account existence: $e');
    return false;
  }
}
  @override
  Widget build(BuildContext context) {

    String deviceLanguageCode = window.locale.languageCode;
    
    String? selectedite= deviceLanguageCode;
    List<String> itelist=["ar","en","fr"];
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
              backgroundColor: Colors.white,
              actions: [ Row(
                children: [
                  SizedBox(
                    width: 50,
                    child: DropdownButton<String>(
                                                    // decoration: const InputDecoration(
                                                    //   //border: InputBorder.none,
                                                    //   enabledBorder: OutlineInputBorder(
                                                    //       borderSide: BorderSide(color: Colors.green)),
                                                    //   focusedBorder: OutlineInputBorder(
                                                    //       borderSide: BorderSide(color: Colors.blue)),
                                                    // ),
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
                                                          localization.translate('$selectedite');
                                                        })),
                  ),
                  const Icon(Icons.language,color: Colors.black,),
                  SizedBox(width: 20,)
                ],
              ),
                                        
              ],),
          backgroundColor: Colors.white,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 100,),
                  SizedBox(
                    height: 100,
                    child: Image.asset('images/logo.png'),
                  ),
                  const SizedBox(height: 50,),
                  TextField(
                    textAlign: TextAlign.center,
                    onChanged: (value){
                      phone = value;
            
                    },
                    decoration: const InputDecoration(
                      hintText: 'Enter your phone number',
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10),
                          ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.orange,
                            width: 1,
                            ),
                          borderRadius: BorderRadius.all(Radius.circular(10),
                          ),
                          ), 
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue,
                            width: 2,
                            ),
                          borderRadius: BorderRadius.all(Radius.circular(10),
                          ),
                          ),                   
                    ),
                  ),
                  const SizedBox(height: 8,),
                  TextField(
                    obscureText: true,
                    textAlign: TextAlign.center,
                    onChanged: (value){
                      password1 = value;
                    },
                    decoration: const InputDecoration(
                      hintText: 'Enter your password',
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10),
                          ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.orange,
                            width: 1,
                            ),
                          borderRadius: BorderRadius.all(Radius.circular(10),
                          ),
                          ), 
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue,
                            width: 2,
                            ),
                          borderRadius: BorderRadius.all(Radius.circular(10),
                          ),
                          ),
                    ),
                  ),
                  const SizedBox(height: 8,),
                  TextField(
                    obscureText: true,
                    textAlign: TextAlign.center,
                    onChanged: (value){
                      password2 = value;
                    },
                    decoration: const InputDecoration(
                      hintText: 'Reenter your password',
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10),
                          ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.orange,
                            width: 1,
                            ),
                          borderRadius: BorderRadius.all(Radius.circular(10),
                          ),
                          ), 
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue,
                            width: 2,
                            ),
                          borderRadius: BorderRadius.all(Radius.circular(10),
                          ),
                          ),
                    ),
                  ),
                  const SizedBox(height: 10,),
                  mybutton(color: Colors.blue[800]!, title: 'Register', onPressed: () async {
                    if (await checkIfAccountExists("${phone}@oussama.com")==false) {
                      
                    
                    
                    try {
                      if (password1==password2) {
                      //   await FirebaseFirestore.instance.collection("Users").doc("$phone");
                      // await FirebaseFirestore.instance.collection("Users").doc("$phone").update({"password":password1});
                      
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => OTPScreen(phone,'$selectedite',password1)));
                  
                      }
                    } catch (e) {
                      print(e);
                    }}else{
                      final snackBar = SnackBar(content: Text('Le numero est existe deja '));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },),
                  Center(child: Text("or"),),
                  mybutton(
                color: Colors.yellow[900]!,
                title: 'Go back to Sign in',
                onPressed: (){
                  Navigator.pushNamed(context, S.screenRoute);
                },
              ),
              
            
                ]
                ),
            ),
          ),
        );
      }
    );
  }
}