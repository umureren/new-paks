import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CarListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Araç Listesi'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Cars').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          final cars = snapshot.data!.docs;

          return ListView.builder(
            itemCount: cars.length,
            itemBuilder: (context, index) {
              final car = cars[index].data() as Map<String, dynamic>;
              final brand = car['brand'];
              final model = car['model'];
              final price = car['price'];
              final type = car['type'];
              final year = car['year'];



              return ListTile(
                title: Text('$brand $model'),
                subtitle: Text('Price: $price \nType: $type \nYear: $year'),
                trailing: ElevatedButton(
                  child: Text('Kirala'),
                  onPressed: () {
                    // Kiralama işlemi için gereken kodlar
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
