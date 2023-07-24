import 'package:flutter/foundation.dart';
import 'package:kt_dart/kt.dart';

import '../../../data/model/user/user.dart';
import '../../../data/repository/user.dart';


class LoginViewModel extends ChangeNotifier {
  var isLoading = false;

  Future<User?> getRecentUser() async =>
      UserRepository.getInstance().getRecentUser();
}
