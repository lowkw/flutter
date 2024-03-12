import 'dart:collection';

import 'package:ac_todo_app/services/idatasource.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'todo.dart';

// Manages the state of the list of todos
class TodoList extends ChangeNotifier {
  List<Todo> _todos = [];

  UnmodifiableListView<Todo> get todos => UnmodifiableListView(_todos);
  int get todoCount => _todos.length;

  void add(Todo todo) async {
    IDatasource datasource = Get.find();
    await datasource.add(todo);
    await refresh();
    notifyListeners(); // Triggers the update of each consumer
  }

  void removeAll() {
    _todos.clear();
    notifyListeners();
  }

  void remove(Todo todo) {
    _todos.remove(todo);
    notifyListeners();
  }

  void updateTodo(Todo todo) {
    Todo foundTodo = _todos.firstWhere((element) => element.name == todo.name);
    _todos[_todos.indexOf(foundTodo)] = todo;
    notifyListeners();
  }

  Future<void> refresh() async {
    IDatasource datasource = Get.find();
    _todos = await datasource.browse();
    notifyListeners();
  }
}
