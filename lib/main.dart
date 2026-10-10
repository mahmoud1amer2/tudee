import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/task_model.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(TaskAdapter());

  await Hive.openBox<Task>('tasksBox');

  runApp(const TudeeApp());
}

class TudeeApp extends StatelessWidget {
  const TudeeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tudee',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFFCEEED),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF38BDF8),
          elevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}