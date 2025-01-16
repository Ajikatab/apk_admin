import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class TweetScreen extends StatelessWidget {
  Future<void> _showDeleteConfirmation(
      BuildContext context, String documentId) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi Hapus'),
          content: Text('Apakah Anda yakin ingin menghapus tweet ini?'),
          actions: [
            TextButton(
              child: Text('Batal'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Hapus', style: TextStyle(color: Colors.red)),
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('tweet')
                    .doc(documentId)
                    .delete();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Timeline'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: () async {
              // Implementasi refresh di sini
              await Future.delayed(Duration(seconds: 1));
            },
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('tweet')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                return ListView(
                  physics: AlwaysScrollableScrollPhysics(),
                  children: [
                    Container(
                      color: Colors.white,
                      child: Column(
                        children: snapshot.data!.docs.map((document) {
                          final data = document.data() as Map<String, dynamic>?;
                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      backgroundImage: NetworkImage(
                                        data?['profileImage'] ??
                                            'https://via.placeholder.com/150',
                                      ),
                                      radius: 25,
                                    ),
                                    SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                data?['username'] ?? 'Unknown',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              SizedBox(width: 8),
                                              Text(
                                                data != null &&
                                                        data.containsKey(
                                                            'timestamp')
                                                    ? DateFormat.yMMMd()
                                                        .add_jm()
                                                        .format(
                                                            data['timestamp']
                                                                .toDate())
                                                    : 'No date',
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 14,
                                                ),
                                              ),
                                              Spacer(),
                                              IconButton(
                                                icon: Icon(Icons.delete,
                                                    size: 20),
                                                onPressed: () =>
                                                    _showDeleteConfirmation(
                                                        context, document.id),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            data != null &&
                                                    data.containsKey('content')
                                                ? data['content']
                                                : 'No content available',
                                            style: TextStyle(fontSize: 15),
                                          ),
                                          SizedBox(height: 12),
                                          Row(
                                            children: [
                                              Icon(Icons.favorite_border,
                                                  size: 20, color: Colors.grey),
                                              SizedBox(width: 4),
                                              Text(
                                                (data?['likes']
                                                            as List<dynamic>?)
                                                        ?.length
                                                        .toString() ??
                                                    '0',
                                                style: TextStyle(
                                                    color: Colors.grey),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(height: 1),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
