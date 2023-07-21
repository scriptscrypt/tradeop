// import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/placeholder.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:upi_pay/upi_pay.dart';

// class UpiInt extends StatefulWidget {
//   const UpiInt({super.key});

//   @override
//   State<UpiInt> createState() => _UpiIntState();
// }

// class _UpiIntState extends State<UpiInt> {
//   // Future<void> initiateTransaction() async {
//   // Define the transaction details
//   Future<dynamic> doUpiTransation(ApplicationMeta appMeta) async {
//     final UpiTransactionResponse response = await UpiPay.initiateTransaction(
//       amount: '100.00',
//       app: appMeta.upiApplication,
//       receiverName: 'John Doe',
//       receiverUpiAddress: 'taxilla@ybl',
//       transactionRef: 'UPITXREF0001',
//       transactionNote: 'A UPI Transaction',
//     );
//     print(response.status);
// // }

//     // Launch the UPI app
//     // if (upiUrl != null) {
//     //   await launch(upiUrl);
//     // } else {
//     //   // Handle error
//     // }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//       onPressed: doUpiTransation,
//       child: Text("Pay"),
//     );
//   }

//   launch(UpiTransactionResponse upiUrl) {}
// }
