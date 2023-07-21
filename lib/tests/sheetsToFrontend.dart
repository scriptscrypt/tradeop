import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StFrontend extends StatefulWidget {
  const StFrontend({Key? key}) : super(key: key);

  @override
  _StFrontendState createState() => _StFrontendState();
}

class _StFrontendState extends State<StFrontend> {
  List<List<dynamic>> _data = [];
  String keyMatchNo = '';
  String keyHome = '';

  @override
  void initState() {
    fnGetDataFromSheets('sheetMatches').then((json) {
      setState(() {
        _data = json['values'];
        keyMatchNo = _data[0][0].toString();
        keyHome = _data[0][1].toString();
      });
    });
    super.initState();
  }

  Future fnGetDataFromSheets(argSheetName) async {
    print("InSTF:" + keyMatchNo + keyHome);

    final String spreadsheetId = "1xCl8tDCpc_teLMF628ZFl79EIEraDI1qIGN_NLCHDE8";
    final String apiKey = "AIzaSyDUuLASGb3o-HP0fpHUg0VpQYC7indkv-U";
    final String sheetName = argSheetName;
    final String range = "A:E"; // Change this to the range you want to fetch
    final String majorDimension = "ROWS";
    final String url =
        "https://sheets.googleapis.com/v4/spreadsheets/$spreadsheetId/values/$sheetName!$range?majorDimension=$majorDimension&key=$apiKey";
    final response = await http.get(Uri.parse(url));
    print(response.statusCode);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return json;
    } else {
      print("Failed to load data from Google Sheets API");
      return {};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Match No: $keyMatchNo'),
        Text('Home Team: $keyHome'),
      ],
    );
  }
}
