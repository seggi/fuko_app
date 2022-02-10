class User {
  // int userId;
  Map data;
  String email;
  String birthDate;
  String token;

  User(
      {
      //   required this.userId,
      // required this.name,
      required this.data,
      required this.email,
      required this.birthDate,
      required this.token});

  factory User.fromJson(Map<String, dynamic> responseData) {
    return User(
        // userId: responseData['id'],
        // name: responseData['name'],
        data: responseData['data'],
        email: responseData['message'],
        birthDate: responseData['code'],
        token: responseData['access_token']);
  }
}

class TokenObject {
  late Map<String, dynamic>? tokenData;
  late String expiredDate;
  TokenObject({required this.tokenData, required this.expiredDate});
}
