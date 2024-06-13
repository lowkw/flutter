import 'dart:math';

import 'package:ac_todo_app/models/todo.dart';
import 'package:ac_todo_app/services/idatasource.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

class HiveDatasource implements IDatasource {
  late final Future init;
  List<Todo> _todos = [];
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
  Future<bool> delete(Todo model) async {
    await init;
    print('This is delete in hive datasource');

    Box<Todo> box = Hive.box('todos');
    Map<dynamic, Todo> allTodos = box.toMap();
    int? key =
        allTodos.keys.firstWhere((key) => allTodos[key]?.name == model.name);
    await box.delete(key);

    print(box.toMap());
    return true;
  }

  @override
  Future<bool> edit(Todo model) async {
    await init;
    print('This is edit in hive datasource');

    Box<Todo> box = Hive.box('todos');
    Map<dynamic, Todo> allTodos = box.toMap();
    int? key =
        allTodos.keys.firstWhere((key) => allTodos[key]?.name == model.name);
    print(key);
    await box.put(key, model);

    print(box.toMap());
    return true;
  }

  @override
  Future<Todo> read(String id) {
    // TODO: implement read
    throw UnimplementedError();
  }
}
