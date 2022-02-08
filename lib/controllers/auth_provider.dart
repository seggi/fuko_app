// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// import 'package:fuko_app/utils/api.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class FkAuthentication {
//   login(email, password) async {
//     Map data = {email: email, 'password': password};

//     final response = await http.post(Uri.parse(Network.login),
//         headers: {
//           "Accept": "application/json",
//           "Content-Type": "application/x-www-form-urlencoded"
//         },
//         body: data,
//         encoding: Encoding.getByName("utf-8"));

//     setState(() {
//       idLoading = false;
//     });

//     if (response.statusCode == 200) {
//       Map<String, dynamic> userResp = jsonDecode(response.body);
//       if (!userResp['error']) {
//         Map<String, dynamic> user = userResp['data'];
//         savePref(1, user['name'], user['email'], user['id']);
//       } else {
//         print("${userResp['message']}");
//       }

//       scaffoldMessenger
//           .showSnackBar(SnackBar(content: Text("${userResp['message']}")));
//     } else {
//       scaffoldMessenger
//           .showSnackBar(const SnackBar(content: Text("Please try again!")));
//     }
//   }

//   savePref(int value, String name, String email, int id) async {
//     SharedPreferences preferences = await SharedPreferences.getInstance();

//     preferences.setInt("value", value);
//     preferences.setString("name", name);
//     preferences.setString("email", email);
//     preferences.setString("id", id.toString());

//     // ignore: deprecated_member_use
//     preferences.commit();
//   }
// }
