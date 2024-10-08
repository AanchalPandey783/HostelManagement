import 'package:minor_proj/data/types/ratingsdata.dart';
import 'package:minor_proj/resources/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  _StatisticsScreenState createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  late List<Rating> _ratings;
  late List<_DataPoint> _chartData;

  @override
  void initState() {
    super.initState();
    _chartData = [];
    _fetchRatings();
  }

  void _fetchRatings() async {
    //DateTime now = DateTime.now();
    //Timestamp formattedDate = Timestamp.fromDate(now);
    //print(formattedDate);
    final snapshot = await FirebaseFirestore.instance
        .collection('ratings')
        //.where('timestamp', isGreaterThanOrEqualTo: formattedDate)
        //.orderBy('timestamp', descending: true) // Maintain descending order
        .get();

    setState(() {
      _ratings = snapshot.docs.map((doc) {
        final data = doc.data();
        return Rating(
          userId: data['userId'],
          rating: data['rating'].toDouble(),
          timestamp: data['timestamp'].toTimestamp(),
        );
      }).toList();
      print(_ratings);

      _chartData = _calculateStatistics(_ratings);
    });
  }

  List<_DataPoint> _calculateStatistics(List<Rating> ratings) {
    final statistics = <String, double>{};

    for (final rating in ratings) {
      final id = rating.userId;

      if (statistics.containsKey(id)) {
        statistics[id] = (statistics[id]! + rating.rating) / 2;
      } else {
        statistics[id] = rating.rating;
      }
      }

      return statistics.entries.map((entry) {
        return _DataPoint(entry.key, entry.value);
      }).toList();
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: Center(
          child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 15, 16, 18).withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: //_chartData.isNotEmpty?
                  Container(
                                height: 200,
                                width: 300,
                                child: Column(
                  children: [
                    const Text(
                      "Today's Mess Rating",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.none,
                        color: Colors.black,
                      ),
                    ),
                    Container(
                      height: 150,
                      width: 300,
                      child: SfCartesianChart(
                        primaryXAxis: CategoryAxis(),
                        series: <ColumnSeries<_DataPoint, String>>[
                          ColumnSeries<_DataPoint, String>(
                            dataSource: _chartData,
                            xValueMapper: (_DataPoint data, _) => data.date,
                            yValueMapper: (_DataPoint data, _) => data.rating,
                          ),
                        ],
                      ),
                    ),
                  ],
                                ),
                              )
              //:
              //        const Center(
              //           child: Text(
              //             "No Ratings Till Now X_X",
              //             style: TextStyle(
              //               fontSize: 25,
              //               fontWeight: FontWeight.bold,
              //               decoration: TextDecoration.none,
              //               color: Colors.black,
              //             ),
              //           ),
              //         ),
              ),
        ),
      );
    }
  }


class _DataPoint {
  final String date;
  final double rating;

  _DataPoint(this.date, this.rating);
}
