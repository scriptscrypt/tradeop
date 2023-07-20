import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get_utils/src/extensions/widget_extensions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:foresee/tests/DashboardTabs.dart';
import 'package:foresee/tests/WalletPage/TopupsTab.dart';
import 'package:foresee/tests/WalletPage/WithdrawsTab.dart';
import 'package:foresee/tests/WalletPage2.dart';

class WalletPage3 extends StatefulWidget {
  const WalletPage3({super.key});

  @override
  State<WalletPage3> createState() => _WalletPage3State();
}

class _WalletPage3State extends State<WalletPage3>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 32.0, right: 32.0),
          child: WalletPage2(),
        ),
        Text(textScaleFactor: 1.6, "Wallet Interaction")
            .marginOnly(left: 8.0, bottom: 16.0)
            .paddingOnly(left: 32.0, right: 32.0),
        Text(
                textScaleFactor: 1,
                "Please make the payment to the following details and then request your topup")
            .marginAll(8.0)
            .paddingOnly(left: 32.0, right: 32.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
                    style: TextStyle(color: Color.fromARGB(255, 64, 64, 64)),
                    textScaleFactor: 1,
                    "iphoenix@axl")
                .marginAll(8.0)
                .paddingOnly(left: 32.0),
            Text(
                    style: TextStyle(
                      color: Colors.deepOrange,
                    ),
                    textScaleFactor: 1,
                    "Foresee Opinion Trade")
                .marginAll(8.0)
                .paddingOnly(right: 32.0),
          ],
        ),
        Container(
          child: TabBar(
            isScrollable: true,
            labelColor: Colors.indigo,
            controller: _tabController,
            tabs: const [
              Tab(text: 'Topups'),
              Tab(text: 'Withdraws'),
            ],
          ),
        ).marginSymmetric(horizontal: 8.0).paddingOnly(left: 32.0, right: 32.0),
        Expanded(
          child: TabBarView(
            // clipBehavior: Clip.hardEdge,
            controller: _tabController,
            children: [
              WalletPageTopupsTab(),
              WalletPageWithdrawsTab(),
            ],
          )
              .marginSymmetric(horizontal: 8.0)
              .paddingOnly(left: 16.0, right: 16.0),
        )
      ],
    );
  }
}
