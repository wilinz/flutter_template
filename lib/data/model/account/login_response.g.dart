// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginResponse _$LoginResponseFromJson(Map<String, dynamic> json) =>
    LoginResponse(
      code: json['code'] as int? ?? 0,
      msg: json['msg'] as String? ?? '',
      data: json['data'] == null
          ? null
          : Data.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LoginResponseToJson(LoginResponse instance) =>
    <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'data': instance.data?.toJson(),
    };

Data _$DataFromJson(Map<String, dynamic> json) => Data(
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      username: json['username'] as String? ?? '',
      gender: json['gender'] as String? ?? '',
      nickname: json['nickname'] as String? ?? '',
      avatar: json['avatar'] as String? ?? '',
    );

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'email': instance.email,
      'phone': instance.phone,
      'username': instance.username,
      'gender': instance.gender,
      'nickname': instance.nickname,
      'avatar': instance.avatar,
    };
