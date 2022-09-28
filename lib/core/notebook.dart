import 'dart:convert';

import 'package:fuko_app/controllers/manage_provider.dart';
import 'package:fuko_app/core/user_preferences.dart';
import 'package:fuko_app/utils/api.dart';
import 'package:http/http.dart' as http;

class Notebook {
  final String? name;
  final String? description;
  final String? id;
  final String? username;
  final String? firstName;
  final String? lastName;
  final String? requestStatus;
  final String? notebookName;
  final String? sentAt;
  final String? notification;
  final String? requestedAt;
  final String? groupName;

  Notebook(
      {this.name,
      this.description,
      this.id,
      this.lastName,
      this.firstName,
      this.username,
      this.notebookName,
      this.sentAt,
      this.notification,
      this.requestedAt,
      this.groupName,
      this.requestStatus});

  factory Notebook.fromJson(Map<String, dynamic> json) {
    return Notebook(
        name: json["notebook_name"].toString(),
        description: json["description"].toString(),
        id: json["id"].toString(),
        firstName: json["first_name"].toString(),
        lastName: json["last_name"].toString(),
        requestStatus: json["request_status_name"].toString(),
        notebookName: json["notebook_name"].toString(),
        sentAt: json["sent_at"].toString(),
        requestedAt: json["sent_at"].toString(),
        notification: json["notification"],
        groupName: json["group_name"].toString(),
        username: json["username"].toString());
  }
}

Future<List<Notebook>> fetchNotebook() async {
  var token = await UserPreferences.getToken();

  final response = await http.get(Uri.parse(Network.getNotebook),
      headers: Network.authorizedHeaders(token: token));

  if (response.statusCode == 200) {
    var notebook = jsonDecode(response.body)["data"] as List;

    return notebook.map((dept) => Notebook.fromJson(dept)).toList();
  } else {
    throw Exception('Failed to load data');
  }
}

Future<List<Notebook>> fetchNotebookMember({String? notebookId}) async {
  var token = await UserPreferences.getToken();

  final response = await http.get(
      Uri.parse("${Network.getNotebookMember}/$notebookId"),
      headers: Network.authorizedHeaders(token: token));

  if (response.statusCode == 200) {
    var notebookMember = jsonDecode(response.body)["data"] as List;

    return notebookMember.map((dept) => Notebook.fromJson(dept)).toList();
  } else {
    throw Exception('Failed to load data');
  }
}

Future<List<Notebook>> fetchIncomingRequest(context) async {
  var token = await UserPreferences.getToken();
  final response = await http.get(Uri.parse(Network.getInComingRequest),
      headers: Network.authorizedHeaders(token: token));

  if (response.statusCode == 200) {
    var notebookMember = jsonDecode(response.body)["data"] as List;
    FkManageProviders.save["save-request-number"](context,
        number: "${notebookMember.length}");
    return notebookMember.map((dept) => Notebook.fromJson(dept)).toList();
  } else {
    throw Exception('Failed to load data');
  }
}

Future<List<Notebook>> fetchRequestSent() async {
  var token = await UserPreferences.getToken();
  final response = await http.get(Uri.parse(Network.getNotebookRequestSent),
      headers: Network.authorizedHeaders(token: token));

  if (response.statusCode == 200) {
    var notebookMember = jsonDecode(response.body)["data"] as List;

    return notebookMember.map((dept) => Notebook.fromJson(dept)).toList();
  } else {
    throw Exception('Failed to load data');
  }
}
