class User {
  // int userId;
  // String name;
  String email;
  String birthDate;
  String token;

  User(
      {
      //   required this.userId,
      // required this.name,
      required this.email,
      required this.birthDate,
      required this.token});

  factory User.fromJson(Map<String, dynamic> responseData) {
    return User(
        // userId: responseData['id'],
        // name: responseData['name'],
        email: responseData['message'],
        birthDate: responseData['code'],
        token: responseData['access_token']);
  }
}
