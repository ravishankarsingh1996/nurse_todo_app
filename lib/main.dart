import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:nurse_todo_app/screens/todo_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(title: 'Nurse-To-Do', home: TodoList());
  }
}
