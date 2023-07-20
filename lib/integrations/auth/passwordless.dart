// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginWithLink extends StatefulWidget {
  const LoginWithLink({super.key});

  @override
  State<LoginWithLink> createState() => _LoginWithLinkState();
}

class _LoginWithLinkState extends State<LoginWithLink> {
  final TextEditingController varControlEmail = TextEditingController();

  Future<void> fnSendLink() async {
    print(varControlEmail.text);
  }

  //Firebase-auth-: https://firebase.google.com/docs/auth/flutter/email-link-auth
  var acs = ActionCodeSettings(
      // URL you want to redirect back to. The domain (www.example.com) for this
      // URL must be whitelisted in the Firebase Console.

//Add-domain-name-here-to-redirect
      url: 'https://optradex.page.link/test',
      // This must be true
      handleCodeInApp: true,
      iOSBundleId: 'com.example.ios',
      androidPackageName: 'com.example.tradex',
      // installIfNotAvailable
      androidInstallApp: true,
      // minimumVersion
      androidMinimumVersion: '10');

  Future<void> fnSendEmail() async {
    final emailAuth = varControlEmail.text;
    await FirebaseAuth.instance
        .sendSignInLinkToEmail(email: emailAuth, actionCodeSettings: acs)
        .catchError(
            (onError) => print('Error sending email verification $onError'))
        .then((value) => print('Successfully sent email verification'));
  }

  fnCheckEmailVerified() {
    final isEmailVerified;
    FirebaseAuth.instance.currentUser!.reload();
    isEmailVerified = FirebaseAuth.instance.currentUser;
    if (isEmailVerified) {
      print("user authenticated");
    }
    print("user Not authenticated");
  }

  // Confirm the link is a sign-in with email link.
  Future<void> fnVerifyEmail() async {
    const emailLink = "https://optradex.page.link/test";
    final emailAuth = varControlEmail.text;
    try {
      if (FirebaseAuth.instance.isSignInWithEmailLink(emailLink)) {
        // The client SDK will parse the code from the link for you.
        print("In Verify Method");
        final userCredential = await FirebaseAuth.instance
            .signInWithEmailLink(email: emailAuth, emailLink: emailLink);
        print(userCredential);
        // You can access the new user via userCredential.user.
        final String? emailAddress = userCredential.user?.email;

        print('Successfully signed in with email link!');
        print(emailAddress);
      }
    } catch (error) {
      print('Error signing in with email link.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Column(children: [
          TextField(
            controller: varControlEmail,
          ),
          ElevatedButton(
            onPressed: fnSendEmail,
            child: const Text('Send Email Link'),
          ),
          ElevatedButton(
            onPressed: fnCheckEmailVerified,
            child: const Text('Veriy Link'),
          ),
        ]),
      ),
    );
  }
}
