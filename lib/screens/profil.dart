import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:first_app/screens/4.dart';
import 'package:first_app/screens/translate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import '../widgets/p1.dart';
import '../widgets/p3.dart';
//import '../widgets/p2.dart';

class profil extends StatefulWidget {
  final FlutterLocalization localization = FlutterLocalization.instance;
  final String phone;

  final String lang;
  final Map boss;

   profil(this.lang, this.phone,this.boss, {Key? key}) : super(key: key);
  
  static const String screenRoute = 'profil';
  @override
  State<profil> createState() => _profilState();
}

class _profilState extends State<profil> {
  int index = 0;
  
  late String phone;
  late String lang; // تعريف متغير phone

  List<Widget> pages = [];
  
  

  
  
  @override
  void initState() {
    super.initState();

    phone = widget.phone;
    lang=widget.lang;

    
    // تعيين قيمة phone
    pages = [widget.boss.containsKey("phone") && widget.boss["phone"]==phone? p3(lang: lang, phone: phone):p1(lang: lang, phone: phone),  site(phone: phone)];
    // print(boss);
    
  }

  @override
  Widget build(BuildContext context)  {
    return Scaffold(
      
      body: pages[index],
      bottomNavigationBar: NavigationBar(
          selectedIndex: index,
          onDestinationSelected: (index) => setState(() => this.index = index,),
          height: 60,
          destinations:  [
            NavigationDestination(
                icon: const Icon(Icons.home_outlined),
                selectedIcon: const Icon(Icons.home),
                label: AppLocale.me.getString(context)),
             NavigationDestination(
                icon: const Icon(Icons.list_outlined),
                selectedIcon: const Icon(Icons.list),
                label: AppLocale.stadiums.getString(context))
          ]),
    );
  }
}
