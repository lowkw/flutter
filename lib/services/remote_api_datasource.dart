import 'package:ac_todo_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:ac_todo_app/models/todo.dart';
import 'package:ac_todo_app/services/idatasource.dart';

class RemoteApiDatasource implements IDatasource {
  late final Future initTask;
  late FirebaseDatabase database;
  List<Todo> _todos = [];

  RemoteApiDatasource() {
    initTask = Future(() async {
      await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform);
      database = FirebaseDatabase.instance;
    });
  }

  @override
  Future<bool> add(Todo model) async {
    if (Firebase.apps.isEmpty) {
      await initTask;
    }
    DatabaseReference ref =
        database.ref().child('todos').child(model.id.toString());
    await ref.update(model.toMap());
    print('This is add in remote api datasource');
    return true;
  }

  @override
  Future<List<Todo>> browse() async {
    _todos = [];
    if (Firebase.apps.isEmpty) {
      await initTask;
    }

    DatabaseReference ref = database.ref();
    final DataSnapshot snapshot = await ref.child('todos').get();
    if (!snapshot.exists) {
      throw Exception(
          "Invalid request - cannot find snapshot: ${snapshot.ref.path}");
    } else {
      print('This is browse in remote api datasource');
      if (snapshot.value != null) {
        try {
          Map<dynamic, dynamic>? values =
              snapshot.value as Map<dynamic, dynamic>;
          values.forEach((key, value) {
            value['_id'] = key;
            _todos.add(Todo.fromMap(Map<String, dynamic>.from(value as Map)));
          });
        } catch (error) {
          if (error is TypeError) {
            List<dynamic>? dynamicList = snapshot.value as List<dynamic>?;
            for (var item in dynamicList!) {
              if (item != null) {
                _todos
                    .add(Todo.fromMap(Map<String, dynamic>.from(item as Map)));
              }
            }
          }
        }
      }
      return _todos;
    }
  }

  @override
  Future<bool> delete(Todo model) async {
    if (Firebase.apps.isEmpty) {
      await initTask;
    }

    DatabaseReference ref =
        database.ref().child('todos').child(model.id.toString());
    print('This is delete in remote api datasource');
    await ref.remove();

    return true;
  }

  @override
  Future<bool> edit(Todo model) async {
    if (Firebase.apps.isEmpty) {
      await initTask;
    }

    DatabaseReference ref =
        database.ref().child('todos').child(model.id.toString());
    print('This is edit in remote api datasource');
    await ref.update(model.toMap());

    return true;
  }

  @override
  Future<Todo> read(String id) {
    // TODO: implement read
    throw UnimplementedError();
  }
}
