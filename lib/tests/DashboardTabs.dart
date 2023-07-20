// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:foresee/dashboardPage.dart';
import 'package:foresee/leftDrawer.dart';
import 'package:intl/intl.dart';

class DashboardTabs extends StatefulWidget {
  const DashboardTabs({super.key});

  @override
  _DashboardTabsState createState() => _DashboardTabsState();
}

class _DashboardTabsState extends State<DashboardTabs>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    fnGetSharedPrefs();
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> fnGetSharedPrefs() async {
    SharedPreferences sharedEmailId = await SharedPreferences.getInstance();
    setState(() {
      sharedSignedInUser = sharedEmailId.getString('signedInUserEmail');
    });
    print("SHARED EMAIL ID" + sharedSignedInUser);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('collUsers')
            .doc(sharedSignedInUser)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;
          final keyWalletBalance = data['keyWalletBalance'];
          final keyTotalInvestment = data['keyTotalInvestment'];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Column(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.subject_outlined,
                          color: Colors.indigo.shade300,
                        ).paddingOnly(left: 8.0),
                        Text(
                          style: TextStyle(
                            color: Colors.indigo.shade300,
                            // backgroundColor: Colors.indigo.shade50,
                            // decorationColor: Colors.red,
                          ),
                          "Portfolio",
                        ).paddingOnly(left: 8.0),
                      ],
                    ).paddingOnly(left: 8.0, right: 8.0, top: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                    textScaleFactor: 2,
                                    keyWalletBalance == null
                                        ? "₹0"
                                        : "₹${keyWalletBalance.toString()}")
                                .paddingOnly(left: 8.0, right: 8.0, top: 8.0),
                            Text("Wallet Balance").paddingAll(8.0),
                          ],
                        ).marginAll(8.0).paddingAll(8.0),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                    textScaleFactor: 2,
                                    keyTotalInvestment == null
                                        ? "₹0"
                                        : "₹${keyTotalInvestment.toString()}")
                                .paddingOnly(left: 8.0, right: 8.0, top: 8.0),
                            Text("Investments").paddingAll(8.0),
                          ],
                        ).paddingAll(8.0),
                      ],
                    ).paddingOnly(bottom: 8.0),
                  ],
                ),
              ).marginAll(8.0).paddingAll(8.0),

              // Text(keyWalletBalance),
              //Till-App-Top-part-of-DashboardPage
              Text(
                textScaleFactor: 1.6,
                "Transaction History",
              ).marginAll(8.0).paddingOnly(left: 16.0, right: 8.0),
              Container(
                // width: MediaQuery.of(context).size.width * 0.72,
                child: TabBar(
                  labelColor: Colors.indigo,
                  controller: _tabController,
                  tabs: [
                    Tab(text: 'Investments'),
                    Tab(text: 'Topups'),
                    Tab(text: 'Withdraws'),
                  ],
                ).marginAll(8.0).paddingOnly(left: 16.0, right: 16.0),
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    Center(
                      child: InvestmentsTab(sharedSignedInUser),
                    ),
                    Center(
                      child: TopupsTab(sharedSignedInUser),
                    ),
                    Center(
                      child: DashWithdrawsTab(sharedSignedInUser),
                    ),
                  ],
                ),
              ),
            ],
          ).paddingAll(16.0);
        });
  }
}

class InvestmentsTab extends StatelessWidget {
  final String LoggedInEmail;

  InvestmentsTab(this.LoggedInEmail);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('collInvestments')
            .doc(LoggedInEmail)
            // .collection('keyInvestmentsArray')

            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }

          List<dynamic> payments = snapshot.data!['keyInvestmentsArray'];
          if (payments.length == 0) {
            return const Text("Start Investing !");
          }
          payments.sort(
              (a, b) => b['keyTimeAndDate'].compareTo(a['keyTimeAndDate']));
          return ListView.builder(
            itemCount: payments.length,
            itemBuilder: (context, index) {
              return Container(
                      // color: Colors.white,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(
                            color: Color.fromARGB(255, 220, 220, 220)),
                        color: Colors.white,
                      ),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    //Badges
                                    Container(
                                      padding: EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        color: Colors.indigo.shade200,
                                        borderRadius:
                                            BorderRadius.circular(4.0),
                                      ),
                                      child: Text(
                                        "${payments[index]['keyTossOrMatch']}",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        // color: Colors.indigo.shade300,
                                        // color: Colors.green.shade400,//Final

                                        color:
                                            ("${payments[index]['keyBidOn']}" ==
                                                    "Yes"
                                                ? Colors.green.shade300
                                                : Colors.orange.shade300),
                                        borderRadius:
                                            BorderRadius.circular(4.0),
                                      ),
                                      child: Text(
                                        "${payments[index]['keyBidOn']}",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ).paddingOnly(left: 8.0),
                                    // Text(
                                    //     "${payments[index]['keyTossOrMatch']}"),
                                    // Text(payments[index]['keyBidOn'])
                                  ],
                                ).paddingOnly(
                                    left: 8.0,
                                    right: 8.0,
                                    top: 8.0,
                                    bottom: 8.0),
                                Text("Trade ${payments[index]['keyMatchNo']}")
                                    .paddingOnly(
                                  left: 8.0,
                                  right: 8.0,
                                ),
                                Text(DateFormat('dd MMM yyyy, h:mm a').format(
                                        payments[index]['keyTimeAndDate']
                                            .toDate()))
                                    .paddingAll(8.0),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  textScaleFactor: 1.4,
                                  "₹${payments[index]['keyAmtInvested']}",
                                ).paddingAll(8.0),
                                Text(
                                        style: TextStyle(color: Colors.green),
                                        "${payments[index]['keyWon']}")
                                    .paddingAll(8.0),
                              ],
                            ),
                            // Text(payments[index]['keyTimeAndDate'].toDate().toString()),
                            // Text(payments[index]['keyMatch']),
                          ]).marginAll(8.0).paddingAll(8.0)
                      //padding-has-been-specified-for-around-the-corners
                      // .paddingSymmetric(horizontal: 8.0, vertical: 8.0),
                      )
                  .marginAll(8.0)
                  .paddingAll(8.0);

              //Add-the-fields-in-keyInvestmentsArray-to-here

              // Text(payments[index]['keyWon']),
              // Text(payments[index]['keyTopupStatus']),
            },
          );
        },
      ),
    );
  }
}

