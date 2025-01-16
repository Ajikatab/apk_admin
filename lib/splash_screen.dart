import 'package:flutter/material.dart';
import 'login_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Memastikan navigasi dilakukan setelah frame pertama
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 3), () {
        // Navigasi ke LoginScreen setelah delay
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      });
    });

    return Scaffold(
      backgroundColor: Colors.black87,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.admin_panel_settings,
              size: 100,
              color: Colors.amber,
            ),
            SizedBox(height: 20),
            Text(
              'Admin Dashboard',
              style: TextStyle(
                color: Colors.amber,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
