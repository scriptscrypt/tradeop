// ignore_for_file: file_names, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirestoreServices {
  static saveUser(
    String name,
    email,
    phoneNumber,
    uid,
  ) async {
    await FirebaseFirestore.instance.collection('collUsers').doc(email).set({
      'keyEmail': email,
      'keyFullName': name,
      "keyPhNumber": phoneNumber,
      "keyWalletBalance": 50,
      "keyTotalInvestment": 0,
      "keyWithdrawn": 0,
      "keyHasAcceptedPrivacyPolicyAndTermsAndConditions": "Yes",
    });
    await FirebaseFirestore.instance
        .collection("collInvestments")
        .doc(email)
        .set({"keyInvestmentsArray": []});
    await FirebaseFirestore.instance
        .collection("collWalletTopups")
        .doc(email)
        .set({"keyTopupsArray": []});
    await FirebaseFirestore.instance
        .collection("collWithdraws")
        .doc(email)
        .set({"keyWithdrawsArray": []});
//-----------------------------------------------------------------
    //When-User-Logs-in-store-it-in-shared-preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final keySharedEmail = email;
    prefs.setString('signedInUserEmail', keySharedEmail);
  }
}

class AuthServices {
  static signupUser(String name, String email, String password,
      String phoneNumber, BuildContext context) async {
    // ignore: duplicate_ignore
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      await FirebaseAuth.instance.currentUser!.updateDisplayName(name);
      await FirebaseAuth.instance.currentUser!.updateEmail(email);
      await FirestoreServices.saveUser(
        name,
        email,
        phoneNumber,
        userCredential.user!.uid,
      );

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.greenAccent,
          showCloseIcon: true,
          closeIconColor: Colors.black87,
          content: Center(
              child: Text(
                  style: TextStyle(color: Colors.black87),
                  'Registration Successful'))));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.redAccent,
            showCloseIcon: true,
            closeIconColor: Colors.white,
            content: Center(
                child: Text(
                    style: TextStyle(color: Colors.white),
                    'Password Provided is too weak'))));
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.redAccent,
            showCloseIcon: true,
            closeIconColor: Colors.white,
            content: Center(
                child: Text(
                    style: TextStyle(color: Colors.white),
                    'This Email is already registered'))));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.redAccent,
          showCloseIcon: true,
          closeIconColor: Colors.white,
          content: Center(
              child:
                  Text(style: TextStyle(color: Colors.white), e.toString()))));
    }
  }

  static signinUser(String email, String password, BuildContext context) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      //When-User-Logs-in-shareit-in-shared-preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final keySharedEmail = email;
      prefs.setString('signedInUserEmail', keySharedEmail);

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.greenAccent,
          showCloseIcon: true,
          closeIconColor: Colors.black87,
          content: Center(
              child: Text(
                  style: TextStyle(color: Colors.black87),
                  'You are Logged in'))));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.redAccent,
            showCloseIcon: true,
            closeIconColor: Colors.white,
            content: Center(
                child: Text(
                    style: TextStyle(color: Colors.white),
                    'No user Found with this Email'))));
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.redAccent,
            showCloseIcon: true,
            closeIconColor: Colors.white,
            content: Center(
                child: Text(
                    style: TextStyle(color: Colors.white),
                    'Incorrect Password, Try again'))));
      }
    }
  }

  static fnForgotPassword(String email, BuildContext context) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw ("Password reset mail failure - ${e}");
    }
  }
}
