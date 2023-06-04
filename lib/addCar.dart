import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'carAddress.dart';

class CarFormPage extends StatefulWidget {
  @override
  _CarFormPageState createState() => _CarFormPageState();
}

class _CarFormPageState extends State<CarFormPage> {
  final formKey = GlobalKey<FormState>();
  late String marka;
  late String model;
  late double fiyat;
  late String tip;
  late int yil;
  late bool available = false;
  void _saveForm(String uid) async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      // Firestore referansı
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Kullanıcının UID'sine sahip doküman referansı
      DocumentReference userDocRef = firestore.collection('Users').doc(uid);

      try {
        // "cars" koleksiyonunu kullanıcının UID'sine sahip dokümana ekle
        DocumentReference carDocRef = await userDocRef.collection('cars').add({
          'marka': marka,
          'model': model,
          'fiyat': fiyat,
          'tip': tip,
          'yil': yil,
          'available': available,
        });

        // Araç referans ID'sini alın
        String carId = carDocRef.id;

        // Başarı iletişi veya başka bir sayfaya yönlendirme
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Başarılı'),
            content: Text('Araba detayları eklendi. Araç Referans ID: $carId'),
            actions: [
              TextButton(
                child: Text('Tamam'),
                onPressed: () {
                  Navigator.of(context).pop();
                  // İsteğe bağlı olarak başka bir sayfaya yönlendirme yapabilirsiniz
                },
              ),
            ],
          ),
        );
      } catch (e) {
        // Hata iletişi
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Hata'),
            content: Text('Araba detayları kaydedilirken bir hata oluştu.'),
            actions: [
              TextButton(
                child: Text('Tamam'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      }
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Araç Formu'),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Marka'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Lütfen markayı girin.';
                  }
                  return null;
                },
                onSaved: (value) {
                  marka = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Model'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Lütfen modeli girin.';
                  }
                  return null;
                },
                onSaved: (value) {
                  model = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Fiyat'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Lütfen fiyatı girin.';
                  }
                  return null;
                },
                onSaved: (value) {
                  fiyat = double.parse(value!);
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Tip'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Lütfen tipi girin.';
                  }
                  return null;
                },
                onSaved: (value) {
                  tip = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Yıl'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Lütfen yılı girin.';
                  }
                  return null;
                },
                onSaved: (value) {
                  yil = int.parse(value!);
                },
              ),
              SizedBox(height: 20.0),
              CheckboxListTile(
                title: Text('Kiralama Durumu'),
                value: available,
                onChanged: (value) {
                  setState(() {
                    available = value!;
                  });
                },
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                child: Text('Kaydet'),

                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    formKey.currentState!.save();

                    // Geçerli kullanıcının UID'sini alın
                    User? user = FirebaseAuth.instance.currentUser;
                    String? uid = user?.uid;

                    if (uid != null) {
                      _saveForm(uid);

                      // Adres sayfasına yönlendir
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AddAddressPage()),
                      );
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
