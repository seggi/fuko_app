import 'package:jwt_decoder/jwt_decoder.dart';

Map<String, dynamic> fkJwtDecode({tokenKey}) {
  String token = tokenKey;

  Map decodedToken = JwtDecoder.decode(token);
  bool isTokenExpired = JwtDecoder.isExpired(token);

  if (!isTokenExpired) {}
  DateTime expirationDate = JwtDecoder.getExpirationDate(token);
  Duration tokenTime = JwtDecoder.getTokenTime(token);

  Map<String, dynamic> getTokenData = {
    "token": tokenKey,
    "tokenData": decodedToken,
    "expiredDate": expirationDate
  };

  return getTokenData;
}
