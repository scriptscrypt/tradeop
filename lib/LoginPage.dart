// ignore_for_file: file_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:googleapis/cloudsearch/v1.dart';
import "package:shared_preferences/shared_preferences.dart";
import 'package:tradeop/landingPage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  void initState() {
    setState(() {
      var docIdEmail = "";
    });
    super.initState();
  }

  // Define a TextEditingController for each input field
  // final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Define a reference to the Firestore collection you want to write to
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('collUsers');

  // Function to write data to Firestore when the "Save" button is pressed
  Future<void> _saveData() async {
    try {
      // Get the values from the input fields
      // final String varUsername = _usernameController.text;
      final String varEmail = _emailController.text;
      final int varPhNumber = int.parse(_phNumberController.text);
      final String varPassword = _passwordController.text;

      final docRef = _usersCollection.doc(varEmail);
      print(docRef);
      final docSnapshot = await docRef.get();
      print('docSnapshot data: ${docSnapshot.data()}');

      if (docSnapshot.exists) {
        print("User exists");
      } else {
        await docRef.set({
          'keyemail': varEmail,
          'keyPhNumber': varPhNumber,
          'keyPassword': varPassword,
          'keyDateCreated': DateTime.now()
        });

        //Shared-preferences-for-State-management
        // final SharedPreferences varSharedPreferences =
        //     await SharedPreferences.getInstance();
        // varSharedPreferences.setString("docIdEmail", "sri@0pt.in");
        //Go-to-Landing-if-Shared-preference-is-up
        // Get.to(LandingPage());
      }
      // Clear the input fields
      // _usernameController.clear();
      _emailController.clear();
      _phNumberController.clear();
      _passwordController.clear();

      // Show a snackbar to indicate that the data was saved successfully
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
          // TextField(
          //   controller: _usernameController,
          //   decoration: const InputDecoration(
          //     labelText: 'Username',
          //   ),
          // ),
          const SizedBox(height: 16),
          TextField(
            controller: _phNumberController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Phone Number',
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            obscureText: true,
            controller: _passwordController,
            decoration: const InputDecoration(
              labelText: 'Password',
            ),
          ),
          const SizedBox(
            height: 32,
            width: 16,
          ),
          ElevatedButton(
            onPressed: () {
              _saveData;
            },
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
