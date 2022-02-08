import 'package:flutter_dotenv/flutter_dotenv.dart';

class Network {
  static String? liveUrl =
      dotenv.env['LOCAL_URL'] ?? "https://fuko-backend.herokuapp.com/api/user";

  static String login = liveUrl! + "/signup";
  static String register = liveUrl! + "/login";
}
