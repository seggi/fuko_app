import 'package:flutter_dotenv/flutter_dotenv.dart';

class Network {
  static String? liveUrl = "https://fuko-backend.herokuapp.com/api/user";
  // dotenv.env['LOCAL_URL'] ?? "https://fuko-backend.herokuapp.com/api/user";
  static String login = liveUrl! + "/login";
  static String register = liveUrl! + "/signup";
  static String completeProfile = liveUrl! + "/profile/complete-profile";
  static Map<String, String> authorizedHeaders({token}) => {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': "Bearer $token",
      };
}
