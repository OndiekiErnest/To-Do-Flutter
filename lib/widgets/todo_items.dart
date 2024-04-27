import 'package:flutter/material.dart';
import 'package:todolist/model/todo.dart';

class ToDoItem extends StatelessWidget {
  final ToDo todo; // The ToDo object associated with this item
  final Function(ToDo) onToDoChanged; // function for task status change
  final Function(String) onDeleteItem; // function for task deletion
  final Function(ToDo) onToDoEdit; // function to edit task

  // constructor for the ToDoItem, takes required parameters
  const ToDoItem(
      {super.key,
      required this.todo,
      required this.onToDoChanged,
      required this.onDeleteItem,
      required this.onToDoEdit});

  @override
  Widget build(BuildContext context) {
    return Container(
      // Set margin for the ListTile container
      margin: const EdgeInsets.only(bottom: 20),
      child: ListTile(
        onTap: () {
          // Invoke callback function when the item is tapped
          onToDoChanged(todo);
        },
        shape: const RoundedRectangleBorder(
          // Set rounded corners for the ListTile
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
        ),
        // Set content padding
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        // Set background color of the ListTile
        tileColor: const Color.fromARGB(255, 238, 238, 238),
        leading: Icon(
            // Display check box icon based on completion status
            todo.isDone ? Icons.check_box : Icons.check_box_outline_blank,
            // Set icon/checkbox color to blue
            color: Colors.blue),
        title: Text(
          todo.todoText, // Display the task text
          style: TextStyle(
              fontSize: 16,
              color: Colors.black,
              // Apply strikethrough decoration if task is completed
              decoration: todo.isDone ? TextDecoration.lineThrough : null),
        ),
        trailing: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () {
                // Invoke callback function when delete button is pressed, passing task ID
                onToDoEdit(todo);
              },
              icon: const Icon(
                Icons.edit,
                size: 20,
                // Set the delete icon color to white
                color: Color.fromARGB(255, 7, 141, 0),
              ),
            ),
            IconButton(
              onPressed: () {
                // Invoke callback function when delete button is pressed, passing task ID
                onDeleteItem(todo.id);
              },
              icon: const Icon(
                Icons.delete,
                size: 20,
                // Set the delete icon color to white
                color: Color.fromARGB(255, 205, 14, 0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
