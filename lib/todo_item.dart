import 'package:floor/floor.dart';

@Entity(tableName: 'TodoItem')
class TodoItem {
  @primaryKey
  final int? id;  // 使用 int? 表示 ID 可以为空
  final String text;

  TodoItem({this.id, required this.text});
}
