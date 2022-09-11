import 'dart:convert';

import 'package:fuko_app/core/user_preferences.dart';
import 'package:fuko_app/utils/api.dart';
import 'package:http/http.dart' as http;

class ProfileData {
  final String? lastName;
  final String? firstName;
  final String? phone;
  final String? email;
  final String? picture;
  final String? username;
  final String? birthData;

  ProfileData(
      {this.lastName,
      this.firstName,
      this.phone,
      this.picture,
      this.username,
      this.birthData,
      this.email});

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
        lastName: json['last_name'].toString(),
        email: json['email'].toString(),
        phone: json['phone'].toString(),
        birthData: json['birth_date'].toString(),
        picture: json['picture'].toString(),
        username: json['username'].toString(),
        firstName: json['first_name'].toString());
  }
}

Future<List<ProfileData>> fetchProfile() async {
  var token = await UserPreferences.getToken();
  final response = await http.get(Uri.parse(Network.getProfile),
      headers: Network.authorizedHeaders(token: token));

  if (response.statusCode == 201) {
    var profile = jsonDecode(response.body)["data"] as List;

    return profile.map((info) => ProfileData.fromJson(info)).toList();
  } else {
    throw Exception('Failed to load data');
  }
}
