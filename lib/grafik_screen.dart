import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
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
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

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

          final series = [
            charts.Series<UserData, String>(
              id: 'Users',
              domainFn: (UserData users, _) => users.date,
              measureFn: (UserData users, _) => users.count,
              data: chartData,
              colorFn: (_, __) => charts.MaterialPalette.yellow.shadeDefault,
            )
          ];

          return Padding(
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
                Expanded(
                  child: charts.BarChart(
                    series,
                    animate: true,
                    domainAxis: const charts.OrdinalAxisSpec(
                      renderSpec: charts.SmallTickRendererSpec(
                        labelRotation: 45,
                        labelStyle: charts.TextStyleSpec(
                          fontSize: 10,
                        ),
                      ),
                    ),
                    primaryMeasureAxis: const charts.NumericAxisSpec(
                      tickProviderSpec: charts.BasicNumericTickProviderSpec(
                        desiredTickCount: 6,
                      ),
                      renderSpec: charts.GridlineRendererSpec(
                        labelStyle: charts.TextStyleSpec(
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
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
