import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:googleapis/gmail/v1.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:googleapis_auth/googleapis_auth.dart';

import 'package:mime/mime.dart';
import 'package:googleapis/gmail/v1.dart' as gmail;

final _clientId =
    '654923077339-ki80o4jf5ue3vkhjto7db3r2edg6tve5.apps.googleusercontent.com';
final _clientSecret = '<your-client-secret>';

Future<void> sendTestEmail() async {
  final authClient = await clientViaUserConsent(
    ClientId(_clientId, _clientSecret),
    ['https://www.googleapis.com/auth/gmail.send'],
    prompt,
  );
  final gmailApi = GmailApi(authClient);

  // TODO: Create a message and send it using the Gmail API.
}

// Prompt the user to visit the authorization URL and enter the code
Future<String> prompt(String url) async {
  // Display the authorization URL to the user
  print('Please visit the following URL to authorize the application:');
  print(url);

  // Prompt the user to enter the authorization code
  print('Enter the authorization code: ');
  final code = stdin.readLineSync().toString();

  // Return the authorization code
  return code;
}

Future<gmail.Message> createTestEmail() async {
  final body = utf8.encode('Hello World!');
  final contentType = 'text/plain';
  final message = gmail.Message()
    ..raw =
        base64Url.encode(utf8.encode('Content-Type: $contentType\n\n') + body);
  return message;
}

class GmailTest extends StatefulWidget {
  const GmailTest({super.key});

  @override
  State<GmailTest> createState() => _GmailTestState();
}

class _GmailTestState extends State<GmailTest> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: createTestEmail,
      child: Text("Send Mail"),
    );
  }
}
