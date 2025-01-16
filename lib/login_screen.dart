import 'package:flutter/material.dart';
import 'admin_dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() {
    // Contoh validasi sederhana (hanya untuk demonstrasi)
    if (_usernameController.text == 'admin' &&
        _passwordController.text == 'admin123') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AdminDashboardScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid username or password'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.admin_panel_settings,
                size: 100,
                color: Colors.amber,
              ),
              const SizedBox(height: 20),
              const Text(
                'Admin Login',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.amber,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: _usernameController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Username',
                  labelStyle: const TextStyle(color: Colors.amber),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.amber),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.amber, width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.grey[850],
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                obscureText: true,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: const TextStyle(color: Colors.amber),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.amber),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.amber, width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.grey[850],
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.black,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
