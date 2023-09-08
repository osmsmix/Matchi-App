import 'package:first_app/screens/1.dart';
import 'package:first_app/screens/2.dart';
import 'package:flutter/material.dart';
import 'package:first_app/widgets/mybutton.dart';


class welcomescreen extends StatefulWidget {
  static const String screenRoute='0';
  const welcomescreen({super.key});

  @override
  State<welcomescreen> createState() => _welcomescreenState();
}

class _welcomescreenState extends State<welcomescreen> {
  void wait(){
    Future.delayed(Duration(seconds: 4),(){
      Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => S()),
                                  (route) => false);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
          Column(children: [
            SizedBox(
              height: 100,
      
              child: Image.asset('images/logo.png'),),
            const Text('Matchi',
              style: TextStyle(fontSize: 40,fontWeight: FontWeight.w900, color: Colors.black),)
          ],),
          const SizedBox(height: 30,),
          // mybutton(
          //   color: Colors.yellow[900]!,
          //   title: 'Sign in',
          //   onPressed: (){
          //     Navigator.pushNamed(context, S.screenRoute);
          //   },
          // ),
          // mybutton(color: Colors.blue[800]!, title: 'Sign Up', onPressed: (){
          //   Navigator.pushNamed(context, R.screenRoute);
          // })
        ]),
      ),
    );
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    wait();
  }
}

