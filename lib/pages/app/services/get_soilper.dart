import 'dart:convert';

import 'package:http/http.dart' as http;

Future<String> getSoilPercentage(
  double n,
  double p,
  double k,
  double ph,
  double temp,
  double rainfall,
  double humidity,
  String crop,
) async {
  try {
    // Autofill null values with 0
    n = n;
    p = p;
    k = k;
    ph = ph;
    temp = temp;
    rainfall = rainfall;
    humidity = humidity;

    var response = await http.post(
      Uri.parse('https://crop-backend-1-04mb.onrender.com/predict'),
      body: jsonEncode({
        "N": n,
        "P": p,
        "K": k,
        "temperature": temp,
        "humidity": humidity,
        "ph": ph,
        "rainfall": rainfall,
        "desired_crop": crop,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      print('Successfully registered the station complaint');
      print(response.body);
    } else {
      print('Failed to register the station complaint: ${response.body}');
    }
    var decodedResponse = jsonDecode(response.body);
    String per = decodedResponse["predicted_crop_score"].toString();
    return per;
  } catch (e) {
    return e.toString();
  }
}
