import 'package:ac_todo_app/models/todo.dart';
import 'package:ac_todo_app/services/idatasource.dart';
import 'package:hive_flutter/adapters.dart';

class HiveDatasource implements IDatasource {
  late final Future init;
  //late final Box<Todo> box;

  Future<void> initialise() async {
    await Hive.initFlutter();
    Hive.registerAdapter(TodoAdapter());
    await Hive.deleteBoxFromDisk('todos');
    Box<Todo> box = await Hive.openBox('todos');
  }

  HiveDatasource() {
    init = initialise();
  }

  @override
  Future<bool> add(Todo model) async {
    await init;
    Box<Todo> box = Hive.box('todos');
    await box.add(model);
    return true;
  }

  @override
  Future<List<Todo>> browse() async {
    await init;
    Box<Todo> box = Hive.box('todos');
    return box.values.toList().cast();
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
