import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:paks/sign.dart';
import 'package:paks/utils/customColors.dart';
import 'firebase_options.dart';
import 'home.dart';
import 'login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );


  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      routes: {
        "/loginPage": (context) => EmailPasswordLoginPage(),
        "/loginPage": (context) => EmailPasswordSigninPage(),
        "/loginPage": (context) => HomePage(),
      },
      theme: ThemeData(
        scaffoldBackgroundColor: CustomColors.scaffoldBackgroundColor,
      ),
      home: Scaffold(
        body: EmailPasswordLoginPage(),
      ),
    );
  }
}
/*
Uuid() { // BURAYA BAK*************************
  var uuid = Uuid();
  String carid = uuid.v4();
  return carid;
}*/