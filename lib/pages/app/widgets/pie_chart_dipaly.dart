// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PieChartDipaly extends StatelessWidget {
  double phophporus;
  double nitrogen;
  double humidity;
  double rainfall;

  PieChartDipaly({
    super.key,
    required this.phophporus,
    required this.nitrogen,
    required this.humidity,
    required this.rainfall,
  });

  @override
  Widget build(BuildContext context) {
    return PieChart(
      swapAnimationDuration: const Duration(milliseconds: 1000),
      curve: Curves.easeInOut,
      PieChartData(
        sections: [
          PieChartSectionData(value: phophporus, color: Colors.blue),
          PieChartSectionData(value: nitrogen, color: Colors.red),

          PieChartSectionData(value: humidity, color: Colors.green),
          PieChartSectionData(value: rainfall, color: Colors.yellow),
        ],
      ),
    );
  }
}
