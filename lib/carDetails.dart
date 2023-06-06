import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CarDetailsPage extends StatelessWidget {
  final String carId;

  CarDetailsPage({required this.carId});

  Future<String> getOwnerId() async {
    final carSnapshot = await FirebaseFirestore.instance
        .collection('cars')
        .doc(carId)
        .get();

    final ownerId = carSnapshot.data()!['ownerId'];
    return ownerId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Araç Detayları'),
      ),
      body: FutureBuilder<String>(
        future: getOwnerId(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Hata: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return Center(child: Text('Veri bulunamadı'));
          }

          final ownerId = snapshot.data!;

          return Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Üst Koleksiyon Döküman ID: $ownerId',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          );
        },
      ),
    );
  }
}
