import 'package:my_project/models/user.dart';

abstract class Storage {
  Future<void> saveUser(User user);
  Future<User?> loadUser();
  Future<void> clearUser();
}
