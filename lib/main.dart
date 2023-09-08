
import 'dart:ui';

import 'package:first_app/screens/image.dart';
import 'package:first_app/screens/map.dart';
import 'package:first_app/screens/translate.dart';

import 'package:flutter/material.dart';
import 'screens/0.dart';
import 'screens/1.dart';
import 'screens/2.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localization/flutter_localization.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp( const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  final FlutterLocalization localization = FlutterLocalization.instance;
  @override
void initState() {
    localization.init(
        mapLocales: [
            const MapLocale('en', AppLocale.EN),
            const MapLocale('ar', AppLocale.AR),
            const MapLocale('fr', AppLocale.FR),
        ],
        initLanguageCode: '${localization.currentLocale}',
    );
    localization.onTranslatedLanguage = _onTranslatedLanguage;
    super.initState();
}

// the setState function here is a must to add
void _onTranslatedLanguage(Locale? locale) {
    setState((
    
    ) {
    });
}

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: localization.currentLocale,
      supportedLocales: localization.supportedLocales,
      localizationsDelegates: localization.localizationsDelegates,
      title: 'Matchi',
      theme: ThemeData(
        //primarySwatch: Colors.blue,


          primarySwatch: Colors.blue,
          hintColor: Color.fromARGB(255, 56, 54, 47),
          fontFamily: 'ElMessiri',
          textTheme: ThemeData.light().textTheme.copyWith(
                headlineSmall: const TextStyle(
                  color: Colors.blue,
                  fontSize: 24,
                  fontFamily: 'ElMessiri',
                  fontWeight: FontWeight.bold,
                ),
                titleLarge: const TextStyle(
                  color: Colors.black,
                  fontSize: 26,
                  fontFamily: 'ElMessiri',
                  fontWeight: FontWeight.bold,
                ),
              )),

      
      //home: welcomescreen(),
      initialRoute: welcomescreen.screenRoute,
      routes: {
        welcomescreen.screenRoute:(context) => const welcomescreen(),
        R.screenRoute:(context) => const R(),
        S.screenRoute:(context) => const S(),
        // accueil.screenRoute:(context) =>  accueil(),
        // site.screenRoute:(context) =>  site(),
        //mod.screenRoute:(context) =>  const mod(),
        MapPage.screenRoute:(context) => const MapPage(),
        //check.screenRoute:(context) => check(),
        MyImageScreen.screenRoute:(context) => const MyImageScreen(),
        //profil.screenRoute:(context) => profil(),
        //LoginScreen.screenRoute:(context) =>  LoginScreen(),
        //OTPScreen.screenRoute:(context) =>  OTPScreen(),
        //Home.screenRoute:(context) =>  Home(),

      }
    );
  }
}