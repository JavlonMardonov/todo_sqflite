// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:todo_app_sqflite/data/models/todo_model.dart';
import 'package:todo_app_sqflite/providers/todo_provider.dart';

class TodoContainer extends StatelessWidget {
  final TodoModel todo;
  final TodoProvider todoProvider;
  const TodoContainer({
    super.key,
    required this.todo,
    required this.todoProvider,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<TodoProvider>(
      builder: (context, todoProvider, child) {
        return Container(
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              width: 1,
              color: Colors.amber,
            ),
            color: Colors.grey.shade100,
          ),
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  if (todo.status == 1) {
                    todoProvider.changeTodoStatus(
                      id: todo.id!,
                      newValue: 0,
                    );
                  } else {
                    todoProvider.changeTodoStatus(
                      id: todo.id!,
                      newValue: 1,
                    );
                  }
                },
                icon: todo.status == 1
                    ? Icon(
                        Icons.check_box_rounded,
                        color: Colors.green,
                      )
                    : Icon(
                        Icons.check_box_outline_blank_rounded,
                      ),
              ),
              Text(
                todo.title.toString(),
                style: TextStyle(
                  color: todo.status == 1 ? Colors.grey.shade400 : Colors.black,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
