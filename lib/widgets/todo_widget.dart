import 'package:ac_todo_app/models/todo_list.dart';
import 'package:flutter/material.dart';
import '../models/todo.dart';
import 'package:provider/provider.dart';

class TodoWidget extends StatefulWidget {
  final Todo todo;
  final Color widgetColor;
  const TodoWidget({super.key, required this.todo, required this.widgetColor});

  @override
  State<TodoWidget> createState() => _TodoWidgetState();
}

class _TodoWidgetState extends State<TodoWidget> {
  late bool? isChecked = null;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.widgetColor,
      padding: const EdgeInsets.all(10.0),
      margin: const EdgeInsets.fromLTRB(15, 10, 15, 10),
      //child: Text(todos[index].toString()),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Name: ${widget.todo.name}",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontWeight: FontWeight.w800)),
              Text(widget.todo.description),
              //Text(widget.todo.completed.toString()),
            ],
          ),
          Checkbox(
            tristate: false,
            // value: widget.todo.completed,
            value: isChecked ?? widget.todo.completed,
            onChanged: (bool? value) {
              // if (value == null) return;
              setState(() {
                isChecked = value;
                // Provider.of<TodoList>(context, listen: false).updateTodo(Todo(
                Provider.of<TodoList>(context, listen: false).edit(Todo(
                    id: widget.todo.id,
                    name: widget.todo.name,
                    description: widget.todo.description,
                    // completed: value ?? !widget.todo.completed));
                    completed: isChecked!));
              });
            },
          )
        ],
      ),
    );
  }
}