// Add DashboardPage() class to this page itself - PENDING

class TopupsTab extends StatelessWidget {
  final String LoggedInEmail;

  TopupsTab(this.LoggedInEmail);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('collWalletTopups')
            .doc(LoggedInEmail)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          // if (!snapshot.hasData) {
          //   return Text("Start adding money to your wallet");
          // }
          List<dynamic> payments = snapshot.data!['keyTopupsArray'];
          if (payments.length == 0) {
            return const Text("Start adding money to your wallet");
          }
          payments.sort(
              (a, b) => b['keyTimeAndDate'].compareTo(a['keyTimeAndDate']));
          return ListView.builder(
            itemCount: payments.length,
            itemBuilder: (context, index) {
              // return Column(children: [
              //   Text((payments[index]['keyTimeAndDate']).toString()),
              //   Text(payments[index]['keyUTRNo']),
              //   Text(payments[index]['keyUpiId']),
              //   Text(payments[index]['keyTopUpStatus']),
              // Text(payments[index]['keyTopupStatus']),
              // ]);
              return (Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: Color.fromARGB(255, 220, 220, 220)),
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(payments[index]['keyUpiId']).paddingOnly(
                            top: 8.0, left: 8.0, right: 8.0, bottom: 8.0),
                        Text(payments[index]['keyUTRNo'])
                            .paddingOnly(left: 8.0, right: 8.0),
                        Text(
                          DateFormat('dd MMM yyyy, h:mm a').format(
                              payments[index]['keyTimeAndDate'].toDate()),
                        ).paddingAll(8.0),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          textScaleFactor: 1.4,
                          "₹${payments[index]['keyAmtPaid']}",
                        ).paddingAll(8.0),
                        Text(payments[index]['keyTopUpStatus']).paddingAll(8.0),
                      ],
                    )
                  ],
                ).marginAll(8.0).paddingAll(8.0),
              )).marginAll(8.0).paddingAll(8.0);
            },
          );
        },
      ),
    );
  }
}

class DashWithdrawsTab extends StatelessWidget {
  final String LoggedInEmail;

  DashWithdrawsTab(this.LoggedInEmail);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('collWithdraws')
            .doc(LoggedInEmail)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          // if (snapshot.hasData) {
          //   return Text("Wallet is empty");
          // }
          List<dynamic> payments = snapshot.data!['keyWithdrawsArray'];
          if (payments.length == 0) {
            return const Text("Wallet is empty");
          }
          //Sorting-to-arrange-in-descending-order
          payments.sort(
              (a, b) => b['keyTimeAndDate'].compareTo(a['keyTimeAndDate']));
          return ListView.builder(
              itemCount: payments.length,
              itemBuilder: (context, index) {
                // return Column(children: [
                //   Text((payments[index]['keyTimeAndDate']).toString()),
                //   Text(payments[index]['keyUpiId']),
                //   // Text(payments[index]['keyTopUpStatus']),
                //   Text(payments[index]['keyAmtWithdraw']),
                // ]);
                return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                              color: Color.fromARGB(255, 220, 220, 220)),
                          color: Colors.white,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(payments[index]['keyUpiId']).paddingOnly(
                                    top: 8.0,
                                    left: 8.0,
                                    right: 8.0,
                                    bottom: 8.0),
                                Text(payments[index]['keyPhNumber'])
                                    .paddingOnly(left: 8.0, right: 8.0),
                                Text(
                                  DateFormat('dd MMM yyyy, h:mm a').format(
                                      payments[index]['keyTimeAndDate']
                                          .toDate()),
                                ).paddingAll(8.0),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  textScaleFactor: 1.4,
                                  "₹${payments[index]['keyAmtWithdraw']}",
                                ).paddingAll(8.0),
                                Text(payments[index]['keyWithdrawStatus'])
                                    .paddingAll(8.0),
                              ],
                            )
                          ],
                        ).marginAll(8.0).paddingAll(8.0))
                    .marginAll(8.0)
                    .paddingAll(8.0);
              });
        },
      ),
    );
  }
}
