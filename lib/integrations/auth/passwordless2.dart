import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class Login2 extends StatefulWidget {
  const Login2({super.key});

  @override
  State<Login2> createState() => _Login2State();
}

class _Login2State extends State<Login2> {
  var acs = ActionCodeSettings(
      // URL you want to redirect back to. The domain (www.example.com) for this
      // URL must be whitelisted in the Firebase Console.
      url: 'https://optradex.page.link/loginTradex',
      // This must be true
      handleCodeInApp: true,
      iOSBundleId: 'com.example.ios',
      androidPackageName: 'com.example.android',
      // installIfNotAvailable
      androidInstallApp: true,
      // minimumVersion
      androidMinimumVersion: '12');

  var emailAuth = 'sri@0pt.in';
  Future<void> fnSendLink() async {
    FirebaseAuth.instance
        .sendSignInLinkToEmail(email: emailAuth, actionCodeSettings: acs)
        .catchError(
            (onError) => print('Error sending email verification $onError'))
        .then((value) => print('Successfully sent email verification'));
  }

  fnGetUserDetails() {
    FirebaseAuth.instance.currentUser?.reload();
    FirebaseAuth.instance.currentUser?.email;
    FirebaseAuth.instance.userChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
  }

  // Future<UserCredential> signInWithEmailLink() async {
  //   final auth = FirebaseAuth.instance;
  //   try {
  //     final result = await auth.signInWithEmailLink(
  //       email: "sri@0pt.in",
  //       emailLink: "https://optradex.page.link/loginTradex",
  //     );

  //     return result;
  //   } catch (e) {
  //     throw FirebaseAuthException(
  //       code: 'email-link-error',
  //       message: 'Error completing sign in with email link: $e',
  //     );
  //   }
  // }

  fnCheckEmailLink() async {
    var emailLink = "https://optradex.page.link/loginTradex";
    // Confirm the link is a sign-in with email link.
    if (FirebaseAuth.instance.isSignInWithEmailLink(emailLink)) {
      try {
        // The client SDK will parse the code from the link for you.
        final userCredential = await FirebaseAuth.instance
            .signInWithEmailLink(email: emailAuth, emailLink: emailLink);

        // var newUserCreated =
        //     FirebaseAuth.instance.signInWithCredential(userCredential);
        var newUserCreated = FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: emailAuth, password: "");
        print(userCredential);
        // You can access the new user via userCredential.user.
        final emailAddress = userCredential.user?.email;
        print(emailAddress);
        print('Successfully signed in with email link!');
      } catch (error) {
        print('Error signing in with email link.');
      }
    }
  }

  var emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      TextField(controller: emailController),
      ElevatedButton(
        onPressed: () {
          fnSendLink();
        },
        child: Text("Send Link"),
      ),
      ElevatedButton(
        onPressed: () => fnGetUserDetails(),
        child: Text("User Details re-check"),
      ),
      ElevatedButton(
        onPressed: () => fnCheckEmailLink(),
        child: Text("Sign In"),
      )
    ]);
  }
}
