import 'package:json_annotation/json_annotation.dart';

part 'login_response.g.dart';

@JsonSerializable(explicitToJson: true)
class LoginResponse {
  LoginResponse(
      {required this.code,
      required this.msg,
      required this.data});

  @JsonKey(name: "code", defaultValue: 0)
  int code;
  @JsonKey(name: "msg", defaultValue: "")
  String msg;
  @JsonKey(name: "data")
  Data? data;

  factory LoginResponse.fromJson(Map<String, dynamic> json) => _$LoginResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Data {
  Data(
      {required this.email,
      required this.phone,
      required this.username,
      required this.gender,
      required this.nickname,
      required this.avatar});

  @JsonKey(name: "email", defaultValue: "")
  String email;
  @JsonKey(name: "phone", defaultValue: "")
  String phone;
  @JsonKey(name: "username", defaultValue: "")
  String username;
  @JsonKey(name: "gender", defaultValue: "")
  String gender;
  @JsonKey(name: "nickname", defaultValue: "")
  String nickname;
  @JsonKey(name: "avatar", defaultValue: "")
  String avatar;

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

  Map<String, dynamic> toJson() => _$DataToJson(this);
}


