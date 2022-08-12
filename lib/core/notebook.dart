import 'dart:convert';

import 'package:fuko_app/core/user_preferences.dart';
import 'package:fuko_app/utils/api.dart';
import 'package:http/http.dart' as http;

class Notebook {
  final String? name;
  final String? description;
  final String? id;

  Notebook({this.name, this.description, this.id});

  factory Notebook.fromJson(Map<String, dynamic> json) {
    return Notebook(
        name: json["notebook_name"].toString(),
        description: json["description"].toString(),
        id: json["id"].toString());
  }
}

Future<List<Notebook>> fetchNotebook() async {
  var token = await UserPreferences.getToken();

  final response = await http.get(Uri.parse(Network.getNotebook),
      headers: Network.authorizedHeaders(token: token));

  if (response.statusCode == 200) {
    var deptPaymentReport = jsonDecode(response.body)["data"] as List;

    return deptPaymentReport.map((dept) => Notebook.fromJson(dept)).toList();
  } else {
    throw Exception('Failed to load data');
  }
}
