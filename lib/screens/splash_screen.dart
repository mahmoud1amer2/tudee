import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';
import 'welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkUser();
  }

  Future<void> _checkUser() async {
    final prefs = await SharedPreferences.getInstance();
    final savedName = prefs.getString('user_name');

    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    if (savedName != null && savedName.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen(userName: savedName)),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const WelcomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF38BDF8),
      body: Center(
        child: Text(
          'Tudee',
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }
}