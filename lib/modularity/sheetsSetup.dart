import 'dart:convert';
import 'package:http/http.dart' as http;

export 'package:tradeop/modularity/sheetsSetup.dart';

List<List<dynamic>> _data = [];

Future<dynamic> fnGetDataFromSheets(argSheetName) async {
  const String spreadsheetId = "1xCl8tDCpc_teLMF628ZFl79EIEraDI1qIGN_NLCHDE8";
  const String apiKey = "AIzaSyDUuLASGb3o-HP0fpHUg0VpQYC7indkv-U";
  final String sheetName = argSheetName;
  const String range = "A:E"; // Change this to the range you want to fetch
  const String majorDimension = "ROWS";
  final String url =
      "https://sheets.googleapis.com/v4/spreadsheets/$spreadsheetId/values/$sheetName!$range?majorDimension=$majorDimension&key=$apiKey";
  final response = await http.get(Uri.parse(url));
  print("Response from Sheets -" + response.body);
  if (response.statusCode == 200) {
    // final varBody = response.body;
    final json = jsonDecode(response.body);
    // print("Printing JSON" + json);
    // print(json["values"]);

    // return json;
    return json;
    // return _data = json['values'];
  } else {
    print("Failed to load data from Google Sheets API");
  }
}
