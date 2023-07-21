// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseDB extends StatefulWidget {
  const FirebaseDB({Key? key}) : super(key: key);

  @override
  _FirebaseDBState createState() => _FirebaseDBState();
}

class _FirebaseDBState extends State<FirebaseDB> {
  // Define a TextEditingController for each input field
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  // Define a reference to the Firestore collection you want to write to
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('collUsers');
//  print(_usersCollection.find())
  // Function to write data to Firestore when the "Save" button is pressed
  Future<void> _saveData() async {
    try {
      // Get the values from the input fields
      final String varUsername = _usernameController.text;
      final String varEmail = _emailController.text;
      final int varPhNumber = int.parse(_phNumberController.text);

      // Add the values to a new document in the collection
      await _usersCollection.add({
        'keyUsername': varUsername,
        'keyPhNumber': varPhNumber,
        'keyemail': varEmail,
      });

      // Clear the input fields
      _usernameController.clear();
      _emailController.clear();
      _phNumberController.clear();

      // Show a snackbar to indicate that the data was saved successfully
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Saved User'),
        ),
      );
    } catch (e) {
      // Show an error message if there was a problem saving the data
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

//Function-to-fetch-data-from-FBDB
  // _getDataFromFB() {
  //   _usersCollection.get().then((QuerySnapshot snapshot) {
  //     snapshot.docs.forEach((doc) {
  //       print(doc
  //           .data()); // this will print the data from your Firestore collection
  //     });
  //   });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _emailController,
            // keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Email ID',
            ),
          ),
          TextField(
            controller: _usernameController,
            decoration: const InputDecoration(
              labelText: 'Username',
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _phNumberController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Phone Number',
            ),
          ),
          const SizedBox(
            height: 32,
            width: 16,
          ),
          ElevatedButton(
            onPressed: _saveData,
            child: const Text('Login'),
          ),
          // TextButton(
          //   onPressed: _getDataFromFB,
          //   child: Text("Test ViewData"),
          // )
        ],
      ),
    );
  }
}
