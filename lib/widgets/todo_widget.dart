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
            ],
          ),
          Checkbox(
            value: widget.todo.complete,
            onChanged: (value) {
              if (value == null) return;
              setState(() {
                Provider.of<TodoList>(context, listen: false).updateTodo(Todo(
                    name: widget.todo.name,
                    description: widget.todo.description,
                    complete: value ?? !widget.todo.complete));
              });
            },
          )
        ],
      ),
    );
  }
}
