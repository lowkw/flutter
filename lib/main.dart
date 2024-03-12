import 'package:ac_todo_app/widgets/todo_widget.dart';
import 'package:flutter/material.dart';
import 'models/todo.dart';
import 'models/todo_list.dart';
import 'package:provider/provider.dart';

void main() {
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
            return ListView.builder(
              itemCount: model.todoCount,
              itemBuilder: (context, index) {
                return TodoWidget(
                    todo: model.todos[index],
                    widgetColor: index % 2 == 0
                        ? Theme.of(context).colorScheme.inversePrimary
                        : Theme.of(context).colorScheme.secondary);
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
                                  name: nameController.text,
                                  description: descriptionController.text,
                                  complete: false));
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
