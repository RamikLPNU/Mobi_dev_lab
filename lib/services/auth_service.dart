import 'package:my_project/models/user.dart';
import 'package:my_project/storage/storage_interface.dart';

class AuthService {
  final Storage storage;

  AuthService(this.storage);

  Future<void> registerUser(User user) async {
    await storage.saveUser(user);
  }

  Future<User?> getUser() async {
    return await storage.loadUser();
  }

  Future<void> logout() async {
    await storage.clearUser();
  }
}
