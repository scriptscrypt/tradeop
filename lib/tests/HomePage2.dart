//Working-Timer-set-to-call-the-function

// -----------------------------------------------------------------------------

import 'dart:async'; //For-timer-function
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomePage2 extends StatefulWidget {
  final String sheetName;

  const HomePage2({Key? key, required this.sheetName}) : super(key: key);

  @override
  _HomePage2State createState() => _HomePage2State();
}

class _HomePage2State extends State<HomePage2> {
  List<List<dynamic>>? _data;
  late Stream<List<List<dynamic>>> _stream;

  StreamController<List<List<dynamic>>> controller =
      StreamController<List<List<dynamic>>>.broadcast();
  Stream<List<dynamic>> _getData() async* {
    // final String spreadsheetId = "1xCl8tDCpc_teLMF628ZFl79EIEraDI1qIGN_NLCHDE8";
    final String spreadsheetId = "1-XUN31OppILOCh_zpkdiK0m3Qs3pRIDFkwK9hnOuC4M";
    final String apiKey = "AIzaSyDUuLASGb3o-HP0fpHUg0VpQYC7indkv-U";
    final String sheetName = widget.sheetName;
    final String range = "A:L";
    final String majorDimension = "ROWS";
    final String url =
        "https://sheets.googleapis.com/v4/spreadsheets/$spreadsheetId/values/$sheetName!$range?majorDimension=$majorDimension&key=$apiKey";
    final response = await http.get(Uri.parse(url));
    // if (response.statusCode == 200) {
    //   final json = jsonDecode(response.body);
    //   final values = json['values'];
    //   if (values.length > 0 && values[0] is List) {
    //     setState(() {
    //       _data = values.cast<List<dynamic>>();
    //     });
    //   } else if (values.length > 0) {
    //     setState(() {
    //       _data = [values.cast<dynamic>()];
    //     });
    //   }
    // } else {
    //   print("Failed to load data from Google Sheets API");
    // }
    // final response = await http.get(Uri.parse(url));
    // List<dynamic> data = jsonDecode(response.body);
    // List<List<dynamic>> modifiedData = processData(data);
    // controller.add(modifiedData);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final values = json['values'];
      if (values.length > 0 && values[0] is List) {
        yield* values;
      }
    }
    // return [];
  }

  bool _isToday(String dateString) {
    final today = DateTime.now();
    final date = DateTime.parse(dateString);
    return date.year == today.year &&
        date.month == today.month &&
        date.day == today.day;
  }

  @override
  void initState() {
    super.initState();
    _stream = (_getData() as Stream<List<List<dynamic>>>?)!;
  }
  // @override
  // void initState() {
  //   super.initState();
  //   _getData();
  // }

  // Timer? _timer;

  // @override
  // void initState() {
  //   super.initState();
  //   // _startTimer();
  // }

  // @override
  // void dispose() {
  //   _stopTimer();
  //   super.dispose();
  // }

  // void _startTimer() {
  //   const fiveMinutes = Duration(seconds: 1);
  //   _timer = Timer.periodic(fiveMinutes, (timer) {
  //     _getData();
  //   });
  // }

  // void _stopTimer() {
  //   _timer?.cancel();
  //   _timer = null;
  // }

  @override
  Widget build(BuildContext context) {
    // return StreamBuilder(
    //     stream: _getData(),
    //     builder:
    //         // _data == null
    //         //     ? const Center(
    //         //         child: CircularProgressIndicator(),
    //         //       )
    //         // :
    return StreamBuilder<List<dynamic>>(
        stream: _stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!;
            return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  var row = _data![index];
                  var sheetDate = row[0];
                  var sheetMatchNo = row[1];
                  var sheetHomeTeam = row[2];
                  var sheetAwayTeam = row[3];
                  var sheetStadium = row[4];
                  var sheetCity = row[5];
                  var sheetState = row[6];
                  var sheetYesOdds = row[7];
                  var sheetNoOdds = row[8];
                  var sheetGameType = row[9];
                  var sheetIsMatchLive = row[10];
                  var sheetMatchWinner = row[11];
                  if (_isToday(sheetDate)) {
                    return SizedBox(
                      width: MediaQuery.of(context).size.width * 0.72,
                      child: Card(
                        child: Column(
                          children: [
                            Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text("Match ${sheetMatchNo}"),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(sheetIsMatchLive),
                                      ),
                                    ],
                                  ),
                                  Text(sheetGameType),
                                ])
                                .marginSymmetric(
                                    horizontal: 16.0, vertical: 16.0)
                                .paddingSymmetric(
                                    horizontal: 8.0, vertical: 8.0),
                            //End-of-line-1
                            Text(
                                textScaleFactor: 2,
                                "${sheetHomeTeam} vs ${sheetAwayTeam}"),
                            Text("Will ${sheetHomeTeam} win the ${sheetGameType} against ${sheetAwayTeam} at the ${sheetStadium}stadium tonight?")
                                .marginSymmetric(
                                    horizontal: 16.0, vertical: 16.0)
                                .paddingSymmetric(
                                    horizontal: 8.0, vertical: 8.0),
                            // Text(value7)

                            Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                OutlinedButton(
                                  onPressed: () => showModalBottomSheet(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        BottomSheetContent(
                                      propDate: sheetDate,
                                      propMatchNo: sheetMatchNo,
                                      propBidOn: "Yes",
                                      propBidOnPrice: sheetYesOdds,
                                      propGameType: sheetGameType,
                                      propIsMatchLive: sheetIsMatchLive,
                                      propMatchWinner: sheetMatchWinner,
                                    ),
                                  ),
                                  child: Container(
                                    width: 80,
                                    child: Center(
                                      child: Text(
                                          style: TextStyle(
                                              color: Colors.green.shade400),
                                          "Yes ₹${sheetYesOdds}"),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: OutlinedButton(
                                    onPressed: () => showModalBottomSheet(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          BottomSheetContent(
                                        propDate: sheetDate,
                                        propMatchNo: sheetMatchNo,
                                        propBidOn: "No",
                                        propBidOnPrice: sheetNoOdds,
                                        propGameType: sheetGameType,
                                        propIsMatchLive: sheetIsMatchLive,
                                        propMatchWinner: sheetMatchWinner,
                                      ),
                                    ),
                                    // style: ButtonStyle(
                                    //   backgroundColor:
                                    //       MaterialStateProperty.all<Color>(
                                    //           Colors.red.shade100),
                                    // ),
                                    child: Container(
                                        width: 80,
                                        child: Center(
                                          child: Text(
                                              style: TextStyle(
                                                  color: Colors.red.shade400),
                                              "No ₹${sheetNoOdds}"),
                                        )),
                                  ),
                                )
                              ],
                            )
                                .marginSymmetric(horizontal: 8.0, vertical: 8.0)
                                .paddingSymmetric(
                                    horizontal: 8.0, vertical: 8.0),
                          ],
                        ),
                      ).marginSymmetric(horizontal: 16.0, vertical: 16.0),
                    ).paddingSymmetric(horizontal: 8.0, vertical: 8.0);
                  } else {
                    //Check-for-all-rows-in-sheet
                    return Text("");
                  }
                });
          }
          return (const Text("No Matches found"));
        });
  }
}

