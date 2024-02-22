import 'package:flutter/material.dart';
import 'widgets/countCard.dart';
import 'widgets/showTasks.dart';
import 'widgets/addTasks.dart';
import 'models/todo.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<TodoTask> _todoList = [];
  List<TodoTask> _copyList = [];
  void _addNewTodo(String details, DateTime selectedDate) {
    final task = new TodoTask(
      id: DateTime.now().toString(),
      todoDetails: details,
      isCompleted: false,
      ondate: selectedDate,
    );
    setState(() {
      _todoList.add(task);
      _copyList.add(task);
    });
  }

  List<String> _filterOptions = ['All', 'Today', 'Upcoming'];
  String _currentFilter = 'All';

  void _completeTask(TodoTask obj) {
    var index = _todoList.indexOf(obj);
    final updated = new TodoTask(
      id: obj.id,
      todoDetails: obj.todoDetails,
      isCompleted: true,
      ondate: obj.ondate,
    );
    setState(() {
      _todoList.removeAt(index);
      _todoList.insert(index, updated);
    });
  }

  void _deleteTask(int index) {
    setState(() {
      _todoList.removeAt(index);
      _copyList.removeAt(index);
    });
  }

  int get _completedTaskCount {
    return _todoList
        .where((element) => element.isCompleted == true)
        .toList()
        .length;
  }

  int get _remainTaskCount {
    return _todoList
        .where((element) => element.isCompleted == false)
        .toList()
        .length;
  }

  void _filterCompletedTasks() {
    setState(() {
      _todoList =
          _todoList.where((element) => element.isCompleted == true).toList();
    });
  }

  void _filterAllTasks() {
    setState(() {
      _todoList.clear();
      _todoList = _copyList;
    });
  }

  void _filterUpcomingTasks() {
    setState(() {
      _todoList = _copyList
          .where((element) => element.ondate.isAfter(DateTime.now()))
          .toList();
    });
  }

  void _filterTodayTasks() {
    setState(() {
      _todoList = _copyList
          .where((element) =>
              element.ondate.day == DateTime.now().day &&
              element.ondate.month == DateTime.now().month &&
              element.ondate.year == DateTime.now().year)
          .toList();
    });
  }

  void _filterTasksSearch(String query) {
    setState(() {
      _todoList = _copyList
          .where((element) =>
              element.todoDetails.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _sortDate() {
    setState(() {
      _todoList.sort((a, b) => a.ondate.compareTo(b.ondate));
    });
  }

  void _showTaskAddDialog(BuildContext ctx) {
    print('Show Add Task Dialog');
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return GestureDetector(
            onTap: () {},
            child: AddTaskDialog(_addNewTodo),
            behavior: HitTestBehavior.opaque,
          );
        });
  }


  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: Text('To-do list', style: TextStyle(color: Colors.white),),
      
      backgroundColor: Color.fromARGB(255, 19, 21, 44),
      actions: <Widget>[

      ],
    );
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 0),
              child: TextField(
                onChanged: (value) {
                  _filterTasksSearch(value);
                },
                decoration: const InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  labelText: 'Search tasks',
                  labelStyle: TextStyle(color: Colors.black),
                  hintText: 'Enter task details to search...',
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25.0)),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
              ),
            ),
            DropdownButton(
              value: _currentFilter,
              items: _filterOptions
                  .map((e) => DropdownMenuItem(
                        child: Text(e),
                        value: e,
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _currentFilter = value!;
                  if (value == 'All') {
                    _filterAllTasks();
                  } else if (value == 'Today') {
                    _filterTodayTasks();
                  } else if (value == 'Upcoming') {
                    _filterUpcomingTasks();
                  }
                });
              },
            ),
            Container(
              height: (mediaQuery.size.height -
                      appBar.preferredSize.height -
                      mediaQuery.padding.top) *
                  0.4,
              child: CardCount(
                _remainTaskCount,
                _completedTaskCount,
              ),
            ),
            Container(
              height: (mediaQuery.size.height -
                      appBar.preferredSize.height -
                      mediaQuery.padding.top) *
                  0.5,
              child: TaskList(
                _todoList,
                _completeTask,
                _deleteTask,
              ),
            ),
            Container(
              child: SizedBox(
                height: (mediaQuery.size.height -
                        appBar.preferredSize.height -
                        mediaQuery.padding.top) *
                    0.1,
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () => _showTaskAddDialog(context),
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          backgroundColor: Color.fromARGB(255, 19, 21, 44)),
    );
  }
}
