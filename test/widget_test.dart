import 'package:flutter/material.dart';
import 'package:my_cst2335_labs/todo_database.dart';


class MyApp extends StatelessWidget {
  final AppDatabase database;

  const MyApp({Key? key, required this.database}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: HomeScreen(database: database),
    );
  }

  HomeScreen({required AppDatabase database}) {}
}
