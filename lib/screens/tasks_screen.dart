import 'package:flutter/material.dart';
import 'package:todolist/model/todo.dart'; // Import ToDo model class
import 'package:todolist/widgets/todo_items.dart'; // import ToDoItem widget

// Enumeration to represent different task categories
enum TaskCategory {
  all,
  completed,
  pending,
}

// tasks screen / stateful widget
class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  List<ToDo> todosList = ToDo.todoList(); // list of all tasks
  List<ToDo> _foundToDo = []; // list of tasks to display based on category
  TaskCategory _selectedCategory = TaskCategory.all; // selected task category

  @override
  void initState() {
    _updateTasks(); // Initialize tasks based on selected category
    super.initState();
  }

  // Method to update the displayed tasks based on selected category
  void _updateTasks() {
    setState(() {
      switch (_selectedCategory) {
        case TaskCategory.all:
          _foundToDo = todosList; // Display all tasks
          break;
        case TaskCategory.completed:
          _foundToDo = todosList
              .where((todo) => todo.isDone)
              .toList(); // Display completed tasks
          break;
        case TaskCategory.pending:
          _foundToDo = todosList
              .where((todo) => !todo.isDone)
              .toList(); // Display pending tasks
          break;
      }
    });
  }

  // Method to handle task completion status change
  void _handleToDoChange(ToDo todo) {
    setState(() {
      todo.isDone = !todo.isDone;
      // remove todo and add it at the end of list if isDone is true
      if (todo.isDone) {
        todosList.remove(todo);
        todosList.add(todo);
      }
      _updateTasks();
    });
  }

  // Method to handle task deletion
  void _deleteToDoItem(String id) {
    setState(() {
      todosList.removeWhere((item) => item.id == id);
      _updateTasks(); // Update displayed tasks after deletion
    });
  }

  void _runFilter(String enteredkeyword) {
    List<ToDo> results = [];
    if (enteredkeyword.isEmpty) {
      results = todosList;
    } else {
      results = todosList
          .where((item) => item.todoText
              .toLowerCase()
              .contains(enteredkeyword.toLowerCase()))
          .toList();
    }
    setState(() {
      _foundToDo = results;
    });
  }

  // Method to show dialog for adding a new task
  Future<void> _showAddTaskDialog(BuildContext context) async {
    String newTaskText = ''; // Text entered by the user for the new task

    await showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Add New Task'),
          content: TextField(
            autofocus: true,
            onChanged: (value) {
              newTaskText = value; // Update newTaskText as the user types
            },
            decoration: const InputDecoration(hintText: 'Enter task...'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Add the new task to the list and update the tasks
                _addNewTask(newTaskText);
                Navigator.pop(dialogContext); // Close the dialog
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  // Method to add a new task to the list
  void _addNewTask(String taskText) {
    if (taskText.isNotEmpty) {
      // Generate a unique ID for the new task (you may use a different approach for IDs)
      String newTaskId = UniqueKey().toString();

      // Create a new ToDo object for the new task
      ToDo newTask = ToDo(
        id: newTaskId,
        todoText: taskText,
        isDone: false,
      );

      // Add the new task to the todosList
      setState(() {
        // insert new task between the last item whose isDone is false
        // and the the first item whose isDone is true
        bool wasAdded = false; // flag to check if item was added in loop
        for (int i = 0; i < todosList.length; i++) {
          if (todosList[i].isDone) {
            todosList.insert(i, newTask);
            // set flag to true
            wasAdded = true;
            break;
          }
        }
        // insert new task at the end of the list if wasAdded is false
        if (!wasAdded) {
          todosList.add(newTask);
        }
        // todosList.add(newTask);
        _updateTasks(); // Update the displayed tasks list
      });
    }
  }

  // Method to set the selected task category
  void _setSelectedCategory(TaskCategory category, BuildContext context) {
    setState(() {
      _selectedCategory = category; // Update selected category
      _updateTasks(); // Update displayed tasks based on new category
    });

    // Close the drawer and navigate to the tasks screen
    Navigator.pop(context); // Close the drawer
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 35.0),
              child: Icon(Icons.assignment),
            ),
            SizedBox(width: 8),
            Text(
              'Tasks App',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        backgroundColor: const Color.fromARGB(255, 7, 141, 0),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: Drawer(
        backgroundColor: const Color.fromARGB(255, 238, 238, 238),
        // rounded corners
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(5),
            bottomRight: Radius.circular(5),
          ),
        ),
        elevation: 0,
        child: Column(
          children: [
            const SizedBox(
                height: 40,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    'Categories',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
            ),
            // Drawer menu items for different task categories
            ListTile(
              title: const Text("All Tasks"),
              leading: const Icon(Icons.menu_outlined),
              onTap: () => _setSelectedCategory(TaskCategory.all, context),
            ),
            ListTile(
              title: const Text("Completed Tasks"),
              leading: const Icon(Icons.check_box),
              onTap: () =>
                  _setSelectedCategory(TaskCategory.completed, context),
            ),
            ListTile(
              title: const Text("Pending Tasks"),
              leading: const Icon(Icons.incomplete_circle),
              onTap: () => _setSelectedCategory(TaskCategory.pending, context),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Column(
          children: [
            // Search bar for filtering tasks
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 238, 238, 238),
                borderRadius: BorderRadius.circular(25),
              ),
              child: TextField(
                onChanged: (keyword) {
                  // search functionality
                  _runFilter(keyword);
                },
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(0),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Color(0xFF272626),
                    size: 20,
                  ),
                  prefixIconConstraints:
                      BoxConstraints(maxHeight: 20, minWidth: 25),
                  border: InputBorder.none,
                  hintText: "Search tasks",
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 40), // space between search widget and tasks
            Expanded(
              child: ListView.builder(
                itemCount: _foundToDo.length,
                itemBuilder: (context, index) => ToDoItem(
                  todo: _foundToDo[index],
                  onToDoChanged: _handleToDoChange,
                  onDeleteItem: _deleteToDoItem,
                ),
              ),
            ),
          ],
        ),
      ),
      // Floating action button to add new task
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 7, 141, 0),
        onPressed: () {
          // Show the dialog to add a new task
          _showAddTaskDialog(context);
        },
        tooltip: 'Add New Task',
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 37, 37, 37),
    );
  }
}
