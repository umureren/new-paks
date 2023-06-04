import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyCarListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Geçerli kullanıcının UID'sini alın
    User? user = FirebaseAuth.instance.currentUser;
    String? uid = user?.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text('Car List'),
        backgroundColor: Colors.purple,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .doc(uid)
            .collection('cars')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Veriler yüklenirken hata oluştu');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          if (!snapshot.hasData) {
            return Text('Veri bulunamadı');
          }

          // Firestore'dan gelen verileri alın
          List<DocumentSnapshot> documents = snapshot.data!.docs;

          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              // Belge verilerine erişin
              Map<String, dynamic> data = documents[index].data() as Map<String, dynamic>;

              // Verileri kullanarak liste öğelerini oluşturun
              return ListTile(
                title: Text(data['marka']),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Model: ${data['model']}'),
                    Text('Fiyat: ${data['fiyat']}'),
                    Text('Tip: ${data['tip']}'),
                    Text('Yıl: ${data['yil']}'),
                    Text('Available: ${data['available']}'),
                  ],
                ),
                // Diğer verilere göre liste öğesi düzenleyebilirsiniz
              );
            },
          );
        },
      ),
    );
  }
}
