import 'dart:convert';

import 'package:fuko_app/core/user_preferences.dart';
import 'package:fuko_app/utils/api.dart';
import 'package:http/http.dart' as http;

class GetCurrencies {
  final String? currencyId;
  final String? description;
  final String? currencyCode;
  final String? createdAt;

  GetCurrencies(
      {this.currencyId, this.description, this.currencyCode, this.createdAt});

  factory GetCurrencies.fromJson(Map<String, dynamic> json) {
    return GetCurrencies(
        currencyId: json['id'].toString(),
        description: json['description'].toString(),
        currencyCode: json['code'].toString(),
        createdAt: json['created_at'].toString());
  }
}

Future<List<GetCurrencies>> fetchCurrencies({String? borrowerId}) async {
  var token = await UserPreferences.getToken();

  final response = await http.get(Uri.parse(Network.currencies),
      headers: Network.authorizedHeaders(token: token));

  if (response.statusCode == 200) {
    var currencies = jsonDecode(response.body)["data"] as List;
    return currencies
        .map((currency) => GetCurrencies.fromJson(currency))
        .toList();
  } else {
    throw Exception('Failed to load data');
  }
}
