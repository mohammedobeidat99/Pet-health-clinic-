import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pethhealth/components/applocal.dart';
import 'package:pethhealth/constant/color.dart';
import 'package:pethhealth/firebase_options.dart';
import 'package:pethhealth/screen/home/control_page.dart';
import 'package:pethhealth/screen/intro/intro_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform); // Initialize Firebase
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
       //locale: Locale('ar'),
      

      localizationsDelegates: [
        AppLocale.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [Locale('en', ''), Locale('ar', '')],
      localeResolutionCallback: (currentLang, supportLang) {
        if (currentLang != null) {
          for (Locale locale in supportLang) {
            if(locale .languageCode ==currentLang.languageCode){
              return currentLang ;
            }


          }
        }
        return supportLang.first;
      }, //S.delegate.supportedLocales,
      
           // locale: _isArabic ? Locale('ar', '') : Locale('en', ''),

      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: mainColor,
          titleTextStyle: TextStyle(
            color: Colors.white,
          ),
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: mainColor),
        useMaterial3: true,
      ),
      home: Check(),
    );
  }
}

class Check extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    return user != null ? const BottomNavigationExample() : Intro();
  }
}
