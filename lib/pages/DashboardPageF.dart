import 'package:flutter/material.dart';
import 'package:foresee/tests/DashboardTabs.dart';

class DashboardPageF extends StatefulWidget {
  const DashboardPageF({super.key});

  @override
  State<DashboardPageF> createState() => _DashboardPageFState();
}

class _DashboardPageFState extends State<DashboardPageF> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        DashboardPageTop(),
        DashboardTabs(),
      ],
    );
  }
}

class DashboardPageTop extends StatefulWidget {
  const DashboardPageTop({super.key});

  @override
  State<DashboardPageTop> createState() => _DashboardPageTopState();
}

class _DashboardPageTopState extends State<DashboardPageTop> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300.0,
      child: Card(
        child: Row(
          children: [
            Column(
              children: const [
                Text("00000"),
                Text("Total Investments"),
              ],
            ),
            Column(
              children: const [
                Text("00000"),
                Text("Total Returns"),
              ],
            )
          ],
        ),
      ),
    );
  }
}
