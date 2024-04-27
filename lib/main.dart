import 'package:flutter/material.dart';
import 'package:todolist/screens/tasks_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'To-Do',
      theme: ThemeData(
        // configure app theme
        colorScheme: ColorScheme.fromSeed(
          // set primary color
          seedColor: const Color.fromARGB(255, 7, 141, 0),
        ),
        useMaterial3: true, // enable material 3 design elements
      ),
      home: const TasksScreen(),
    );
  }
}
