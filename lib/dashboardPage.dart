// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:foresee/leftDrawer.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final CollectionReference collInvestmentsRef =
      FirebaseFirestore.instance.collection('CollInvestments');

  Future<void> fnGetShared() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    sharedSignedInUser = prefs.getString("signedInUserEmail");
    print(sharedSignedInUser);
  }

  void initState() {
    fnGetShared();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: collInvestmentsRef.doc(sharedSignedInUser).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData && snapshot.data!.exists) {
            Map<String, dynamic>? data = snapshot.data!["keyInvestmentsArray"]
                .data() as Map<String, dynamic>?;
            // if (data != null && data.containsKey("keyEmail")) {
            if (data != null) {
              return Column(
                children: [
                  Text('Wallet balance: ${data["keyWalletBalance"]}'),
                  Text('Phone Number: ${data["keyPhNumber"]}'),
                  Text('Investments : ${data["keyPayments"]}'),
                ],
              );
            }
            // if (data != null && data.containsKey("keyPhNumber")) {
            //   return Text('Phone Number: ${data["keyPhNumber"]}');
            // }
          } else {
            return Text('Document does not exist');
          }
        } else {
          return CircularProgressIndicator();
        }
        throw ("Error in builder");
      },
    );
  }
}
