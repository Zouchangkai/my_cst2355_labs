import 'package:flutter/material.dart';
import 'todo_item.dart';
import 'todo_database.dart'; // 导入数据库和 DAO 的定义

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter To Do List',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
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
  late TextEditingController _controller;
  late TodoItemDao myDAO;
  List<TodoItem> items = [];

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();

    // 初始化数据库并加载待办事项
    initDatabase().then((database) {
      myDAO = database.todoItemDao; // 修改为todoItemDao
      _loadToDoItems();
    });
  }

  Future<void> _loadToDoItems() async {
    final fetchedItems = await myDAO.fetchTodoItems();
    setState(() {
      items = fetchedItems;
    });
  }

  Future<void> _addToDoItem() async {
    if (_controller.text.isNotEmpty) {
      int newId = await _getAvailableId(); // 获取可用的 ID
      final newTodo = TodoItem(id: newId, text: _controller.text); // 创建新的 TodoItem
      await myDAO.insertTodoItem(newTodo); // 插入新的 TodoItem
      _controller.clear(); // 清空输入框
      _loadToDoItems(); // 重新加载待办事项
    }
  }

  Future<int> _getAvailableId() async {
    final existingItems = await myDAO.fetchTodoItems(); // 获取现有的待办事项
    final usedIds = existingItems.map((item) => item.id).toList(); // 获取已使用的 ID

    // 寻找可用的 ID
    int newId = 1; // 从 1 开始
    while (usedIds.contains(newId)) {
      newId++; // 递增查找
    }

    return newId; // 返回可用 ID
  }

  Future<void> _removeToDoItem(int id) async {
    final items = await myDAO.fetchTodoItems();
    final todoItem = items.firstWhere((item) => item.id == id);
    await myDAO.deleteTodoItem(todoItem);
    _loadToDoItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter To Do List'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: 'Enter a to-do item',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _addToDoItem,
                  child: const Text('Add'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: items.isEmpty
                  ? const Center(child: Text("There are no items in the list"))
                  : ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onLongPress: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Delete Item"),
                            content: const Text("Do you want to delete this item?"),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text("No"),
                              ),
                              TextButton(
                                onPressed: () {
                                  _removeToDoItem(items[index].id!);
                                  Navigator.of(context).pop();
                                },
                                child: const Text("Yes"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: ListTile(
                      leading: Text('Item ${items[index].id}:'),
                      title: Text(items[index].text),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
