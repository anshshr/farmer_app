import 'dart:convert';
import 'package:http/http.dart' as http;

Future<double> getAverageTemperaturePercentage(String city) async {
  try {
    final url = Uri.parse(
      "https://weather-p7b0.onrender.com/monthwise-data/$city",
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);

      double totalTemp = 0;

      for (var monthData in data) {
        double minTemp = monthData['Mean_Temp_Min'];
        double maxTemp = monthData['Mean_Temp_Max'];
        double avgTemp = (minTemp + maxTemp) / 2;
        totalTemp += avgTemp;
      }

      double avgTempYear = totalTemp / data.length;
      double percentage = (avgTempYear / 100) * 100; // Assuming 100°C scale

      print("Average Temperature: ${avgTempYear.toStringAsFixed(2)} °C");
      print("Percentage: ${percentage.toStringAsFixed(2)}%");

      return percentage;
    } else {
      print("API Call Failed with status: ${response.statusCode}");
      return 0;
    }
  } catch (e) {
    print("Error occurred: $e");
    return 0;
  }
}