//Write-from-this-class-to-firebase:
//Next-task:Write-data-returned-from-sheets-to-FB
//-------------------------------------------------------------------
class BottomSheetContent extends StatefulWidget {
  var propDate,
      propMatchNo,
      propCurrentNo,
      propBidOn,
      propBidOnPrice,
      propGameType,
      propIsMatchLive,
      propMatchWinner;

  BottomSheetContent({
    super.key,
    this.propDate,
    required this.propMatchNo,
    this.propBidOn,
    this.propBidOnPrice,
    this.propCurrentNo,
    this.propGameType,
    this.propIsMatchLive,
    this.propMatchWinner,
  });

  @override
  State<BottomSheetContent> createState() => _BottomSheetContentState();
}

class _BottomSheetContentState extends State<BottomSheetContent> {
  TextEditingController controlAmt = TextEditingController();
  //Variables-declarations:
  bool insuffBalance = false;
  String? sharedSignedInUser;
  var txtBoxAmt;
//Checks-if-there-is-any-change-in-the-widget

  Future fnGetSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // setState(() {
    sharedSignedInUser = prefs.getString('signedInUserEmail')!;
    // });

    txtBoxAmt = controlAmt.text;
    print("SharedPref in HomePage2 is - ${sharedSignedInUser}");
    fnGetUserProfile(sharedSignedInUser);
  }
