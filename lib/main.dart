import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foresee/firebase_options.dart';
import 'package:foresee/tests/HomePage2.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:foresee/LoginPage.dart';
import 'package:foresee/dashboardPage.dart';
import 'package:foresee/integrations/Flutter_Upi.dart';
import 'package:foresee/integrations/auth/LoginPageNew.dart';
import 'package:foresee/integrations/auth/passwordless2.dart';
// import 'package:foresee/integrations/firebaseDB.dart';
// import 'package:foresee/landingPage.dart';
import 'package:foresee/leftDrawer.dart';
import 'package:foresee/pages/DashboardPageF.dart';
import 'package:foresee/tests/DashboardTabs.dart';
import 'package:foresee/tests/HomePage.dart';
import 'package:foresee/tests/WalletPage/WalletPage3.dart';
// import 'package:foresee/tests/HomePage2.dart';
import 'package:foresee/tests/WalletPage2.dart';

//For-FB-setup
import "package:firebase_core/firebase_core.dart";

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'foresee',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: const MyHomePage(),
//     );
//   }
// }

//21Mar2023
//Adding-streambuilder-for-auth

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Foresee',
        theme: ThemeData(
          // primarySwatch: Colors.blue,
          primarySwatch: Colors.indigo,
        ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return const MyHomePage();
            } else {
              return const LoginForm();
            }
          },
        ),
        routes: {
          "routeHome": (BuildContext) => HomePage(sheetName: "Sheet1"),
          "routePortfolio": (BuildContext) => DashboardTabs(),
          "routeWallet": (BuildContext) => WalletPage3(),
        });
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //1.from-ChatGPT-For-Custom Drawer
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int varCurrentIndex = 0;
  // // check if keyEmail exists in SharedPreferences
  //From-chat-gpt
  String myString = '';

  @override
  void initState() {
    super.initState();
    // setStringValue();
    // getStringValue();
  }

//From - https://firebase.google.com/docs/auth/flutter/start

//To-be-configured:

// Disable persistence on web platforms. Must be called on initialization:
// final auth = FirebaseAuth.instanceFor(app: Firebase.app(), persistence: Persistence.NONE);
// // To change it after initialization, use `setPersistence()`:
// await auth.setPersistence(Persistence.LOCAL);

  // var op;
  // setStringValue() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   setState(() {n
  //     op = prefs.setString("docIdEmail", "sri@0pt.in");
  //   });
  // }

  final List<Widget> varPagesSwap = [
    HomePage(
      sheetName: 'MatchToday',
    ),
    // HomePage(
    //   sheetName: 'Sheet1',
    // ),
    DashboardTabs(),
    WalletPage3(),
    // UpiInt(),
//index[2]-will-be-Login-Page
    // WalletPage2(),
  ];

  void onTabTapped(int index) {
    print(myString);
    setState(() {
      varCurrentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        //2. Add-Key-ChatGPT
        key: _scaffoldKey,

        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
          // shadowColor: Colors.white,
          elevation: 0,
          surfaceTintColor: Colors.white,
          foregroundColor: Colors.indigo.shade300,
          leading: IconButton(
            icon: const Icon(Icons.account_circle,
                // color: Color.fromARGB(255, 81, 81, 81),
                color: Color.fromRGBO(121, 134, 203, 1)),

            // ),
            // onPressed: () {
            //   Scaffold.of(context).openDrawer();
            // },
            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          ),
          //Nice-color
          centerTitle: true,
          //Logo-to-be-added-here
          // title: Text("Foresee"),
          title: Image.asset(
            "./images/foreseeLogo.jpg",
            width: 32.0, // set the width and height of the image
            height: 32.0,
          ),
        ),

        //3.Add-drawer-ChatGPT
        drawer: const Drawer(
          //Importing-from-file-Menubar.dart
          child: WidLeftDrawer(),
        ),
        body: varPagesSwap[varCurrentIndex],
        bottomNavigationBar: NavigationBar(
          backgroundColor: Colors.white10,
          onDestinationSelected: onTabTapped,
          selectedIndex: varCurrentIndex,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.play_arrow),
              // selectedIcon: ,

              label: "Trade",
            ),
            NavigationDestination(
              icon: Icon(Icons.dashboard_customize_rounded),
              label: "Portfolio",
            ),
            NavigationDestination(
                icon: Icon(Icons.wallet_rounded), label: "Wallet"),
          ],
        ),
      ),
    );
  }
}
