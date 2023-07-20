import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WalletPageTopupsTab extends StatelessWidget {
  // const WalletPageTopupsTab({super.key});

  late TabController _tabController;

  final TextEditingController _AmtPaidController = TextEditingController();

  final TextEditingController _UpiIdController = TextEditingController();

  final TextEditingController _UTRNoController = TextEditingController();

  final TextEditingController _PhNumberController = TextEditingController();

  var collWalletTopupsRef =
      FirebaseFirestore.instance.collection("collWalletTopups");

  // Function to write data to Firestore when the "Save" button is pressed
  Future<void> _saveData() async {
    // try {
    // Get the values from the input fields
    // final String varUsername = _usernameController.text;
    String varAmtPaid = _AmtPaidController.text;
    // String varTopupStatus = _TopupStatusController.text;
    String varUTRNo = _UTRNoController.text;
    String varUpiId = _UpiIdController.text;
    String varPhNumber = _PhNumberController.text;

    // final docSnapshot = await docRef.get();
    // print('docSnapshot data: ${docSnapshot.data()}');

    //To-be-added-to-Investments-Array-Firebase

    Map<String, dynamic> newPayment = {
      'keyAmtPaid': varAmtPaid,
      'keyTopUpStatus': "Pending",
      'keyUpiId': varUpiId,
      'keyUTRNo': varUTRNo,
      'keyPhNumber': varPhNumber,
      'keyTimeAndDate': DateTime.now(),
    };
//Replace-EmailId-with-SharedPreference-EmailId
//Check-if-there-is-data-or-not
    // collWalletTopupsRef.doc("sri@0pt.in").set(newPayment);
    SharedPreferences sharedEmailId = await SharedPreferences.getInstance();
    await collWalletTopupsRef
        .doc(sharedEmailId.getString('signedInUserEmail'))
        .update({
      'keyTopupsArray': FieldValue.arrayUnion([newPayment])
    }).then((value) {
      print('Topup added successfully!');
    }).catchError((error) {
      print('Failed to add Topup: $error');
    });

    _AmtPaidController.clear();
    _UTRNoController.clear();
    _UpiIdController.clear();
    _PhNumberController.clear();

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
          controller: _AmtPaidController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Topup Amount',
          ),
        ).paddingOnly(left: 16.0, right: 16.0),

        TextField(
          controller: _UTRNoController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'UTR Number',
          ),
        ).paddingOnly(left: 16.0, right: 16.0),

        TextField(
          controller: _PhNumberController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Phone Number',
          ),
        ).paddingOnly(left: 16.0, right: 16.0, bottom: 16.0),

        ElevatedButton(
          onPressed: () {
            _saveData();
            // Show a snackbar to indicate that the data was saved successfully
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                showCloseIcon: true,
                closeIconColor: Colors.black87,
                backgroundColor: Colors.greenAccent,
                content: Center(
                    child: Text(
                        style: TextStyle(color: Colors.black87),
                        'Topup initiated')),
              ),
            );
          },
          child: const Text('Request Topup'),
        ).paddingAll(8.0),
        // TextButton(
        //   onPressed: _getDataFromFB,
        //   child: Text("Test ViewData"),
        // )
      ],
    ).marginSymmetric(vertical: 8.0);
  }
}
