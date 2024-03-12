import '../util.dart' as util;

class Todo {
  final dynamic id;
  final String name;
  final String description;
  final bool completed;

  Todo(
      {required this.id,
      required this.name,
      required this.description,
      this.completed = false});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'completed': completed,
    };
  }

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
        id: map['id'],
        name: map['name'],
        description: map['description'],
        completed: util.getBool(map['completed']));
  }

  @override
  String toString() {
    return "$name - $description";
  }
}
