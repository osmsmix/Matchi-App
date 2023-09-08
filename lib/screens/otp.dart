import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/screens/3.dart';
import 'package:first_app/screens/profil.dart';
import 'package:flutter/material.dart';
import 'package:first_app/screens/home.dart';
import 'package:pinput/pinput.dart';

class OTPScreen extends StatefulWidget {
  static const String screenRoute = 'otp';
  final String phone;
  final String lang;
  final String password;
  OTPScreen( this.phone,this.lang,this.password);
  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  String? _verificationCode;
  final TextEditingController _pinPutController = TextEditingController();

  final defaultPinTheme = PinTheme(
    width: 56,
    height: 56,
    textStyle: TextStyle(
        fontSize: 20,
        color: Color.fromRGBO(30, 60, 87, 1),
        fontWeight: FontWeight.w600),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.black),
      borderRadius: BorderRadius.circular(20),
    ),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        title: Text('OTP Verification'),
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 40),
            child: Center(
              child: Text(
                'Verify +222${widget.phone}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Pinput(
              length: 6,
              defaultPinTheme: defaultPinTheme,
              controller: _pinPutController,
              pinAnimationType: PinAnimationType.fade,
              onSubmitted: (pin) async {
                try {
                  await FirebaseAuth.instance
                      .signInWithCredential(PhoneAuthProvider.credential(
                          verificationId: _verificationCode!, smsCode: pin))
                      .then((value) async {
                    if (value.user != null) {
                      try {
                        await FirebaseAuth.instance.createUserWithEmailAndPassword(email: "${widget.phone}@oussama.com", password: widget.password);
                        // var newdoc= await FirebaseFirestore.instance.collection("Users").doc("${widget.phone}@oussama.com");
                        // await newdoc.update({"":""});
                        var bos=  await FirebaseFirestore.instance.collection("BOSS").doc("1").get();
                  var boss=bos.data() as Map;

                  
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => profil("${widget.phone}",widget.lang,boss)),
                          (route) => false);
                      } catch (e) {
                        print(e);
                      }
                      
                    }
                  });
                } catch (e) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(e.toString())));
                }
              },
            ),
          )
        ],
      ),
    );
  }

  _verifyPhone() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+222${widget.phone}',
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance
              .signInWithCredential(credential)
              .then((value) async {
            if (value.user != null) {
              var bos=  await FirebaseFirestore.instance.collection("BOSS").doc("1").get();
                  var boss=bos.data() as Map;
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => profil("${widget.phone}",widget.lang,boss)),
                  (route) => false);
            } 
          });
        },
        verificationFailed: (FirebaseAuthException e) {
          print(e.message);
        },
        codeSent: (String? verficationID, int? resendToken) {
          setState(() {
            _verificationCode = verficationID;
          });
        },
        codeAutoRetrievalTimeout: (String verificationID) {
          setState(() {
            _verificationCode = verificationID;
          });
        },
        timeout: Duration(seconds: 120));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _verifyPhone();
  }
}
