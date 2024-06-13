import '../util.dart' as util;
import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class Todo extends HiveObject {
  @HiveField(0)
  final dynamic id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String description;
  @HiveField(3)
  final bool completed;

  Todo(
      {required this.id,
      required this.name,
      required this.description,
      // this.completed = false});
      required this.completed});

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
    return "$id - $name - $description - $completed";
  }
}

class TodoAdapter extends TypeAdapter<Todo> {
  @override
  Todo read(BinaryReader reader) {
    return Todo(
        id: reader.read(0),
        name: reader.read(1),
        description: reader.read(2),
        completed: reader.read(3));
  }

  @override
  int get typeId => 0;

  @override
  void write(BinaryWriter writer, Todo obj) {
    writer.write(obj.id);
    writer.write(obj.name);
    writer.write(obj.description);
    writer.write(obj.completed);
  }
}
