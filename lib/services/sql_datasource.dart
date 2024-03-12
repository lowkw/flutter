import 'package:ac_todo_app/models/todo.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'idatasource.dart';

class SQLDatasource implements IDatasource {
  final String _tableName = 'todos';
  late Database database;
  late Future init;

  SQLDatasource() {
    init = initialise();
  }

  Future<void> initialise() async {
    database = await openDatabase(
      join(await getDatabasesPath(), 'todo_data.db'),
      onCreate: (db, version) {
        // Runs once when the Database is created.
        return db.execute(
            'CREATE TABLE IF NOT EXISTS $_tableName (id INTEGER PRIMARY KEY, name TEXT, description TEXT, completed INTEGER)');
      },
      version: 1,
    );
    //initialised = true;
  }

  @override
  Future<bool> add(Todo model) async {
    await init;
    Map<String, dynamic> todoMap = model.toMap();
    todoMap.remove('id');
    return await database.insert(_tableName, todoMap) == 0 ? false : true;
  }

  @override
  Future<List<Todo>> browse() async {
    await init;
    List<Map<String, dynamic>> maps = await database.query(_tableName);
    return List.generate(maps.length, (index) {
      return Todo.fromMap(maps[index]);
    });
  }

  @override
  Future<bool> delete(Todo model) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<bool> edit(Todo model) {
    // TODO: implement edit
    throw UnimplementedError();
  }

  @override
  Future<Todo> read(String id) {
    // TODO: implement read
    throw UnimplementedError();
  }
}
