import 'package:flutter/foundation.dart';
import 'package:kt_dart/kt.dart';

import '../../../data/model/user/user.dart';
import '../../../data/repository/user.dart';


class LoginViewModel extends ChangeNotifier {
  var isLoading = false;

  Future<bool> login(
      String username, String password, Future<String> Function() onGetCode) {
    isLoading = true;
    notifyListeners();
    throw TODO("not implemented");
  }

  Future<User?> getRecentUser() async =>
      UserRepository.getInstance().getRecentUser();
}
