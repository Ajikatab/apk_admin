import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GrafikScreen extends StatelessWidget {
  const GrafikScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Tweet Statistics'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.amber,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('tweet').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No data available'));
          }

          // Proses data
          final Map<String, int> userTweetCounts = {};
          for (var doc in snapshot.data!.docs) {
            final data = doc.data() as Map<String, dynamic>;
            final username = data['username'] as String? ?? 'Unknown';

            // Hitung total tweet per pengguna
            userTweetCounts[username] = (userTweetCounts[username] ?? 0) + 1;
          }

          // Konversi ke List<UserTweetData> untuk grafik
          final List<UserTweetData> chartData = userTweetCounts.entries
              .map((e) => UserTweetData(e.key, e.value))
              .toList();

          // Debug log
          print('Chart Data: $chartData');

          return RefreshIndicator(
            onRefresh: () async {
              // Refresh data dengan memaksa rebuild StreamBuilder
              await FirebaseFirestore.instance.collection('tweet').get();
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Tweets: ${snapshot.data!.docs.length}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 400, // Atur tinggi grafik
                      child: SfCartesianChart(
                        primaryXAxis: CategoryAxis(
                          labelRotation: 45,
                          labelStyle: const TextStyle(fontSize: 10),
                        ),
                        primaryYAxis: NumericAxis(
                          title: AxisTitle(text: 'Number of Tweets'),
                          labelStyle: const TextStyle(fontSize: 10),
                        ),
                        series: <ChartSeries>[
                          ColumnSeries<UserTweetData, String>(
                            dataSource: chartData,
                            xValueMapper: (UserTweetData data, _) => data.username,
                            yValueMapper: (UserTweetData data, _) => data.totalTweets,
                            color: Colors.amber,
                            dataLabelSettings:
                                const DataLabelSettings(isVisible: true),
                          ),
                        ],
                        tooltipBehavior: TooltipBehavior(enable: true),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class UserTweetData {
  final String username;
  final int totalTweets;

  UserTweetData(this.username, this.totalTweets);
}