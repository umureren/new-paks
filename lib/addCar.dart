import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


import 'carAddress.dart';

class CarFormPage extends StatefulWidget {
  @override
  _CarFormPageState createState() => _CarFormPageState();
}

class _CarFormPageState extends State<CarFormPage> {
  final formKey = GlobalKey<FormState>();
  late String brand;
  late String model;
  late double price;
  late String type;
  late int year;
  //late String carid;



  void _saveForm() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      // Firestore collection reference
      CollectionReference carsCollection =
          FirebaseFirestore.instance.collection('Cars');

      try {
        // Add new car document to the collection
        await carsCollection.add({
          'brand': brand,
          'model': model,
          'price': price,
          'type': type,
          'year': year,
          //'carid': carid,
        });

        // Success message or navigation to another page
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Success'),
            content:
                Text('araç bilgileri girildi lütfen adres bilgilerini girin'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                  // Optionally navigate to another page
                },
              ),
            ],
          ),
        );
      } catch (e) {
        // Error message
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text('An error occurred while saving the car details.'),
            actions: [
              TextButton(
                child: Text('OK'),
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
        title: Text('Car Form'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Brand'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the brand.';
                  }
                  return null;
                },
                onSaved: (value) {
                  brand = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Model'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the model.';
                  }
                  return null;
                },
                onSaved: (value) {
                  model = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the price.';
                  }
                  return null;
                },
                onSaved: (value) {
                  price = double.parse(value!);
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Type'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the type.';
                  }
                  return null;
                },
                onSaved: (value) {
                  type = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Year'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the year.';
                  }
                  return null;
                },
                onSaved: (value) {
                  year = int.parse(value!);
                  //carid=Uuid();

                },
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                child: Text('Save'),
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    formKey.currentState!.save();
                    _saveForm();

                    /*// Navigate to address page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddressFormPage()),
                    );*/
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
