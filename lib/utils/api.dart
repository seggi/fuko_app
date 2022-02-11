import 'package:flutter_dotenv/flutter_dotenv.dart';

class Network {
  static String? liveUrl =
      dotenv.env['LOCAL_URL'] ?? "https://fuko-backend.herokuapp.com/api/user";
  static String login = liveUrl! + "/login";
  static String register = liveUrl! + "/signup";
  static String completeProfile = liveUrl! + "/profile/complete-profile";
}
