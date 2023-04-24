import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kt_dart/kt.dart';
import 'package:provider/provider.dart';

import 'login_viewmodel.dart';

class LoginPage extends StatelessWidget {
  final bool popUpAfterSuccess;

  const LoginPage({Key? key, required this.popUpAfterSuccess})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoginViewModel>(
        create: (context) => LoginViewModel(),
        child: _LoginPage(
          popUpAfterSuccess: popUpAfterSuccess,
        ));
  }
}

class _LoginPage extends StatefulWidget {
  const _LoginPage({Key? key, required this.popUpAfterSuccess})
      : super(key: key);
  final bool popUpAfterSuccess;

  @override
  State<_LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<_LoginPage> {
  final TextEditingController _usernameController =
      TextEditingController(text: "");
  final TextEditingController _passwordController =
      TextEditingController(text: "");
  final TextEditingController _vcodeController =
      TextEditingController(text: "");
  GlobalKey _formKey = GlobalKey<FormState>();
  bool _passwordVisible = false;

  _loginMessage(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(msg),
        // action: SnackBarAction(label: '撤销', onPressed: Null),
        duration: Duration(milliseconds: 2000)));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginViewModel>(builder: (context, vm, child) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("登录"),
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
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _usernameController,
                          autofocus: true,
                          decoration: InputDecoration(
                            labelText: "用户名",
                            hintText: "您的用户名",
                            prefixIcon: Icon(Icons.person),
                            // helperText: '用户名',
                            border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16))),
                          ),
                          validator: (v) {
                            return v!.trim().length > 0 ? null : "账号不能为空";
                          },
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: !_passwordVisible,
                          decoration: InputDecoration(
                            labelText: "密码",
                            hintText: "您的登录密码",
                            prefixIcon: Icon(Icons.lock),
                            suffixIcon: IconButton(
                              icon: Icon(
                                //根据passwordVisible状态显示不同的图标
                                _passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                //更新状态控制密码显示或隐藏
                                setState(() {
                                  _passwordVisible = !_passwordVisible;
                                });
                              },
                            ),
                            // helperText: '密码',
                            border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16))),
                          ),
                          validator: (v) {
                            return v!.trim().length > 0 ? null : "密码不能为空";
                          },
                        ),
                        Container(
                          height: 16,
                        ),
                        buildCodeTextField(vm),
                        Container(
                          height: 16,
                        ),
                        Consumer<LoginViewModel>(
                          builder: (context, loginViewModel, child) {
                            return ElevatedButton(
                              onPressed: loginViewModel.isLoading
                                  ? null
                                  : () => _login(loginViewModel, context,
                                      _formKey.currentState as FormState),
                              style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(double.infinity, 50)),
                              child: loginViewModel.isLoading
                                  ? Text("正在登录...")
                                  : Text("登录"),
                            );
                          },
                        )
                      ],
                    )),
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget buildCodeTextField(LoginViewModel vm) {
    return TextFormField(
      controller: _vcodeController,
      autofocus: true,
      decoration: InputDecoration(
        labelText: "验证码",
        hintText: "验证码",
        prefixIcon: Icon(Icons.code),
        suffixIcon: IconButton(
            onPressed: () {
              //todo
            },
            icon: Icon(Icons.send)),
        border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(16))),
      ),
      validator: (v) {
        return v!.trim().length > 0 ? null : "验证码不能为空";
      },
      onFieldSubmitted: (v) {},
    );
  }

  @override
  void initState() {
    super.initState();
    initAsync();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void initAsync() async {
    LoginViewModel vm = Provider.of(context, listen: false);
    final recentUser = await vm.getRecentUser();
    recentUser?.let((it) {
      _usernameController.text = it.username;
      _passwordController.text = it.password;
    });
  }

  Future<void> _login(LoginViewModel loginViewModel, BuildContext context,
      FormState currentState) async {
    if (!currentState.validate()) {
      _loginMessage(context, "请检查输入");
      return;
    }
  }
}