//----------------22March2023-------------------------------------------------

//Edit-on-22March2023
  // final FirebaseFirestore firestore = FirebaseFirestore.instance;
  // var collUsersRef = firestore.collection("collUsers");
  final CollectionReference collUsersRef =
      FirebaseFirestore.instance.collection("collUsers");
  int stKeyWalletBalance = 0;
  int stKeyTotalInvestment = 0;

  // late int stWalletBalance = 0;
  //late-causes-errors-so,we-initialize-the-value-to-0-and-then-Update-the-UI

  Future fnGetUserProfile(argDocumentId) async {
    print("In fnGetUserProfile - ${sharedSignedInUser}");
    final CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('collUsers');
//I-don't-know-why-sharedSignedInUser-is-showing-up-in-debug-console-but,-not-returning-value-to-this-function
//Now-working-perfectly-1:06am
//Realization:setState-is-only-to-update-the-UI

    final DocumentSnapshot snapshot =
        await usersCollection.doc(argDocumentId).get();
    if (snapshot.exists) {
      var data = snapshot.data() as Map<String, dynamic>;
      var keyWalletBalance = data['keyWalletBalance'];
      var keyTotalInvestment = data['keyTotalInvestment'];
      var keyEmail = data["keyEmail"];
      print(keyTotalInvestment);
      print(keyEmail);
      setState(() {
        stKeyTotalInvestment = keyTotalInvestment;
        stKeyWalletBalance = keyWalletBalance;
      });
      insuffBalance =
          int.parse(controlAmt.text) > stKeyWalletBalance ? true : false;
    } else {
      print('Document does not exist');
    }
  }
  //----------------22March2023-------------------------------------------------

  var collInvestmentsRef =
      FirebaseFirestore.instance.collection("collInvestments");

  void setControllerValue(argAmt) {
    int setValue = argAmt;
    controlAmt.text = setValue.toString();
    setState(() {
      txtBoxAmt = controlAmt.text;
      fnDetectWalletBalance();
    });
  }

  //Initialize-DB-operations-needed-variables:
  var varBidResult, varUnitsInvested;
  int stPotenWinning = 1;
  //Calculating-the-Units-invested

  Future fnWritetoDB() async {
    print("Writing to DB Start");
    print(stKeyWalletBalance);
    print(int.parse(txtBoxAmt));

    //19Mar2023

    //Decide-Who's-the-Winner
    if (stKeyWalletBalance >= int.parse(txtBoxAmt)) {
      //   Navigator.pop(context);
      //   (widget.propIsMatchLive) == "Live"
      //       ? {
      //           (widget.propBidOn == widget.propMatchWinner)
      //               ? varBidResult = "Won"
      //               : varBidResult = "Lost"
      //         }
      //       : varBidResult = "Pending";
      //This-logic-can-be-used-for-AdminPanel
      setState(() => {
            varUnitsInvested =
                int.parse(txtBoxAmt) / int.parse(widget.propBidOnPrice)
          });

      print(varUnitsInvested);
      //To-be-added-to-Investments-Array-Firebase
      Map<String, dynamic> newInvestment = {
        'keyMatchNo': widget.propMatchNo,
        'keyBidOn': widget.propBidOn,
        'keyBidOnPrice': widget.propBidOnPrice,
        'keyTossOrMatch': widget.propGameType,
        'keyAmtInvested': txtBoxAmt.toString(),
        'keyUnitsInvested': varUnitsInvested,
        //Should-multiply-with-current-Current-Price
        // 'keyAmtReturns': varUnitsInvested * widget.,
        // "keyIsMatchLive": widget.propIsMatchLive,
        'keyAtTradePrice': widget.propBidOnPrice,
        'keyWon': "Success",
        'keyWithdrawRequested': false,
        'keyWithdrawIsPending': false,
        // 'keyWithdrawAmount': ,
        "keyTimeAndDate": DateTime.now()
      };

      await collInvestmentsRef.doc(sharedSignedInUser).update({
        'keyInvestmentsArray': FieldValue.arrayUnion([newInvestment])
      }).then((value) {
        print('Investment added successfully!');
        print("Writing to DB End");
      }).catchError((error) {
        print('Failed to add investment: $error');
      });

      //Update-the-investment-to-collUsers-aswell
      await collUsersRef.doc(sharedSignedInUser).update(
          {"keyTotalInvestment": stKeyTotalInvestment + int.parse(txtBoxAmt)});

      //Update the wallet balance
      await collUsersRef.doc(sharedSignedInUser).update(
          {"keyWalletBalance": stKeyWalletBalance - int.parse(txtBoxAmt)});
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.greenAccent,
        showCloseIcon: true,
        closeIconColor: Colors.black87,
        content: Center(
          child: Text(
            style: TextStyle(color: Colors.black87),
            'Investment Successful',
          ),
        ),
      ));
    } else {
      insuffBalance = true;
      print("Insufficient Balance");
      // Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          showCloseIcon: true,
          backgroundColor: Colors.red.shade300,
          content: Center(child: Text('Insufficient Balance '))));
    }
  }

