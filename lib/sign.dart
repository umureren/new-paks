

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Eposta ve Şifre Girişi',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
        scaffoldBackgroundColor: Colors.grey,
      ),
      home: EmailPasswordSigninPage(),
    );
  }
}

class EmailPasswordSigninPage extends StatefulWidget {
  @override
  _EmailPasswordSigninPageState createState() =>
      _EmailPasswordSigninPageState();
}

class _EmailPasswordSigninPageState extends State<EmailPasswordSigninPage> {
  final formKey = GlobalKey<FormState>();
  late String _email, _password,_name, _lastname;
  final firebaseAuth = FirebaseAuth.instance;
  final firebaseFirestore = FirebaseFirestore.instance;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Email & Şifre Oluşturunuz'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'E-posta',
                  hintText: 'example@gmail.com',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Lütfen e-posta adresinizi girin.';
                  } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                      .hasMatch(value)) {
                    return 'Lütfen geçerli bir e-posta adresi girin.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _email = value!;
                },
              ),
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Şifre',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Lütfen şifrenizi girin.';
                  } else if (value.length < 6) {
                    return 'Şifreniz en az 6 karakter olmalıdır.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _password = value!;
                },
              ),
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'name',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Lütfen isminizi girin.';
                  } else if (value.length < 6) {
                    return 'isminiz en az 6 karakter olmalıdır.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value!;
                },
              ),
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'lastname',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Lütfen soyisminizi girin.';
                  } else if (value.length < 6) {
                    return 'soyisminiz en az 6 karakter olmalıdır.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _lastname = value!;
                },
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                child: Text('Kayıt Ol'),
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    formKey.currentState!.save();
                    try {
                      var userResult =
                      await firebaseAuth.createUserWithEmailAndPassword(
                          email: _email, password: _password);
                      formKey.currentState!.reset();
                      try{
                        final resultData = await firebaseFirestore.collection("Users").add({
                          "name" : _name,
                          "lastname" : _lastname,
                        });
                      }
                      catch (e) {
                        print(e.toString());
                      }

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              "Kullanici başariyla kaydedildi, lütfen giriş yapınız!"),
                        ),
                      );

                      print(userResult.user!.uid);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EmailPasswordLoginPage()));
                    } catch (e) {
                      print(e.toString());
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
