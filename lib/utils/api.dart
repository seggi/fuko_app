import 'package:shared_preferences/shared_preferences.dart';

const signupUrl = "https://fuko-backend.herokuapp.com/api/user/signup";
const loginUrl = "https://fuko-backend.herokuapp.com/api/user/login";

class Network {
  final String _url = 'https://fuko-backend.herokuapp.com/api/user';
  var token;
}
