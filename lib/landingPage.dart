// ignore_for_file: file_names
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/container.dart';
// import 'package:flutter/src/widgets/framework.dart';

// // import 'package:tradex/sheets/apiService.dart';
// // import 'package:tradex/sheets/apiview.dart';
// // import "package:tradex/sheets2/fetchFromSheets.dart";
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:tradex/modularity/sheetsSetup.dart';

// // import _getDataFromSheets();

// //For-global-declarations:10Mar2023
// var finalDocIdEmail;

// class LandingPage extends StatefulWidget {
//   LandingPage({super.key});
//   @override
//   State<LandingPage> createState() => _LandingPageState();
// }

// class _LandingPageState extends State<LandingPage> {
// //Future-async-await-for-validation:
//   Future fnGetValidationData() async {
//     final SharedPreferences sharedPreferences =
//         await SharedPreferences.getInstance();
//     var obtainedDocIdEmail = sharedPreferences.getString("docIdEmail");
//     setState(() {
//       finalDocIdEmail = obtainedDocIdEmail;
//     });
//     print(finalDocIdEmail);
//   }

//   var varSheetsData;
//   //Constructor
//   @override
//   void initState() {
//     setState(() {
//       varSheetsData = fnGetDataFromSheets("sheetMatches");
//     });
//     fnFetchMatchDetails();
//   }

//   fnFetchMatchDetails() {
//     var newArr = varSheetsData["values"];
//     print(newArr);
//   }
// }

// Widget build(BuildContext context) {
//   return Padding(
//     padding: const EdgeInsets.all(16.0),
//     child: ListView(
//       children: [
//         // GoogleSheetsDataWidget(),
//         Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Card(
//               child: Container(
//             // decoration: BoxDecoration(
//             //   gradient: LinearGradient(
//             //     begin: Alignment.topCenter,
//             //     // end: Alignment.to,
//             //     colors: [
//             //       Color.fromARGB(255, 160, 178, 231),
//             //       Color.fromARGB(255, 193, 204, 253),
//             //     ],
//             //   ),
//             //   borderRadius: BorderRadius.circular(8.0),
//             // ),
//             child: Padding(
//               padding: const EdgeInsets.all(24.0),
//               child: Column(
//                 // crossAxisAlignment: CrossAxisAlignment.center,

//                 mainAxisSize: MainAxisSize.min,
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: <Widget>[
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: const [
//                       Padding(
//                         padding: EdgeInsets.all(8.0),
//                         child: Icon(Icons.align_vertical_bottom_rounded),
//                       ),
//                       Text(textScaleFactor: 2, "RCB vs CSK"),
//                     ],
//                   ),
//                   const Text("Will RCB beat CSK tonight?"),
//                   const Text(textScaleFactor: 1, "Chinnaswamy"),
//                   const Divider(
//                     color: Colors.grey,
//                     thickness: 0.5,
//                     indent: 40,
//                     endIndent: 40,
//                   ),
//                   Row(
//                     mainAxisSize: MainAxisSize.max,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: ElevatedButton(
//                           child: Text('Yes'),
//                           onPressed: () {
//                             // print("Should handle Yes");

//                             // () {
//                             showModalBottomSheet(
//                               context: context,
//                               builder: (BuildContext context) =>
//                                   BottomSheetContent(),
//                             );
//                             // };
//                           },
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: ElevatedButton(
//                           child: Text('No'),
//                           onPressed: () {
//                             print("Should handle No");
//                             showModalBottomSheet(
//                               context: context,
//                               builder: (BuildContext context) =>
//                                   BottomSheetContent(),
//                             );
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           )),
//         )
//       ],
//     ),
//   );
// }

// class BottomSheetContent extends StatefulWidget {
//   @override
//   State<BottomSheetContent> createState() => _BottomSheetContentState();
// }

// class _BottomSheetContentState extends State<BottomSheetContent> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 300.0,
//       child: Center(
//           child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           Row(
//             mainAxisSize: MainAxisSize.max,
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               Text("Market Price"),
//               Text("\$5"),
//             ],
//           ),
//           Row(
//             mainAxisSize: MainAxisSize.max,
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               Text("Your Investment"),
//               Text("\$5 To be Updated"),
//             ],
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               clsBottomSheetButtons(txtAmount: "10"),
//               clsBottomSheetButtons(txtAmount: "100"),
//               clsBottomSheetButtons(txtAmount: "1000"),
//             ],
//           ),
//           ElevatedButton(
//             onPressed: () {},
//             child: Text("Place Order"),
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               Text("Available Balance \$40"),
//               OutlinedButton(
//                 onPressed: () {},
//                 child: Text("Deposit Money"),
//               ),
//             ],
//           ),
//         ],
//       )),
//     );
//   }
// }

// //custome-class-with-dynamic-input-for-buttons
// class clsBottomSheetButtons extends StatefulWidget {
//   final txtAmount;
//   const clsBottomSheetButtons({super.key, required this.txtAmount});

//   @override
//   State<clsBottomSheetButtons> createState() => _clsBottomSheetButtonsState();
// }

// class _clsBottomSheetButtonsState extends State<clsBottomSheetButtons> {
//   @override
//   Widget build(BuildContext context) {
//     return OutlinedButton(
//       onPressed: () {
//         print(widget.txtAmount);
//         setState(() {});
//       },
//       child: Text("+" + widget.txtAmount),
//     );
//   }
// }
