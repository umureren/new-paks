import 'package:firebase_auth/firebase_auth.dart';
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
  late String _email, _password, _errorMessage;
  final firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Email & Şifre Girişi'),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(
                      Icons.directions_car,
                      size: 200.0,
                      color: Colors.purple,
                    ),
                    Stack(
                      children: [
                        // Diğer widget'lar
                        Positioned(
                          top: 6, // Dikey konumu belirle
                          left: 120, // Yatay konumu belirle
                          child: Text(
                            'PAKS',
                            style: TextStyle(
                              fontSize: 50.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),

                  ],
                ),
              ),

              SizedBox(height: 32.0),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'E-posta',
                  hintText: 'example@gmail.com',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Lütfen e-posta adresinizi girin.';
                  } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                    return 'Lütfen geçerli bir e-posta adresi girin.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _email = value!;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Şifre',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
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
                style: ElevatedButton.styleFrom(
                  primary: Colors.purple,
                  onPrimary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                ),
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    formKey.currentState!.save();
                    try {
                      final userResult = await firebaseAuth.signInWithEmailAndPassword(
                        email: _email,
                        password: _password,
                      );
                      print(userResult.user!.email! + "\nbaşarılı");

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage()),
                      );
                    } catch (e) {
                      setState(() {
                        _errorMessage = 'Giriş yapılamadı. Lütfen bilgilerinizi kontrol edin.';
                      });
                      print(e.toString());
                      print(_errorMessage);
                    }
                  }
                },
              ),
              SizedBox(height: 8.0),
              ElevatedButton(
                child: Text('Hesap Oluştur'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.grey,
                  onPrimary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                ),
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EmailPasswordSigninPage()),
                  );
                },
              ),
              SizedBox(height: 8.0),
              TextButton(
                child: Text('Şifremi Unuttum'),
                style: TextButton.styleFrom(
                  primary: Colors.purple,
                ),
                onPressed: () async {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
