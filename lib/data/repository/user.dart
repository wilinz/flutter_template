

import '/util/list.dart';

import '../database/database.dart';
import '../model/user/user.dart';

class UserRepository {
  Future<User?> getRecentUser() async {
    final db = await getDatabase();
    final user = await db.userDao.getRecent();
    return user.firstOrNull();
  }

  Future<User?> getActiveUser() async {
    final db = await getDatabase();
    return db.userDao.getActive();
  }

  UserRepository._create();

  static UserRepository? _instance;

  factory UserRepository.getInstance() =>
      _instance ??= UserRepository._create();
}
