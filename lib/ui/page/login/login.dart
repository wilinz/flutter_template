import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../route.dart';
import 'login_viewmodel.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);
  final c = Get.put(LoginController());
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('login'.tr),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 400, //宽度尽可能大
            ),
            child: Container(
              padding: const EdgeInsets.all(24),
              child: Form(
                  key: c.formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Center(
                    child: Column(
                      children: [
                        SizedBox(height: 50),
                        Text('login'.tr,
                            style: Theme.of(context).textTheme.titleLarge),
                        SizedBox(height: 50),
                        TextFormField(
                          controller: c.usernameController,
                          autofocus: true,
                          decoration: InputDecoration(
                            labelText: "username".tr,
                            hintText: "your_username".tr,
                            prefixIcon: Icon(Icons.person),
                            // helperText: '用户名',
                            border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16))),
                          ),
                          validator: (v) {
                            return v!.trim().length > 0 ? null : "account_cannot_empty".tr;
                          },
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Obx(
                          () => TextFormField(
                            controller: c.passwordController,
                            obscureText: !c.passwordVisible.value,
                            decoration: InputDecoration(
                              labelText: "password".tr,
                              hintText: "your_password".tr,
                              prefixIcon: Icon(Icons.lock),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  //根据passwordVisible状态显示不同的图标
                                  c.passwordVisible.value
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  //更新状态控制密码显示或隐藏
                                  c.passwordVisible.value =
                                      !c.passwordVisible.value;
                                },
                              ),
                              // helperText: '密码',
                              border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(16))),
                            ),
                            validator: (v) {
                              return v!.trim().length > 0 ? null : "password_cannot_empty".tr;
                            },
                          ),
                        ),
                        Container(
                          height: 32,
                        ),
                        Obx(
                          () => ElevatedButton(
                            onPressed: c.isLoading.value
                                ? null
                                : () => c.login(
                                    c.formKey.currentState as FormState,
                                    c.usernameController.text,
                                    c.passwordController.text),
                            style: ElevatedButton.styleFrom(
                                minimumSize: const Size(double.infinity, 50)),
                            child: c.isLoading.value
                                ? Text("logging_in".tr)
                                : Text("login".tr),
                          ),
                        ),
                        SizedBox(height: 12),
                        Row(children: [
                          TextButton(
                              onPressed: () {
                                Get.toNamed(AppRoute.registerPage, arguments: {
                                  "username": c.usernameController.text,
                                  "password": c.passwordController.text
                                });
                              },
                              child: Text("register".tr)),
                          Expanded(child: SizedBox()),
                          TextButton(onPressed: () {}, child: Text("forgot_password".tr))
                        ])
                      ],
                    ),
                  )),
            ),
          ),
        ),
      ),
    );
  }
}
