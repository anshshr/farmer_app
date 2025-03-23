import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> fetchWeatherData(String city) async {
  const String apiKey = '55dfd2b76ad94702ab120140252303';
  final String apiUrl = 'https://api.weatherapi.com/v1/current.json?key=$apiKey&q=$city';

  try {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      double temp = data['current']['temp_c'];
      int humidity = data['current']['humidity'];

      return {
        'temperature': temp,
        'humidity': humidity,
      };
    } else {
      throw Exception('Failed to load weather data');
    }
  } catch (e) {
    print("Error fetching weather: $e");
    return {
      'temperature': null,
      'humidity': null,
    };
  }
}
