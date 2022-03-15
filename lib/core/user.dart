class User {
  final Map? data;
  final int? userId;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? birthDate;
  final String? token;

  User({
    this.userId,
    this.firstName,
    this.lastName,
    this.data,
    this.email,
    this.birthDate,
    this.token,
  });

  factory User.fromJson(Map<String, dynamic> responseData) {
    return User(
      data: responseData['data'],
      email: responseData['message'],
      birthDate: responseData['code'],
      token: responseData['access_token'],
    );
  }
}

class TokenObject {
  late Map<String, dynamic>? tokenData;
  late String expiredDate;
  TokenObject({required this.tokenData, required this.expiredDate});
}

class NewBorrower {
  final List userData;

  NewBorrower({required this.userData});
  factory NewBorrower.fromJson(Map<String, dynamic> json) {
    return NewBorrower(userData: json["data"]);
  }
}
