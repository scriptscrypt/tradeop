// ignore_for_file: non_constant_identifier_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WalletPage2 extends StatefulWidget {
  const WalletPage2({Key? key}) : super(key: key);

  @override
  _WalletPage2State createState() => _WalletPage2State();
}

class _WalletPage2State extends State<WalletPage2> {
  @override
  void initState() {
    fnGetSharedPrefs();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  var sharedSignedInUser;
  Future<void> fnGetSharedPrefs() async {
    SharedPreferences sharedEmailId = await SharedPreferences.getInstance();
    setState(() {
      sharedSignedInUser = sharedEmailId.getString('signedInUserEmail');
    });
    // print(sharedSignedInUser);
//Add-all-the-functions-here
//on-init-stateit-will-set-the-states-only-to-pass-the-values
    fnGetUserProfile(sharedSignedInUser);
  }

// Define a TextEditingController for each input field
// final TextEditingController _usernameController = TextEditingController();

// Define a reference to the Firestore collection you want to write to
  var collWalletTopupsRef =
      FirebaseFirestore.instance.collection("collWalletTopups");
//New collection WalletTopups-19Mar2023
// var collUsersRef = FirebaseFirestore.instance.collection("collUsers");

//Edit-3
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
// var collUsersRef = firestore.collection("collUsers");

  int stWalletBalance = 0;
  String stUserEmail = "";

// late int stWalletBalance = 0;
//late-causes-errors-so,we-initialize-the-value-to-0-and-then-Update-the-UI
  Future<void> fnGetUserProfile(argDocumentId) async {
    // SharedPreferences sharedEmailId = await SharedPreferences.getInstance();
    DocumentSnapshot dbDataSnapshot = await firestore
        .collection("collUsers")
        // .doc(sharedEmailId.getString('signedInUserEmail'))
        .doc(argDocumentId)
        .get();
    print("This is DBREF ${dbDataSnapshot}");

    // List<dynamic> data = dbDataSnapshot.data();
    setState(() {
      stWalletBalance = dbDataSnapshot['keyWalletBalance'];
    });

    print("WALLET BALANCE - ${stWalletBalance}");
  }

//Function-to-fetch-data-from-FBDB
// _getDataFromFB() {
//   _usersCollection.get().then((QuerySnapshot snapshot) {
//     snapshot.docs.forEach((doc) {
//       print(doc
//           .data()); // this will print the data from your Firestore collection
//     });
//   });

  Future<void> fnLogout() async {
    await FirebaseAuth.instance.signOut();
  }

// fnDeleteSharedPrefs() async {
//   SharedPreferences sharedPreferences =
//       await getSharedPreferences("docIdEmail", Context.MODE_PRIVATE);
//   SharedPreferences.Editor editor = await sharedPreferences.edit();
//   editor.clear();
//   editor.apply();
// }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Center(
        child: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('collUsers')
                .doc(sharedSignedInUser)
                .snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              if (!snapshot.hasData || !snapshot.data!.exists) {
                return const Center(child: CircularProgressIndicator());
              }

              final data = snapshot.data!.data() as Map<String, dynamic>;
              final keyWalletBalance = data['keyWalletBalance'];
              final keyFullName = data['keyFullName'];
              final keyEmail = data['keyEmail'];

              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.indigo.shade300,
                              ),
                              child: Center(
                                child: Text(
                                  style: const TextStyle(
                                      color:
                                          Color.fromARGB(255, 255, 255, 255)),
                                  textScaleFactor: 2,
                                  '$keyFullName'.substring(0, 1).toUpperCase(),
                                ),
                              ))
                          .marginOnly(left: 8.0, right: 8.0)
                          .paddingOnly(left: 8.0, right: 8.0),
                      // Text(textScaleFactor: 1.6, '$keyFullName')
                      // .paddingAll(8.0),
                      // Text(textScaleFactor: 1, '$keyEmail')
                      //     .paddingAll(8.0),
                      // TextButton(
                      //     onPressed: fnLogout,
                      //     child: const Text("Logout")),
                      Card(
                        child: SizedBox(
                          width: 132,
                          height: 112,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(textScaleFactor: 2, '₹$keyWalletBalance')
                                    .paddingOnly(
                                        left: 8.0, right: 8.0, top: 8.0),
                                const Text("Wallet Balance").paddingAll(8.0),
                              ]),
                        ),
                      )
                          .marginOnly(left: 8.0, right: 8.0)
                          .paddingOnly(left: 8.0, right: 8.0),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(textScaleFactor: 1, '$keyEmail'),
                      TextButton(
                          onPressed: fnLogout, child: const Text("Logout")),
                    ],
                  )
                      .marginOnly(left: 8.0, right: 8.0)
                      .paddingOnly(left: 8.0, right: 8.0),
                ],
              );
            }),
      ),
    ]).marginAll(8.0).paddingAll(8.0);
  }
}
