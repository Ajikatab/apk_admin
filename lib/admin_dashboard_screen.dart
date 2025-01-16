import 'package:flutter/material.dart';
import 'customer_screen.dart';
import 'tweet_screen.dart';
import 'login_screen.dart'; // Add this import for the login screen

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  _AdminDashboardScreenState createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const CustomerScreen(),
    const TweetScreen(),
  ];

  final List<String> _titles = [
    'Manage Customers',
    'Tweets',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          _titles[_currentIndex],
          style: const TextStyle(color: Colors.amber),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout,
                color: Colors.amber), // Changed to logout icon
            onPressed: () {
              // Navigate to login screen and remove all previous routes
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (Route<dynamic> route) => false,
              );
            },
          ),
        ],
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: Colors.black,
        selectedItemColor: Colors.amber,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Customers',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble),
            label: 'Tweets',
          ),
        ],
      ),
    );
  }
}
