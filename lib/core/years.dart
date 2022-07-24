import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:fuko_app/core/user_preferences.dart';
import 'package:fuko_app/utils/api.dart';

class GetYears {
  final String? year;

  GetYears({this.year});

  factory GetYears.fromJson(Map<String, dynamic> json) {
    return GetYears(year: json['year'].toString());
  }
}

Future<List<GetYears>> fetchYears() async {
  var token = await UserPreferences.getToken();

  final response = await http.get(Uri.parse(Network.yearsList),
      headers: Network.authorizedHeaders(token: token));

  if (response.statusCode == 200) {
    var currencies = jsonDecode(response.body)["data"] as List;
    return currencies.map((currency) => GetYears.fromJson(currency)).toList();
  } else {
    throw Exception('Failed to load data');
  }
}
