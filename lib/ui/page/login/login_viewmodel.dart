import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/data/model/account/login_response.dart';
import 'package:flutter_template/data/network.dart';
import 'package:flutter_template/util/md5.dart';
import 'package:get/get.dart';
import 'package:kt_dart/kt.dart';

import '../../../data/model/user/user.dart';
import '../../../data/repository/user.dart';
import '../../route.dart';

class LoginController extends GetxController {
  var isLoading = false.obs;
  final TextEditingController usernameController =
      TextEditingController(text: "");
  final TextEditingController passwordController =
      TextEditingController(text: "");
  GlobalKey formKey = GlobalKey<FormState>();
  var passwordVisible = false.obs;

  Future<void> login(
      FormState currentState, String username, String password) async {
    if (!currentState.validate()) {
      Get.rawSnackbar(message: "请检查输入");
      return;
    }
    final dio = await AppNetwork.getDio();

    try {
      final resp = await dio.post("/account/login",
          options: Options(responseType: ResponseType.json),
          data: {"username": username, "password": sha256Text(password)});
      final loginResult = LoginResponse.fromJson(resp.data);
      if (loginResult.code == 200) {
        Get.rawSnackbar(message: "登录成功");
        Get.offNamed(AppRoute.mainPage);
        // if (widget.popUpAfterSuccess) {
        //   Navigator.pop(context);
        // } else {
        //   Navigator.pushNamed(context, AppRoute.mainPage);
        // }
      } else {
        Get.rawSnackbar(message: "登录失败: ${loginResult.msg}");
      }
    } catch (e) {
      Get.rawSnackbar(message: "登录失败: ${e}");
      print(e);
    }
  }

  Future<User?> getRecentUser() async =>
      UserRepository.getInstance().getRecentUser();

  @override
  Future<void> onInit() async {
    super.onInit();
    final recentUser = await getRecentUser();
    recentUser?.let((it) {
      usernameController.text = it.username;
      passwordController.text = it.password;
    });
  }
}
