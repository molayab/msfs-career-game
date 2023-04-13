import 'package:testai/models/user.dart';
import 'package:testai/services/sql_service.dart';

class UsersService {
  final database = SqlService();

  void createUser(String name, String initialLocation) async {
    final db = await database.connect();
    final id = await db.insert("pilots",
        User(id: null, name: name, location: initialLocation, rank: 0).toMap());

    print("User created with id: $id");
  }

  Future<User> get(int id) async {
    final db = await database.connect();
    final List<Map<String, dynamic>> maps =
        await db.query('pilots', where: "id = ?", whereArgs: [id]);

    return User.fromMap(maps.first);
  }

  Future<List<User>> all() async {
    final db = await database.connect();
    final List<Map<String, dynamic>> maps = await db.query('pilots');

    return maps.map((e) => User.fromMap(e)).toList();
  }

  Future<void> moveTo(String location, int userId) async {
    final db = await database.connect();
    await db.update("pilots", {"location": location},
        where: "id = ?", whereArgs: [userId]);
  }
}
