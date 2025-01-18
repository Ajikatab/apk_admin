import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class GrafikScreen extends StatelessWidget {
  const GrafikScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Statistics'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.amber,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('user')
            .orderBy('createdAt')
            .snapshots(),
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
          Map<String, int> usersByDay = {};
          for (var doc in snapshot.data!.docs) {
            final data = doc.data() as Map<String, dynamic>;
            if (data['createdAt'] != null) {
              final timestamp = data['createdAt'] as Timestamp;
              final date = timestamp.toDate();
              final dateStr = DateFormat('MM/dd').format(date);
              usersByDay[dateStr] = (usersByDay[dateStr] ?? 0) + 1;
            }
          }

          final List<UserData> chartData =
              usersByDay.entries.map((e) => UserData(e.key, e.value)).toList();

          return RefreshIndicator(
            onRefresh: () async {
              // Refresh data dengan memaksa rebuild StreamBuilder
              // Anda bisa menggunakan GlobalKey untuk memicu rebuild
              // atau memanggil ulang stream.
              // Contoh sederhana:
              await FirebaseFirestore.instance
                  .collection('user')
                  .orderBy('createdAt')
                  .get();
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Users: ${snapshot.data!.docs.length}',
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
                          title: AxisTitle(text: 'Number of Users'),
                          labelStyle: const TextStyle(fontSize: 10),
                        ),
                        series: <ChartSeries>[
                          ColumnSeries<UserData, String>(
                            dataSource: chartData,
                            xValueMapper: (UserData data, _) => data.date,
                            yValueMapper: (UserData data, _) => data.count,
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

class UserData {
  final String date;
  final int count;

  UserData(this.date, this.count);
}