import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:paks/carDetails.dart';

class CarListPage extends StatelessWidget {
  void updateCarAvailability(
      BuildContext context,
      String carId,
      bool newAvailability,
      ) {
    FirebaseFirestore.instance
        .collectionGroup('cars')
        .where(FieldPath.documentId, isEqualTo: carId)
        .limit(1)
        .get()
        .then((QuerySnapshot<Map<String, dynamic>> querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot<Map<String, dynamic>> carDoc = querySnapshot.docs[0];
        String ownerId = carDoc.reference.parent!.id;
print("OWNERRRRRRRRRRRRRRRR"+ownerId);
        DocumentReference<Map<String, dynamic>> carRef = FirebaseFirestore.instance
            .collection('Users')
            .doc(ownerId)
            .collection('cars')
            .doc(carId);

        carRef.update({'available': newAvailability}).then((_) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Başarılı'),
              content: Text('Araç durumu güncellendi.'),
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
        }).catchError((error) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Hata'),
              content: Text('Araç durumu güncellenirken bir hata oluştu.'),
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
        });
      }
    });
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Araç Listesi'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collectionGroup('cars').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }

          final carDocs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: carDocs.length,
            itemBuilder: (context, index) {
              final carData = carDocs[index].data() as Map<String, dynamic>;
              final brand = carData['marka'];
              final model = carData['model'];
              final price = carData['fiyat'];
              final type = carData['tip'];
              final year = carData['yil'];
              final available = carData['available'];
              final carId = carDocs[index].id;

              return ListTile(
                title: Text('$brand $model'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Fiyat: $price'),
                    Text('Tip: $type'),
                    Text('Yıl: $year'),
                    Text('Available: $available'),
                  ],
                ),
                trailing: ElevatedButton(
                  child: Text('Kirala'),
                  onPressed: () {
                    print("Seçilen aracın ID'si: $carId");

                    // Aracın mevcut durumunu al
                    bool currentAvailability = available;

                    // Yeni durumu hesapla
                    bool newAvailability = !currentAvailability;

                    // Aracın durumunu güncelle
                    updateCarAvailability(context, carId, newAvailability);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CarDetailsPage(carId: carId),
                      ),
                    );
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