import 'package:flutter/material.dart';
import 'package:paks/rentCar.dart';

import 'addCar.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      title: 'Eposta ve Şifre Girişi',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        scaffoldBackgroundColor: Colors.grey,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget{
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hoşgeldiniz'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Merhaba',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 16),
            SizedBox(
              width: 200,
              height: 60,
              child: ElevatedButton(
                onPressed: () async{
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CarFormPage()));

                },
                child: Text('ARAÇ EKLE'),
              ),
            ),
            SizedBox(height: 16),
            SizedBox(
              width: 200,
              height: 60,
              child: ElevatedButton(
                onPressed: () async{
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CarListPage()));

                },
                child: Text('ARAÇ KİRALA'),
              ),
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Side Bar',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profil'),
              onTap: () {
                // TODO: Profil sayfasına git
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Ayarlar'),
              onTap: () {
                // TODO: Ayarlar sayfasına git
              },
            ),
            ListTile(
              leading: Icon(Icons.notifications),
              title: Text('Bildirimler'),
              onTap: () {
                // TODO: Bildirimler sayfasına git
              },
            ),
            ListTile(
              leading: Icon(Icons.help),
              title: Text('Yardım'),
              onTap: () {
                // TODO: Yardım sayfasına git
              },
            ),
          ],
        ),
      ),
    );
  }

}



