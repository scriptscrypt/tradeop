// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tradeop/integrations/auth/functions/authFunctions.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  //Email-to-be-stored-in-Shared-Preference

  var sharedEmail = "";

  String email = '';
  String password = '';
  String fullname = '';
  String phoneNumber = '';
  bool login = false;

// On-state-enter-initialize-Sharedpreferences
  // void initstate() {
  //   super.initState();
  // }

  // fnSetSharedEmail() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  // }
  fnFromModalSendPwdresetEmail() {
    try {
      AuthServices.fnForgotPassword(varTxtBoxEmail, context);
    } catch (e) {
      "Exception caught - ${e}";
    }

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      showCloseIcon: true,
      backgroundColor: Colors.indigo.shade300,
      content: Center(
        child: Text(varTxtBoxEmail == null
            ? "Failed to send Password verification link"
            : "Sent password reset link to ${varTxtBoxEmail}"),
      ),
    ));
  }

  var varTxtBoxEmail;
  TextEditingController cntrlEmailtxtBox = TextEditingController();
  fnForgotPwdModal() {
    print(email);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          width: (MediaQuery.of(context).size.width * 0.88),
          child: AlertDialog(
            title: const Center(
                child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Forgot Password?"),
            )),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      alignLabelWithHint: false,
                      hintText: "Please enter your Email"),
                  controller: cntrlEmailtxtBox,
                  onChanged: (value) {
                    varTxtBoxEmail = cntrlEmailtxtBox.text;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 24.0, 0.0, 8.0),
                  child: ElevatedButton(
                      style: ButtonStyle(
                          elevation: MaterialStateProperty.all(0.0)),
                      onPressed: () {
                        fnFromModalSendPwdresetEmail();
                        Navigator.of(context).pop();
                      },
                      child: const Text("Confirm")),
                ),
              ],
            ),
            // actions: [
            //   ElevatedButton(
            //     child: Text("OK"),
            //     onPressed: () {
            //       Navigator.of(context).pop(); // dismiss the alert dialog
            //     },
            //   ),
            // ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        foregroundColor: Colors.indigo.shade400,
        centerTitle: true,
        // title: const Text('Foresee'),
        title: Image.asset(
          "images/foreseeLogo.jpg",
          width: 32.0, // set the width and height of the image
          height: 32.0,
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                textScaleFactor: 1.8,
                login ? "Login" : "Quick Signup",
              ),
            ).marginAll(8.0).paddingAll(8.0),
            // ======== Full Name ========
            login
                ? Container()
                : TextFormField(
                    key: const ValueKey('fullname'),
                    decoration: const InputDecoration(
                      hintText: 'Full Name',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter fullname';
                      } else {
                        return null;
                      }
                    },
                    onSaved: (value) {
                      setState(() {
                        fullname = value!;
                      });
                    },
                  ),

            // ======== Email ========
            TextFormField(
              key: const ValueKey('email'),
              decoration: const InputDecoration(
                hintText: 'Email',
              ),
              validator: (value) {
                if (value!.isEmpty || !value.contains('@')) {
                  return 'Please enter a valid Email';
                } else {
                  return null;
                }
              },
              onSaved: (value) {
                setState(() {
                  email = value!;
                });
                // fnSetSharedEmail() async {
                //   SharedPreferences prefs =
                //       await SharedPreferences.getInstance();

                //   sharedEmail = prefs.setString("docIdEmail", value!);
                // }
              },
            ),
            // ======== Phone Number ========
            login
                ? Container()
                : TextFormField(
                    key: const ValueKey('phoneNumber'),
                    // obscureText: true,
                    decoration: const InputDecoration(
                      hintText: 'Phone Number',
                    ),
                    validator: (value) {
                      if (value!.length < 9) {
                        return 'Please enter a valid phone number';
                      } else {
                        return null;
                      }
                    },
                    onSaved: (value) {
                      setState(() {
                        phoneNumber = value!;
                      });
                    },
                  ),
            // ======== Password ========
            TextFormField(
              key: const ValueKey('password'),
              obscureText: true,
              decoration: const InputDecoration(
                hintText: 'Password',
              ),
              validator: (value) {
                if (value!.length < 6) {
                  return 'Password must be of atleast 6 characters';
                } else {
                  return null;
                }
              },
              onSaved: (value) {
                setState(() {
                  password = value!;
                });
              },
            ),

            ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        login
                            ? {
                                AuthServices.signinUser(
                                    email, password, context)
                                //Save-User-in-shared-preferences
                              }
                            : AuthServices.signupUser(fullname, email, password,
                                phoneNumber, context);
                      }
                    },
                    child: Text(login ? 'Login' : 'Signup'))
                .marginOnly(top: 16.0),
            login
                ? TextButton(
                    onPressed: () => fnForgotPwdModal(),
                    child: const Text("Forgot Password?"),
                  )
                : const Text(""),
            TextButton(
                onPressed: () {
                  setState(() {
                    login = !login;
                  });
                },
                child: Text(login
                    ? "Don't have an account? Signup"
                    : "Already have an account? Login")),
          ],
        ),
      ).marginAll(16.0).paddingAll(8.0),
    );
  }
}
