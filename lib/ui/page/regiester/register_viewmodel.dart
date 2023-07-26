import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/data/network.dart';
import 'package:flutter_template/ui/page/regiester/register_viewmodel.dart';
import 'package:get/get.dart';


class RegisterController extends GetxController {
  final String username;
  final String password;

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final captchaController = TextEditingController();

  var isLoading = false.obs;
  GlobalKey formKey = GlobalKey<FormState>();
  var passwordVisible = false.obs;

  var isGettingVerificationCode = false.obs;
  var remainingSeconds = 0.obs;

  RegisterController(this.username, this.password);

  @override
  void onInit() {
    super.onInit();
    usernameController.text = username;
    passwordController.text = password;
  }

  Future<void> register(FormState currentState) async {
    if (!currentState.validate()) {
      Get.rawSnackbar(message: "please_check_the_input".tr);
      return;
    }
    final dio = await AppNetwork.getDio();

    try {
      final resp = await dio.post("/account/register",
          options: Options(responseType: ResponseType.json),
          data: {
            "code": captchaController.text,
            "password": passwordController.text,
            "username": usernameController.text,
          });
      final result = resp.data;
      if (result['code'] == 200) {
        Get.rawSnackbar(message: "registration_successful".tr);
        Get.back();
      } else {
        Get.rawSnackbar(
            message: "${'registration_failed'.tr}: ${result['msg']}");
      }
    } catch (e) {
      Get.rawSnackbar(message: "${'registration_failed'.tr}: ${e}");
      print(e);
    }
  }

  sendCode(String email) async {
    if (usernameController.text.trim().isEmpty) {
      Get.rawSnackbar(message: "please_enter_your_email_address_first".tr);
      return;
    }

    isGettingVerificationCode.value = true;

    final dio = await AppNetwork.getDio();
    final resp = await dio.post("/account/verify",
        data: {"codeType": "1001", "graphicCode": "忽略", "phoneOrEmail": email});
    final respBody = resp.data;
    if (respBody['code'] == 200) {
      Get.rawSnackbar(message: "verification_code_sent_successfully".tr);
      // 启动倒计时
      const countdownDuration = 60; // 倒计时时长

      remainingSeconds.value = countdownDuration;
      Timer.periodic(Duration(seconds: 1), (timer) {
        remainingSeconds.value = countdownDuration - timer.tick;

        if (remainingSeconds.value == 0) {
          timer.cancel();
        }
      });
    } else {
      Get.rawSnackbar(
          message: "${'verification_code_sent_failed'.tr}：${respBody['msg']}");
    }

    isGettingVerificationCode.value = false;
  }
}