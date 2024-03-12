import 'dart:collection';

import 'package:flutter/material.dart';
import 'todo.dart';

// Manages the state of the list of todos
class TodoList extends ChangeNotifier {
//final List<Todo> _todos = [];
  final List<Todo> _todos = <Todo>[
    Todo(name: "Do homework", description: "Times tables", complete: true),
    Todo(
        name: "Go to the beach",
        description: "Don't forget sunscreen",
        complete: true),
    Todo(
        name: "Work out string theory",
        description: "Can't be that hard right?",
        complete: true),
  ];

  UnmodifiableListView<Todo> get todos => UnmodifiableListView(_todos);
  int get todoCount => _todos.length;

  void add(Todo todo) {
    _todos.add(todo);
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
}
