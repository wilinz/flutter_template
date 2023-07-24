import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/data/model/account/login_response.dart';
import 'package:flutter_template/data/network.dart';
import 'package:flutter_template/main.dart';
import 'package:flutter_template/util/md5.dart';
import 'package:kt_dart/kt.dart';
import 'package:provider/provider.dart';

import '../../route.dart';
import 'register_viewmodel.dart';

class RegisterPage extends StatelessWidget {
  final bool popUpAfterSuccess;
  final String username;
  final String password;

  const RegisterPage(
      {Key? key,
      required this.popUpAfterSuccess,
      required this.username,
      required this.password})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoginViewModel>(
        create: (context) => LoginViewModel(),
        child: _RegisterPage(
            popUpAfterSuccess: popUpAfterSuccess,
            username: username,
            password: password));
  }
}

class _RegisterPage extends StatefulWidget {
  const _RegisterPage(
      {Key? key,
      required this.popUpAfterSuccess,
      required this.username,
      required this.password})
      : super(key: key);
  final bool popUpAfterSuccess;
  final String username;
  final String password;

  @override
  State<_RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<_RegisterPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _captchaController = TextEditingController();

  Timer? _countdownTimer;
  GlobalKey _formKey = GlobalKey<FormState>();
  bool _passwordVisible = false;

  bool _isGettingVerificationCode = false;

  @override
  void initState() {
    super.initState();
    _usernameController.text = widget.username;
    _passwordController.text = widget.password;
    initAsync();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginViewModel>(builder: (context, vm, child) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("注册"),
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
                    child: Center(
                      child: Column(
                        children: [
                          SizedBox(height: 50),
                          Text('注册',
                              style: Theme.of(context).textTheme.titleLarge),
                          SizedBox(height: 50),
                          TextFormField(
                            controller: _usernameController,
                            autofocus: true,
                            decoration: InputDecoration(
                              labelText: "邮箱",
                              hintText: "您的邮箱",
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
                          SizedBox(
                            height: 16,
                          ),
                          TextFormField(
                            controller: _captchaController,
                            autofocus: true,
                            decoration: InputDecoration(
                              labelText: "验证码",
                              hintText: "验证码",
                              prefixIcon: Icon(Icons.domain_verification),
                              suffixIcon: IconButton(
                                onPressed: _isGettingVerificationCode ||
                                        _countdownTimer != null
                                    ? null
                                    : () => _sendCode(_usernameController.text),
                                icon: _countdownTimer == null
                                    ? Icon(Icons.send)
                                    : Text("${60 - _countdownTimer!.tick}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge),
                              ),
                              // helperText: '用户名',
                              border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(16))),
                            ),
                            validator: (v) {
                              return v!.trim().length > 0 ? null : "验证码不能为空";
                            },
                          ),
                          SizedBox(
                            height: 32,
                          ),
                          Consumer<LoginViewModel>(
                            builder: (context, loginViewModel, child) {
                              return ElevatedButton(
                                onPressed: loginViewModel.isLoading
                                    ? null
                                    : () => _register(loginViewModel, context,
                                        _formKey.currentState as FormState),
                                style: ElevatedButton.styleFrom(
                                    minimumSize:
                                        const Size(double.infinity, 50)),
                                child: loginViewModel.isLoading
                                    ? Text("正在注册...")
                                    : Text("注册"),
                              );
                            },
                          ),
                        ],
                      ),
                    )),
              ),
            ),
          ),
        ),
      );
    });
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

  Future<void> _register(LoginViewModel loginViewModel, BuildContext context,
      FormState currentState) async {
    if (!currentState.validate()) {
      showSnackBar(context, "请检查输入");
      return;
    }
    final dio = await AppNetwork.getDio();

    try {
      final resp = await dio.post("/account/register",
          options: Options(responseType: ResponseType.json),
          data: {
            "code": _captchaController.text,
            "password": _passwordController.text,
            "username": _usernameController.text,
          });
      final result = resp.data;
      if (result['code'] == 200) {
        showSnackBar(context, "注册成功");
        Navigator.pop(context);
      } else {
        showSnackBar(context, "注册失败: ${result['msg']}");
      }
    } catch (e) {
      showSnackBar(context, "注册失败: ${e}");
      print(e);
    }
  }

  _sendCode(String email) async {
    if (_usernameController.text.trim().isEmpty) {
      showSnackBar(context, "请先输入邮箱");
      return;
    }

    setState(() {
      _isGettingVerificationCode = true;
    });

    final dio = await AppNetwork.getDio();
    final resp = await dio.post("/account/verify",
        data: {"codeType": "1001", "graphicCode": "忽略", "phoneOrEmail": email});
    final respBody = resp.data;
    if (respBody['code'] == 200) {
      showSnackBar(context, "验证码发送成功");

      // 启动倒计时
      const countdownDuration = Duration(seconds: 60); // 倒计时时长
      var remaining = countdownDuration;
      setState(() {
        _countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
          setState(() {
            remaining = remaining - Duration(seconds: 1);
          });
          if (remaining.inSeconds == 0) {
            timer.cancel();
            setState(() {
              _countdownTimer = null;
            });
          }
        });
      });
    } else {
      showSnackBar(context, "验证码发送失败：${respBody['msg']}");
    }

    setState(() {
      _isGettingVerificationCode = false;
    });
  }
}
