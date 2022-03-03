import 'dart:convert';
import 'package:fuko_app/core/user_preferences.dart';
import 'package:fuko_app/utils/api.dart';
import 'package:http/http.dart' as http;

class GlobalAmount {
  late final String globalAmount;
  late final Map globalAmountDetails;

  GlobalAmount({required this.globalAmount, required this.globalAmountDetails});

  factory GlobalAmount.fromJson(Map<String, dynamic> responseData) {
    return GlobalAmount(
      globalAmount: responseData['global_amount'].toString(),
      globalAmountDetails: responseData['global_amount_details'],
    );
  }
}

Future<GlobalAmount> fetchGlobalAmount() async {
  var token = await UserPreferences.getToken();
  var userId = await UserPreferences.getUserId();

  final response = await http.get(Uri.parse(Network.globalAmount + "/$userId"),
      headers: Network.authorizedHeaders(token: token));

  if (response.statusCode == 200) {
    return GlobalAmount.fromJson(
        jsonDecode(response.body)["data"]["global_amount"]);
  } else {
    throw Exception('Failed to load data');
  }
}
