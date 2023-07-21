import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GoogleSheetsDataWidget extends StatefulWidget {
  @override
  _GoogleSheetsDataWidgetState createState() => _GoogleSheetsDataWidgetState();
}

class _GoogleSheetsDataWidgetState extends State<GoogleSheetsDataWidget> {
  List<List<dynamic>> _data = [];

  @override
  void initState() {
    super.initState();
    _getData();
  }

  Future<void> _getData() async {
    final String spreadsheetId = "1xCl8tDCpc_teLMF628ZFl79EIEraDI1qIGN_NLCHDE8";
    final String apiKey = "AIzaSyDUuLASGb3o-HP0fpHUg0VpQYC7indkv-U";
    final String sheetName = "sheetMatches";
    final String range = "A:E"; // Change this to the range you want to fetch

    final String url =
        "https://sheets.googleapis.com/v4/spreadsheets/$spreadsheetId/values/$sheetName!$range?key=$apiKey";

    final response = await http.get(Uri.parse(url));
    print("Response from Sheets -" + response.body);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      print("Printing JSON" + json);
      setState(() {
        _data = json['values'];
      });
      print(_data);
    } else {
      print("Failed to load data from Google Sheets API");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView.builder(
        itemCount: _data.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_data[index]
                [0]), // Assuming the first column contains the item name
            subtitle: Text(_data[index][
                1]), // Assuming the second column contains the item description
          );
        },
      ),
    );
  }
}
