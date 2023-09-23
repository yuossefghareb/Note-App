import 'package:firebase02/addCategory.dart';
import 'package:firebase02/auth/signup.dart';
import 'package:firebase02/components/appStyle.dart';


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'homepage.dart';
import 'auth/login.dart';

import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyApp> {
  @override
  
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('============User is currently signed out!');
      } else {
        print('===============User is signed in!');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(

      
        
        floatingActionButtonTheme: FloatingActionButtonThemeData(
           
            backgroundColor: AppStyle.mainColor),
        primarySwatch: Colors.blue ,
        appBarTheme: AppBarTheme(actionsIconTheme: IconThemeData(color: Colors.black,),titleTextStyle: TextStyle(color: Colors.black)),
        navigationBarTheme: NavigationBarThemeData(backgroundColor: Colors.black)
      ),
      debugShowCheckedModeBanner: false,
      home: (FirebaseAuth.instance.currentUser != null &&
              FirebaseAuth.instance.currentUser!.emailVerified)
          ? HomePage()
          : Login(),
      routes: {
        "signup": (context) => SignUp(),
        "login": (context) => Login(),
        "homePage": (context) => HomePage(),
        "addCat": (context) => AddCat(),
      },
    );
  }
}
