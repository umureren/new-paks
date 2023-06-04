import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddAddressPage extends StatefulWidget {
  @override
  _AddAddressPageState createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage> {
  String city = '';
  String district = '';
  String street = '';
  String town = '';

  void saveAddress() async {
    try {
      // "Cars" koleksiyonuna bağlanma
      CollectionReference CarsCollection = FirebaseFirestore.instance
          .collection('Cars');

      // "Cars" koleksiyonundaki en son belgenin ID'sini alma
      QuerySnapshot querySnapshot = await CarsCollection.limit(1).orderBy(
          'timestamp', descending: true).get();
      String lastCarDocumentId = querySnapshot.docs.first.id;

      // En son belgeye ait "address" koleksiyonuna bağlanma
      CollectionReference addressCollection = CarsCollection.doc(
          lastCarDocumentId).collection('address');

      // Yeni adres belgesini Firestore'a ekleme
      await addressCollection.add({
        'city': city,
        'district': district,
        'street': street,
        'town': town,
      });

      // Başarılı bir şekilde kaydedildiğinde kullanıcıya geri bildirim verme
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Başarılı'),
            content: Text('Adres başarıyla kaydedildi.'),
            actions: [
              TextButton(
                child: Text('Tamam'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    } catch (error) {
      print(error.toString());
      // Hata durumunda kullanıcıya hata mesajı gösterme
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Hata'),
            content: Text('Adres kaydedilirken bir hata oluştu.'),
            actions: [
              TextButton(
                child: Text('Tamam'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adres Ekle'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              onChanged: (value) {
                setState(() {
                  city = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Şehir',
              ),
            ),
            TextField(
              onChanged: (value) {
                setState(() {
                  district = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'İlçe',
              ),
            ),
            TextField(
              onChanged: (value) {
                setState(() {
                  street = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Cadde/Sokak',
              ),
            ),
            TextField(
              onChanged: (value) {
                setState(() {
                  town = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Kasaba/Mahalle',
              ),
            ),
            ElevatedButton(
              onPressed: saveAddress,
              child: Text('Kaydet'),
            ),
          ],
        ),
      ),
    );
  }
}