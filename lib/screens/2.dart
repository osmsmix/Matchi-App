import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_app/screens/4.dart';
import 'package:first_app/screens/profil.dart';
import 'package:first_app/screens/translate.dart';
import 'package:flutter/material.dart';
import 'package:first_app/widgets/mybutton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_localization/flutter_localization.dart';

import '1.dart';

class S extends StatefulWidget {
  static const String screenRoute = '2';

  const S({super.key});

  @override
  State<S> createState() => _SState();
}


class _SState extends State<S> {
  final FlutterLocalization localization = FlutterLocalization.instance;
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  late String email;
  late String password;
  Future<bool> checkIfAccountExists(String email) async {
    try {
      List<String> signInMethods =
          await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
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
                    width: 70,
                    child: DropdownButtonFormField<String>(
                                                    decoration: const InputDecoration(
                                                      //border: InputBorder.none,
                                                      enabledBorder: OutlineInputBorder(
                                                          borderSide: BorderSide(color: Colors.green)),
                                                      focusedBorder: OutlineInputBorder(
                                                          borderSide: BorderSide(color: Colors.blue)),
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
                      const SizedBox(
                        height: 100,
                      ),
                      SizedBox(
                        height: 100,
                        child: Image.asset('images/logo.png'),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      TextField(
                        keyboardType: TextInputType.phone,
                        textAlign: TextAlign.center,
                        onChanged: (value) {
                          email = "${value}@oussama.com";
                        },
                        decoration:  InputDecoration(
                          hintText:AppLocale.emailText.getString(context),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          border:const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.orange,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blue,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      TextField(
                        obscureText: true,
                        textAlign: TextAlign.center,
                        onChanged: (value) {
                          password = value;
                        },
                        decoration:  InputDecoration(
                          hintText: AppLocale.passhint.getString(context),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.orange,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blue,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      mybutton(
                        color: Colors.yellow[800]!,
                        title: AppLocale.Signin.getString(context),
                        onPressed: () async {
                          if (await checkIfAccountExists(email) == true) {
                            try {
                              final user =
                                  await _auth.signInWithEmailAndPassword(
                                      email: email, password: password);

                              var bos = await FirebaseFirestore.instance
                                  .collection("BOSS")
                                  .doc("1")
                                  .get();
                              var boss = bos.data() as Map;

                              //  var bs = await FirebaseFirestore.instance
                              //     .collection("employers")
                              //     .doc("${email.replaceAll("@oussama.com", "")}")
                              //     .get();
                              // var bss = bs.get("sites") as List;
                              

                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => profil(
                                        '$selectedite',
                                          email.replaceAll("@oussama.com", ""),
                                          boss)),
                                  (route) => false);
                              //Navigator.pushNamed(context, site.screenRoute);
                              print(user);
                            } catch (e) {
                              print(e);
                              final nackBar = SnackBar(content: Text("$e"));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(nackBar);
                            }
                          } else {
                            final snackBar = SnackBar(
                                content: Text(
                                    AppLocale.erreur.getString(context)));
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }
                        },
                      ),
                      Center(
                        child: Text(AppLocale.or.getString(context)),
                      ),
                      mybutton(
                          color: Colors.blue[800]!,
                          title: AppLocale.Signup.getString(context),
                          onPressed: () {
                            Navigator.pushNamed(context, R.screenRoute);
                          })
                    ]),
              ),
            ),
          );
        });
  }
  
  
}
