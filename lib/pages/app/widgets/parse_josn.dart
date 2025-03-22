
import 'dart:convert';

Future<Map<String, dynamic>> parseJson(String response) async {
  // Remove any non-JSON text (sometimes Gemini adds unwanted text)
  String jsonString = response.trim();
  int start = jsonString.indexOf("{");
  int end = jsonString.lastIndexOf("}") + 1;
  jsonString = jsonString.substring(start, end);

  return json.decode(jsonString);
}