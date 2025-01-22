import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app_sqflite/data/local_datasource/local_data_source.dart';
import 'package:todo_app_sqflite/data/repositories/todo_repo.dart';
import 'package:todo_app_sqflite/presentation/screens/todos_screen.dart';
import 'package:todo_app_sqflite/providers/todo_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TodoProvider(
        TodoRepo(
          localDataSource: LocalDataSource(),
        ),
      ),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: TodosScreen(),
      ),
    );
  }
}
