import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;

class RiskPieChart extends StatelessWidget {
  final double riskPercentage;

  RiskPieChart({required this.riskPercentage});

  @override
  Widget build(BuildContext context) {
    return PieChart(
      PieChartData(
        sections: [
          PieChartSectionData(
            value: riskPercentage,
            color: Colors.red,
            title: '${riskPercentage.toStringAsFixed(1)}%',

            titleStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            radius: 50,
          ),
          PieChartSectionData(
            value: 100 - riskPercentage,
            color: Colors.green,
            title: '${(100 - riskPercentage).toStringAsFixed(1)}%',
            titleStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            radius: 50,
          ),
        ],
      ),
    );
  }
}

class ForecastScreen extends StatefulWidget {
  final String city;

  ForecastScreen({required this.city});

  @override
  ForecastScreenState createState() => ForecastScreenState();
}

class ForecastScreenState extends State<ForecastScreen> {
  late Future<Map<String, dynamic>> futureForecast;

  @override
  void initState() {
    super.initState();
    futureForecast = fetchForecastData();
  }

  Future<Map<String, dynamic>> fetchForecastData() async {
    try {
      // Get city name

      // Send POST request
      final response = await http.post(
        Uri.parse('https://cyclone-9le6.onrender.com/forecast'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"city": widget.city}),
      );

      if (response.statusCode == 200) {
        // Parse the response
        Map<String, dynamic> data = jsonDecode(response.body);
        // return json.decode(response.body);
        return data;
      } else {
        throw Exception('Failed to load forecast data');
      }
    } catch (e) {
      return {};
    }
  }

  double calculateRiskPercentage(List<dynamic> forecast) {
    double totalProbability = 0;
    for (var entry in forecast) {
      totalProbability += entry['Cyclone_Probability'];
    }
    return totalProbability / forecast.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cyclone Risk Analysis')),
      body: FutureBuilder<Map<String, dynamic>>(
        future: futureForecast,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No data available'));
          } else {
            final forecast = snapshot.data!['forecast'];
            final riskPercentage = calculateRiskPercentage(forecast);

            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'City: ${snapshot.data!['city']}\nRegion: ${snapshot.data!['region']}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: RiskPieChart(riskPercentage: riskPercentage),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
