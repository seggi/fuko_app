import 'dart:convert';

import 'package:fuko_app/core/user_preferences.dart';
import 'package:fuko_app/utils/api.dart';
import 'package:http/http.dart' as http;

class User {
  final Map? data;
  final int? userId;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? birthDate;
  final String? token;

  User({
    this.userId,
    this.firstName,
    this.lastName,
    this.data,
    this.email,
    this.birthDate,
    this.token,
  });

  factory User.fromJson(Map<String, dynamic> responseData) {
    return User(
      data: responseData['data'],
      email: responseData['message'],
      birthDate: responseData['code'],
      token: responseData['access_fresh_token'],
    );
  }
}

class TokenObject {
  late Map<String, dynamic>? tokenData;
  late String expiredDate;
  TokenObject({required this.tokenData, required this.expiredDate});
}

class NewBorrower {
  final List userData;

  NewBorrower({required this.userData});
  factory NewBorrower.fromJson(Map<String, dynamic> json) {
    return NewBorrower(userData: json["data"]);
  }
}

Future<User> fetchProfile(
    {String? noteId, currencyCode, loanMembership}) async {
  var token = await UserPreferences.getToken();

  final response = await http.get(Uri.parse(Network.getProfile),
      headers: Network.authorizedHeaders(token: token));

  if (response.statusCode == 201) {
    return User.fromJson(jsonDecode(response.body)["data"]);
  } else {
    throw Exception('Failed to load data');
  }
}
