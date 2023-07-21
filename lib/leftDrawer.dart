// ignore_for_file: file_names, unnecessary_import, non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// ignore: implementation_imports
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WidLeftDrawer extends StatefulWidget {
  // final int swapPage;
  const WidLeftDrawer({
    super.key,
  });

  @override
  State<WidLeftDrawer> createState() => _WidLeftDrawerState();
}

// ignore: prefer_typing_uninitialized_variables
var sharedSignedInUser;

class _WidLeftDrawerState extends State<WidLeftDrawer> {
  void initState() {
    fnGetSharedPrefs();
    super.initState();
  }

  Future<void> fnGetSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      sharedSignedInUser = prefs.getString('signedInUserEmail');
    });
    print(sharedSignedInUser);
  }

  Future fnLogoutLeftDrawer() async {
    await FirebaseAuth.instance.signOut();
  }

  Future fnChangePwdLeftDrawer() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: sharedSignedInUser.toString())
          .then((value) => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  backgroundColor: Colors.greenAccent,
                  showCloseIcon: true,
                  closeIconColor: Colors.black87,
                  content: Center(
                      child: Text(
                          style: TextStyle(color: Colors.black87),
                          'Sent Password Reset Email')))));
    } catch (e) {
      SnackBar(
          backgroundColor: Colors.redAccent,
          showCloseIcon: true,
          closeIconColor: Colors.black87,
          content: Center(
              child: Text(
                  style: TextStyle(color: Colors.white),
                  "Password reset mail failure - $e")));
      throw ("Password reset mail failure - ${e}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        StreamBuilder<DocumentSnapshot>(
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
                return const Text('Document does not exist');
              }

              final data = snapshot.data!.data() as Map<String, dynamic>;
              // final keyWalletBalance = data['keyWalletBalance'];
              final keyFullName = data['keyFullName'];
              final keyEmail = data['keyEmail'];

              return Column(
                children: [
                  Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.indigo.shade300,
                      ),
                      child: Center(
                        child: Text(
                          style: const TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255)),
                          textScaleFactor: 4,
                          '$keyFullName'.substring(0, 1).toUpperCase(),
                        ),
                      )),
                  Text(textScaleFactor: 1.6, '$keyFullName').paddingAll(8.0),
                  Text(textScaleFactor: 1.6, '$keyEmail').paddingAll(8.0),
                ],
              )
                  .marginSymmetric(
                    horizontal: 8.0,
                    vertical: 32.0,
                  )
                  .paddingSymmetric(
                    horizontal: 8.0,
                    vertical: 8.0,
                  );
            }),
        Column(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextButton.icon(
                  icon: Icon(Icons.password_rounded),
                  label: Text("Change Password"),
                  onPressed: fnChangePwdLeftDrawer,
                ).paddingAll(8.0),
                TextButton.icon(
                  icon: Icon(Icons.logout_rounded),
                  label: Text("Logout"),
                  onPressed: fnLogoutLeftDrawer,
                ).paddingAll(8.0),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                    onPressed: () {},
                    child: const Text(
                      textScaleFactor: 0.8,
                      "Privacy Policy",
                    )),
                TextButton(
                    onPressed: () {},
                    child: const Text(
                      textScaleFactor: 0.8,
                      "Terms and Conditions",
                    )),
              ],
            ),
          ],
        )
      ],
    );
  }
}

// var DrawerTop = Column(
//   // mainAxisAlignment: MainAxisAlignment.start,
//   children: [
//     Column(
//       mainAxisSize: MainAxisSize.max,
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       // crossAxisAlignment: CrossAxisAlignment.end,
//       children: [
//         IconButton(
//           icon: const Icon(Icons.person),
//           iconSize: 56.0,
//           onPressed: () {
//             print("Pressed the Icon");
//           },
//         ),
//         Text(sharedSignedInUser),
//       ],
//     ),
//     TextButton(
//       onPressed: () {},
//       child: const Text("View Profile"),
//     ),
//     OutlinedButton(
//       onPressed: () {},
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Icon(
//             Icons.account_balance_wallet_rounded,
//             color: Colors.orange.shade400,
//           ),
//           const Padding(
//             padding: EdgeInsets.all(8.0),
//             child: Text("Add Money"),
//           ),
//         ],
//       ),
//     ),
//   ],
// );

//Auth-Functions:

