import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddressFormPage extends StatefulWidget {
  @override
  _AddressFormPageState createState() => _AddressFormPageState();
}

class _AddressFormPageState extends State<AddressFormPage> {
  final formKey = GlobalKey<FormState>();
  late String city;
  late String district;
  late String street;
  late String town;

  void _saveForm() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      // Firestore collection references
      CollectionReference carsCollection = FirebaseFirestore.instance
          .collection('Cars');
      CollectionReference addressCollection = carsCollection.doc('CARS_ID')
          .collection('address');

      try {
        // Add new address document to the address collection
        await addressCollection.add({
          'city': city,
          'district': district,
          'street': street,
          'town': town,
        });

        // Success message or navigation to another page
        showDialog(
          context: context,
          builder: (context) =>
              AlertDialog(
                title: Text('Success'),
                content: Text('Address details have been saved.'),
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
          builder: (context) =>
              AlertDialog(
                title: Text('Error'),
                content: Text(
                    'An error occurred while saving the address details.'),
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
        title: Text('Address Form'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'City'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the city.';
                  }
                  return null;
                },
                onSaved: (value) {
                  city = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'District'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the district.';
                  }
                  return null;
                },
                onSaved: (value) {
                  district = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Street'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the street.';
                  }
                  return null;
                },
                onSaved: (value) {
                  street = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Town'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the town.';
                  }
                  return null;
                },
                onSaved: (value) {
                  town = value!;
                },
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                child: Text('Save'),
                onPressed: _saveForm,
              ),
            ],
          ),
        ),
      ),
    );
  }
}