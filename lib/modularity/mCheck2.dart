import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:http/http.dart' as http;

class mCheck2 extends StatefulWidget {
  mCheck2({super.key});

  @override
  State<mCheck2> createState() => _mCheck2State();
}

class _mCheck2State extends State<mCheck2> {
  List<List<dynamic>> _data = [];
  @override
  void initState() {
    super.initState();
    fnGetDataFromSheets();
  }

  Future<void> fnGetDataFromSheets() async {
    final String spreadsheetId = "1xCl8tDCpc_teLMF628ZFl79EIEraDI1qIGN_NLCHDE8";
    final String apiKey = "AIzaSyDUuLASGb3o-HP0fpHUg0VpQYC7indkv-U";
    final String sheetName = "sheetProfile";
    final String range = "A:D"; // Change this to the range you want to fetch
    final String majorDimension = "COLUMNS";
    final String url =
        "https://sheets.googleapis.com/v4/spreadsheets/$spreadsheetId/values/$sheetName!$range?majorDimension=$majorDimension&key=$apiKey";

    final response = await http.get(Uri.parse(url));
    print("Response from Sheets -" + response.body);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      print("Printing JSON" + json);
      // setState(() {
      return _data = json['values'];

      // });
      print(_data);
    } else {
      print("Failed to load data from Google Sheets API");
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Text("Place2");
  }
}