//Checks-for-changes-in-txtBoxAmt

  fnDetectWalletBalance() {
    stKeyWalletBalance < int.parse(txtBoxAmt)
        ? insuffBalance = true
        : insuffBalance = false;
  }

  fnDetectPotenWinning() {
    setState(() => {
          stPotenWinning = (int.parse(txtBoxAmt) /
              int.parse(widget.propBidOnPrice) *
              10) as int
        });
  }

  @override
  void initState() {
    fnGetSharedPrefs();
    controlAmt.text = "100";

    // setState() {
    //   txtBoxAmt = controlAmt.text;
    // }

    // fnDetectWalletBalance();
    // fnStartTimer();
    // fnDetectWalletBalance();
    super.initState();
  }

  @override
  void dispose() {
    // fnStopTimer();
    super.dispose();
  }

  // Timer? varTimer;
  // void fnStartTimer() {
  //   const timerDuration = Duration(seconds: 1);
  //   varTimer = Timer.periodic(timerDuration, (timer) {
  //     //Function-that-needs-to-be-checked-in-the-stipulated-timer
  //     // fnDetectBalance();
  //   });
  // }

  // void fnStopTimer() {
  //   varTimer?.cancel();
  //   varTimer = null;
  // }

  //Initialization-of-Controller-current-value
  var currVal = 0;
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Center(
          child: Text(
              textScaleFactor: 1.6,
              "Trading on" + " ${widget.propBidOn}".toUpperCase()),
        ),
        TextField(
            controller: controlAmt,
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {
                txtBoxAmt = controlAmt.text;
                fnDetectWalletBalance();
                fnDetectPotenWinning();
              });
              print("WALL BALANCE ONCHANGE - ${txtBoxAmt}");
            }),

        Center(
            child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  if (txtBoxAmt == "") {
                    print("Handing null");
                    setControllerValue(1000);
                  } else {
                    currVal = int.parse(txtBoxAmt) + 1000;
                    setControllerValue(currVal);
                  }
                },
                child: Text("+1000"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  if (txtBoxAmt == "") {
                    print("Handing null");
                    setControllerValue(100);
                  } else {
                    currVal = int.parse(txtBoxAmt) + 100;
                    setControllerValue(currVal);
                  }
                },
                child: Text("+100"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  if (txtBoxAmt == "") {
                    print("Handing null");
                    setControllerValue(10);
                  } else {
                    currVal = int.parse(txtBoxAmt) + 10;
                    setControllerValue(currVal);
                  }
                },
                child: Text("+10"),
              ),
            ),
            // Text(controlAmt.text),
          ],
        )),
        Center(
          child: Text(
              style: TextStyle(color: Colors.red.shade400),
              insuffBalance ? "Insufficient Balance" : ""),
        ).paddingAll(8.0),
        ElevatedButton(
          onPressed: insuffBalance
              ? null
              : () {
                  fnWritetoDB();
                },
          child: Text("Confirm"),
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Wallet Balance ₹${stKeyWalletBalance}"),
            ElevatedButton(
              onPressed: () {
                print("Should Navigate to WalletPage");
              },
              child: Text("Topup Wallet"),
            ),
          ],
        ).marginSymmetric(vertical: 32.0),
        // Text(insuffBalance ? "Insufficient Balance" : ""),

        // Text("Potential Winning ₹${stPotenWinning.toString()}")
      ],
    ).marginAll(32.0);
  }
}
