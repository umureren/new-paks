import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Geçerli kullanıcının UID'sini alın
    User? user = FirebaseAuth.instance.currentUser;
    String? uid = user?.uid;
    String? email = user?.email;

    return Scaffold(
      appBar: AppBar(
        title: Text('Profil'),
        backgroundColor: Colors.purple,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .where('uid', isEqualTo: uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Veriler yüklenirken hata oluştu'),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('Veri bulunamadı'),
            );
          }

          // İlk dokümanı alın
          DocumentSnapshot document = snapshot.data!.docs.first;

          // Belge verilerine erişin
          Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;

          if (data == null) {
            return Center(
              child: Text('Veri bulunamadı'),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  child: ListTile(
                    title: Text(
                      'E-posta',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(email ?? ''),
                  ),
                ),
                Card(
                  child: ListTile(
                    title: Text(
                      'Kullanıcı Adı',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(data['name'] ?? ''),
                  ),
                ),
                Card(
                  child: ListTile(
                    title: Text(
                      'Soyadı',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(data['lastname'] ?? ''),
                  ),
                ),
                // Diğer verileri göstermek için buraya ekleyebilirsiniz
              ],
            ),
          );
        },
      ),
    );
  }
}
