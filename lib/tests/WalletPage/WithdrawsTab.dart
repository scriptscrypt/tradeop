import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WalletPageWithdrawsTab extends StatefulWidget {
  @override
  State<WalletPageWithdrawsTab> createState() => _WalletPageWithdrawsTabState();
}

class _WalletPageWithdrawsTabState extends State<WalletPageWithdrawsTab> {
  late TabController _tabController;

  final TextEditingController _AmtWithdrawController = TextEditingController();

  final TextEditingController _UpiIdController = TextEditingController();

  final TextEditingController _UTRNoController = TextEditingController();

  final TextEditingController _PhNumberController = TextEditingController();

  var collWalletwithdrawsRef =
      FirebaseFirestore.instance.collection("collWithdraws");

  // Function to write data to Firestore when the "Save" button is pressed
  Future<void> fnWriteWalletTopup() async {
    // try {
    // Get the values from the input fields
    // final String varUsername = _usernameController.text;
    String varAmtWithdraw = _AmtWithdrawController.text;
    // String varTopupStatus = _TopupStatusController.text;
    String varUpiId = _UpiIdController.text;
    String varPhNumber = _PhNumberController.text;

    // final docSnapshot = await docRef.get();
    // print('docSnapshot data: ${docSnapshot.data()}');

    //To-be-added-to-Investments-Array-Firebase

    Map<String, dynamic> newWithdrawRequest = {
      'keyAmtWithdraw': varAmtWithdraw,
      'keyWithdrawStatus': "Pending",
      'keyUpiId': varUpiId,
      'keyPhNumber': varPhNumber,
      'keyTimeAndDate': DateTime.now(),
    };
//Replace-EmailId-with-SharedPreference-EmailId
//Check-if-there-is-data-or-not
    // collWalletwithdrawsRef.doc("sri@0pt.in").set(newWithdrawRequest);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sharedSignedInMail = prefs.getString('signedInUserEmail');
    await collWalletwithdrawsRef.doc(sharedSignedInMail).update({
      'keyWithdrawsArray': FieldValue.arrayUnion([newWithdrawRequest])
    }).then((value) {
      print('withdraw added successfully!');
    }).catchError((error) {
      print('Failed to add withdraw: $error');
    });

    _AmtWithdrawController.clear();
    _UTRNoController.clear();
    _UpiIdController.clear();
    _PhNumberController.clear();

    // Show a snackbar to indicate that the data was saved successfully
    // ScaffoldMessenger.of(context).showSnackBar(
    //   const SnackBar(
    //     content: Text('withdraw initiated'),
    //   ),
    // );
    // } catch (e) {
    //   // Show an error message if there was a problem saving the data
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(
    //       content: Text('Error: $e'),
    //       backgroundColor: Colors.red,
    //     ),
    //   );
    // }
  }

  var txtBoxWalletAmt;
  // int dBWalletBalance;
  bool insuffWalletBalance = false;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  int stDBWalletBalance = 0;

  Future<void> fnGetUserProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("${prefs.getString("signedInUserEmail")}");

    DocumentSnapshot dbDataSnapshot = await firestore
        .collection("collUsers")
        .doc(prefs.getString('signedInUserEmail'))
        // .doc(argDocumentId)
        .get();

    // List<dynamic> data = dbDataSnapshot.data();
    var dBWalletBalance = dbDataSnapshot['keyWalletBalance'];
    setState(() {
      stDBWalletBalance = dBWalletBalance;
    });
    // print("This is DBREF ${stDBWalletBalance}");

    print("DB WALLET BALANCE - ${dBWalletBalance}");
    // fnDetectWalletBal();
  }

  fnDetectWalletBal() {
    print("In fnDetect ---- ${stDBWalletBalance}");
    stDBWalletBalance < int.parse(txtBoxWalletAmt)
        ? insuffWalletBalance = true
        : insuffWalletBalance = false;
  }

  void initState() {
    fnGetUserProfile;
    super.initState();
    // txtBoxWalletAmt = "";
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      // mainAxisAlignment: MainAxisAlignment.center,
      // crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _UpiIdController,
          decoration: const InputDecoration(
            labelText: 'UPI ID',
          ),
        ).paddingOnly(left: 16.0, right: 16.0),

        TextField(
          controller: _AmtWithdrawController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Withdraw Amount',
          ),
          onChanged: (value) {
            setState(() {
              // stringTxtBoxWalletAmt = _AmtWithdrawController.text;
              txtBoxWalletAmt = _AmtWithdrawController.text;
              // fnDetectWalletBal();
            });

            print(txtBoxWalletAmt);

            print(insuffWalletBalance);
          },
        ).paddingOnly(left: 16.0, right: 16.0),

        TextField(
          controller: _PhNumberController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Phone Number',
          ),
        ).paddingOnly(left: 16.0, right: 16.0),
        ElevatedButton(
          onPressed: insuffWalletBalance
              ? null
              : () {
                  fnWriteWalletTopup().then(
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        showCloseIcon: true,
                        closeIconColor: Colors.black87,
                        backgroundColor: Colors.greenAccent,
                        content: Center(
                            child: Text(
                                style: TextStyle(color: Colors.black87),
                                'Withdraw initiated')),
                      ),
                    ) as FutureOr Function(void value),
                  );
                },
          child: const Text('Request withdraw'),
        ).paddingAll(8.0),
        // TextButton(
        //   onPressed: _getDataFromFB,
        //   child: Text("Test ViewData"),
        // )
      ],
    ).marginSymmetric(vertical: 8.0);
  }
}
