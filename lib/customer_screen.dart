import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CustomerScreen extends StatelessWidget {
  const CustomerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Data'),
        backgroundColor: Colors.black87,
      ),
      body: const CustomerDataList(),
    );
  }
}

class CustomerDataList extends StatelessWidget {
  const CustomerDataList({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      // Mengubah stream untuk mengambil dari collection 'user'
      stream: FirebaseFirestore.instance.collection('user').snapshots(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No users found'));
        }

        final users = snapshot.data!.docs;

        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final userData = users[index].data() as Map<String, dynamic>;

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
              color: Colors.black87,
              child: ExpansionTile(
                // Mengubah untuk menampilkan email
                title: Text(
                  userData['email'] ?? 'No Email',
                  style: const TextStyle(color: Colors.amber, fontSize: 16),
                ),
                collapsedIconColor: Colors.amber,
                iconColor: Colors.amber,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Hanya menampilkan createdAt
                        _buildInfoRow('Created At',
                            userData['createdAt']?.toString() ?? 'N/A'),
                        const SizedBox(height: 8),
                        _buildInfoRow('Email', userData['email'] ?? 'N/A'),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.amber,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
