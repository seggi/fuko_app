import 'dart:convert';

import 'package:fuko_app/core/user_preferences.dart';
import 'package:fuko_app/utils/api.dart';
import 'package:http/http.dart' as http;

class Settings {
  final int? id;
  final String? code;

  Settings({this.id, this.code});

  factory Settings.fromJson(Map<String, dynamic> json) {
    return Settings(code: json['code'].toString(), id: json['id']);
  }
}

Future<List<Settings>> fetchCurrency() async {
  var token = await UserPreferences.getToken();
  final response = await http.get(Uri.parse(Network.getDefaultCurrency),
      headers: Network.authorizedHeaders(token: token));

  if (response.statusCode == 200) {
    var currencies = jsonDecode(response.body)['default_currency'] as List;
    return currencies.map((currency) => Settings.fromJson(currency)).toList();
  } else {
    throw Exception('Failed to load data');
  }
}
