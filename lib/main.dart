import 'package:ac_todo_app/services/idatasource.dart';
//import 'package:ac_todo_app/services/sql_datasource.dart';
import 'package:ac_todo_app/services/hive_datasource.dart';
import 'package:ac_todo_app/services/remote_api_datasource.dart';
import 'package:ac_todo_app/widgets/todo_widget.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'models/todo.dart';
import 'models/todo_list.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';

int newID = 1;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Get.put<IDatasource>(HiveDatasource());
  Get.put<IDatasource>(RemoteApiDatasource());

  runApp(ChangeNotifierProvider(
    create: (context) => TodoList(),
    child: const TodoApp(),
  ));
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Todo\'s'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Consumer<TodoList>(
          builder: (context, model, child) {
            return FutureBuilder<bool>(
              future: model.refresh(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  //Error state
                  return const Center(
                    child: Text("Error Leading Data, Pull down to refresh..."),
                  );
                }
                //No data / Loading...
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  ); // Center
                }
                return RefreshIndicator(
                  onRefresh: model.refresh,
                  child: ListView.builder(
                    itemCount: model.todoCount,
                    itemBuilder: (context, index) {
                      Todo todo = model.todos[index];
                      return Dismissible(
                        key: Key(todo.id.toString()),
                        onDismissed: (direction) async {
                          setState(() {
                            Provider.of<TodoList>(context, listen: false)
                                .removeTodo(todo);
                          });
                          await model.remove(todo);
                        },
                        background: Container(
                          color: Colors.red,
                          child: const Icon(Icons.delete),
                        ),
                        child: TodoWidget(
                            todo: todo,
                            widgetColor: index % 2 == 0
                                ? Theme.of(context).colorScheme.inversePrimary
                                : Theme.of(context).colorScheme.secondary),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddTodo,
        tooltip: 'Add Todo!',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _openAddTodo() {
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController nameController = TextEditingController();
        final TextEditingController descriptionController =
            TextEditingController();
        final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
        return AlertDialog(
          title: const Text("Add Todo!"),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: "Name:"),
                  controller: nameController,
                  validator: emptyFormValidation,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                      labelText: "Description:",
                      hintText: "Enter a description..."),
                  controller: descriptionController,
                  validator: emptyFormValidation,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                  child: ElevatedButton(
                      onPressed: () {
                        if (!_formKey.currentState!.validate()) return;

                        setState(() {
                          Provider.of<TodoList>(context, listen: false).add(
                              Todo(
                                  id: (newID++).toString(),
                                  name: nameController.text,
                                  description: descriptionController.text,
                                  completed: false));
                        });
                        Navigator.pop(context);
                      },
                      child: const Text("Save")),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String? emptyFormValidation(value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a value';
    }
    return null;
  }
}
