import 'package:flutter/material.dart';
import 'welcome_screen.dart'; // تأكد من ضبط المسار الصحيح لصفحة WelcomeScreen

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // للتحكم واستخراج النص المدخل من قبل المستخدم
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _navigateToWelcome() {
    final String name = _nameController.text.trim();

    // الانتقال وتمرير الاسم (إذا كان الحقل فارغاً يتم تمرير اسم افتراضي مثل "Ahmed")
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => WelcomeScreen(
          userName: name.isNotEmpty ? name : 'Ahmed',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tudee')),
      body: Padding(
        padding: const EdgeInsets.only(left: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 38),
              child: Text(
                "Let's get started",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(height: 26),
            const Text(
              "What should we call you?",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 19),

            Padding(
              padding: const EdgeInsets.only(right: 24),
              child: TextField(
                controller: _nameController, // ربط حقل النص بالـ controller
                decoration: InputDecoration(
                  hintText: 'Your name',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 19),
            Padding(
              padding: const EdgeInsets.only(right: 18),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  onPressed: _navigateToWelcome,
                  child: const Text(
                    'Save',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}