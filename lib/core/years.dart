import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:fuko_app/core/user_preferences.dart';
import 'package:fuko_app/utils/api.dart';

class GetYears {
  final List? years;

  GetYears({this.years});

  factory GetYears.fromJson(Map<String, dynamic> json) {
    return GetYears(years: json['years']);
  }
}

Future<GetYears> fetchYears() async {
  var token = await UserPreferences.getToken();

  final response = await http.get(Uri.parse(Network.yearsList),
      headers: Network.authorizedHeaders(token: token));

  if (response.statusCode == 200) {
    return GetYears.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load data');
  }
}
