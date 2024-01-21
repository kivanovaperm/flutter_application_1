import 'package:jwt_decoder/jwt_decoder.dart';

class Token {
  String token;
  String refreshToken;

  Token({required this.token, required this.refreshToken});

  Map<String, dynamic> toDatabaseJson() => {
      
  };

  factory Token.fromJson(Map<String, dynamic> json) {
    return Token(
      token: json['access'].toString(),
      refreshToken: json['refresh'].toString()
    );
  }

  Map<String, dynamic> fetchUser(String token) {
    Map<String, dynamic> userCreds = JwtDecoder.decode(token);
    return userCreds;
  }
}
