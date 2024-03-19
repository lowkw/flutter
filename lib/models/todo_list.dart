import 'dart:collection';

import 'package:ac_todo_app/services/idatasource.dart';
import 'package:flutter/material.dart';
import 'todo.dart';
import 'package:get/get.dart';

// Manages the state of the list of todos
class TodoList extends ChangeNotifier {
  List<Todo> _todos = [];
/*
  final List<Todo> _todos = <Todo>[
    Todo(name: "Do homework", description: "Times tables", completed: true),
    Todo(
        name: "Go to the beach",
        description: "Don't forget sunscreen",
        completed: true),
    Todo(
        name: "Work out string theory",
        description: "Can't be that hard right?",
        completed: true),
  ];
*/
  UnmodifiableListView<Todo> get todos => UnmodifiableListView(_todos);
  int get todoCount => _todos.length;

  void add(Todo todo) async {
    IDatasource datasource = Get.find();
    await datasource.add(todo);
    await refresh();
    //_todos.add(todo);
    notifyListeners(); // Triggers the update of each consumer
  }

  void removeAll() {
    _todos.clear();
    notifyListeners();
  }

  void remove(Todo todo) async {
    IDatasource datasource = Get.find();
    await datasource.delete(todo);
    notifyListeners();
  }

  void updateTodo(Todo todo) {
    //Get instance of todo from name
    Todo foundTodo = _todos.firstWhere((element) => element.name == todo.name);
    //Use instance to get index & replace instance with new instance
    _todos[_todos.indexOf(foundTodo)] = todo;
    notifyListeners();
  }

  Future<bool> refresh() async {
    IDatasource datasource = Get.find();
    //GetIt.i<IDatasource>.browse();
    _todos = await datasource.browse();
    notifyListeners();
    return true;
  }
}
