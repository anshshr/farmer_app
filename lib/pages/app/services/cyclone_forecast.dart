import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:fl_chart/fl_chart.dart';

class CycloneForecastScreen extends StatefulWidget {
  const CycloneForecastScreen({super.key});

  @override
  State<CycloneForecastScreen> createState() => _CycloneForecastScreenState();
}

class _CycloneForecastScreenState extends State<CycloneForecastScreen> {
  String cityName = "Loading...";
  Map<String, dynamic>? forecastData;
  bool isLoading = true;

  // Function to fetch city name and send POST request
  Future<void> fetchAndSendCityName() async {
    try {
      // Get city name
      String city = await getCityName();

      // Send POST request
      final response = await http.post(
        Uri.parse('https://cyclone-9le6.onrender.com/forecast'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"city": city}),
      );

      if (response.statusCode == 200) {
        // Parse the response
        Map<String, dynamic> data = jsonDecode(response.body);
        setState(() {
          cityName = data['city'];
          forecastData = data;
          isLoading = false;
        });
      } else {
        setState(() {
          cityName = "Error fetching forecast";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        cityName = "Error: ${e.toString()}";
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchAndSendCityName();
  }

  // Function to get city name
  Future<String> getCityName() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return "Location services disabled";
      }

      // Check permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission != LocationPermission.whileInUse &&
            permission != LocationPermission.always) {
          return "Permission denied";
        }
      }

      // Get current location
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
      );

      // Reverse geocoding to get placemark
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      String city = placemarks.first.locality ?? "City not found";
      print(city);
      return city;
    } catch (e) {
      print(e.toString());
      return "Error: ${e.toString()}";
    }
  }

  // Build Bar Chart
  Widget buildBarChart() {
    if (forecastData == null || forecastData!['forecast'] == null) {
      return const Center(child: Text("No forecast data available"));
    }

    final List<dynamic> forecasts = forecastData!['forecast'];

    // Group forecasts by year
    Map<int, List<dynamic>> groupedByYear = {};
    for (var forecast in forecasts) {
      int year = forecast['Year'];
      if (!groupedByYear.containsKey(year)) {
        groupedByYear[year] = [];
      }
      groupedByYear[year]!.add(forecast);
    }

    // Define colors for seasons
    final List<Color> seasonColors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.red,
    ];

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 100,
        minY: 0,
        groupsSpace: 20,
        barGroups:
            groupedByYear.entries.map((entry) {
              final year = entry.key;
              final yearForecasts = entry.value;

              return BarChartGroupData(
                x: groupedByYear.keys.toList().indexOf(year),
                barRods:
                    yearForecasts.map((forecast) {
                      final seasonIndex = [
                        'JF',
                        'MAM',
                        'JJAS',
                        'OND',
                      ].indexOf(forecast['Season']);
                      return BarChartRodData(
                        toY: forecast['Cyclone_Probability'].toDouble(),
                        color: seasonColors[seasonIndex],
                        width: 15,
                        borderRadius: BorderRadius.circular(4),
                        backDrawRodData: BackgroundBarChartRodData(
                          show: true,
                          toY: 100,
                          color: Colors.grey.withOpacity(0.2),
                        ),
                      );
                    }).toList(),
              );
            }).toList(),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final year = groupedByYear.keys.toList()[value.toInt()];
                return Text(
                  year.toString(),
                  style: const TextStyle(fontSize: 12),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                return Text(
                  '${value.toInt()}%',
                  style: const TextStyle(fontSize: 12),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        gridData: FlGridData(show: false),
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final year = groupedByYear.keys.toList()[group.x];
              final forecast = groupedByYear[year]![rodIndex];
              return BarTooltipItem(
                '${forecast['Season']} ${year}\n'
                'Probability: ${forecast['Cyclone_Probability']}%\n'
                'Forecasted Count: ${forecast['Forecasted_Cyclone_Count']}\n',
                const TextStyle(color: Colors.white, fontSize: 15),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cyclone Forecast"), centerTitle: true),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "Forecast for $cityName",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child:
                        forecastData != null
                            ? buildBarChart()
                            : const Center(
                              child: Text("No forecast data available"),
                            ),
                  ),
                ],
              ),
    );
  }
}