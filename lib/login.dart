import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:paks/sign.dart';
import 'firebase_options.dart';
import 'home.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Eposta ve Şifre Girişi',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        scaffoldBackgroundColor: Colors.grey,
      ),
      home: EmailPasswordLoginPage(),
    );
  }
}

class EmailPasswordLoginPage extends StatefulWidget {
  @override
  _EmailPasswordLoginPageState createState() => _EmailPasswordLoginPageState();
}

class _EmailPasswordLoginPageState extends State<EmailPasswordLoginPage> {
  final formKey = GlobalKey<FormState>();
  late String _email, _password,_errorMessage;
  final firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Email & Şifre Girişi'),
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
              SizedBox(height: 20.0),
              ElevatedButton(
                child: Text('Giriş Yap'),
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    formKey.currentState!.save();
                    try {
                      final userResult =
                      await firebaseAuth.signInWithEmailAndPassword(
                          email: _email, password: _password);
                      print(userResult.user!.email! + "\nbaşarılı");

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomePage()));
                    }
                    catch (e) {
                      setState(() {
                        _errorMessage = 'Giriş yapılamadı. Lütfen bilgilerinizi kontrol edin.';
                      });
                      print(e.toString());
                      print(_errorMessage);
                    }
                  }

                },
              ),
              ElevatedButton(
                child: Text('Hesap Oluştur'),
                onPressed: () async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EmailPasswordSigninPage()));
                },
              ),
              ElevatedButton(
                  child: Text('şifremi unuttum'),
                  onPressed: () async {

                  })
            ],
          ),
        ),
      ),
    );
  }
}
