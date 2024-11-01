import 'package:floor/floor.dart';
import 'todo_item.dart';

@dao
abstract class TodoItemDao {
  @Query('SELECT * FROM TodoItem')
  Future<List<TodoItem>> fetchTodoItems();

  @insert
  Future<void> insertTodoItem(TodoItem item);

  @delete
  Future<void> deleteTodoItem(TodoItem item);
}
