import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'todo_item.dart';

part 'todo_database.g.dart';

@dao
abstract class TodoItemDao {
  @Query('SELECT * FROM TodoItem')
  Future<List<TodoItem>> fetchTodoItems();

  @insert
  Future<void> insertTodoItem(TodoItem item);

  @delete
  Future<void> deleteTodoItem(TodoItem item);
}

@Database(version: 1, entities: [TodoItem])
abstract class AppDatabase extends FloorDatabase {
  TodoItemDao get todoItemDao; // 确保 getter 名称一致
}

Future<AppDatabase> initDatabase() async {
  final database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  return database;
}
