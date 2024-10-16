import '../database-mock/database-helper.dart';
import '../modules/user.dart';

class SignupServices {
  static final DatabaseHelper _dbHelper = DatabaseHelper();

  static Future<void> addUser(User user) async {
    await _dbHelper.insertUser(user.toMap());
    await fetchUsers();
  }

  static Future<void> fetchUsers() async {
    final users = await _dbHelper.getUsers();
    print(users);
  }

  static Future<void> deleteUser(String email) async {
    await _dbHelper.deleteUserByEmail(email);
  }
}
