import 'dart:io';
import 'package:farmer_app/pages/app/pages/chat_page.dart';
import 'package:farmer_app/pages/app/services/create_pdf.dart';
import 'package:farmer_app/pages/app/services/gemini_services.dart';
import 'package:farmer_app/pages/app/services/get_curr_weather.dart';
import 'package:farmer_app/pages/app/services/get_soilper.dart';
import 'package:farmer_app/pages/app/services/get_temppercetage.dart';
import 'package:farmer_app/pages/app/services/pdf_extractor.dart';
import 'package:farmer_app/pages/app/services/peecenateg_pie_chart.dart';
import 'package:farmer_app/pages/app/widgets/media_container.dart';
import 'package:farmer_app/pages/app/widgets/parse_josn.dart';
import 'package:farmer_app/pages/app/widgets/pie_chart_dipaly.dart';
import 'package:farmer_app/pages/auth/screens/live_location.dart';
import 'package:farmer_app/pages/auth/widgets/custom_appbar.dart';
import 'package:farmer_app/pages/auth/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController cropName = TextEditingController();
  File? selectedPdf;
  String extractedText = "";
  File? selectedImage;
  List<File> mediaData = [];
  final picker = ImagePicker();
  double rainfall = 0;
  double humidity = 0;
  double nitrogen = 0;
  double phosphorus = 0;
  String calculatedArea = "";
  String soilpercentage = "";
  String city = "";
  double temp_diff = 0;

  Future<void> getArea() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? area = prefs.getString('enclosedArea');
    setState(() {
      calculatedArea = area ?? "0"; // Use the retrieved area or default to "0"
    });
  }

  Future<void> upadte_city() async {
    String d = await getCityName();
    setState(() {
      city = d;
    });
  }

  Future<void> getlocation_percenate() async {
    try {
      // Add a 10-second delay

      // Step 1: Get the city name
      String cityName = await getCityName();

      // Step 2: Get the average temperature percentage for the city
      double averagePercentage = await getAverageTemperaturePercentage(
        cityName,
      );

      // Step 3: Fetch the current weather data for the city
      Map<String, dynamic> weatherData = await fetchWeatherData(cityName);

      // Step 4: Calculate the percentage difference
      double currentTemperature = weatherData['temperature'] ?? 0;
      double percentageDifference =
          ((currentTemperature - averagePercentage) / averagePercentage) * 100;
      print("this is the temp_diff " + percentageDifference.toString());

      // Step 5: Update the state with the calculated percentage
      setState(() {
        temp_diff = percentageDifference + 100.00;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error fetching location percentage: ${e.toString()}'),
        ),
      );
    }
  }

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    setState(() {
      isLoading = true;
    });
    await getArea(); // Fetch the area when the page initializes
    await upadte_city();
    await getlocation_percenate();
    setState(() {
      isLoading = false;
    });
  }

  Map<String, String> collectPdfData() {
    Map<String, String> pdfData = {};

    // Crop Name
    pdfData['crop_name'] = cropName.text;

    // Gemini Extracted Text
    pdfData['gemini_response'] = extractedText;

    // Soil Parameters
    pdfData['phosphorus'] = phosphorus.toString();
    pdfData['nitrogen'] = nitrogen.toString();
    pdfData['humidity'] = humidity.toString();
    pdfData['rainfall'] = rainfall.toString();
    pdfData['soil_percentage'] = soilpercentage;

    // Image Paths (For simplicity, assuming local paths)
    for (int i = 0; i < mediaData.length; i++) {
      pdfData['image_$i'] = mediaData[i].path;
    }

    return pdfData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator(color: Colors.black))
              : SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Area Field",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        "Area of your field: $calculatedArea deca.m",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                      SizedBox(
                        height: 200,

                        child: PercentagePieChart(
                          percentage: temp_diff,
                          filledColor: Colors.green,
                          unfilledColor: Colors.red,
                        ),
                      ),
                      const Text(
                        "Crop Details",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      CustomTextfield(
                        controller: cropName,
                        hintText: "Enter your Crop Name",
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                        ),
                        onPressed: () async {
                          final pickedFile = await picker.pickImage(
                            source: ImageSource.gallery,
                          );
                          if (pickedFile == null) return;
                          setState(() {
                            selectedImage = File(pickedFile.path);
                            mediaData.add(selectedImage!);
                          });
                        },
                        icon: const Icon(Icons.image, color: Colors.black),
                        label: const Text(
                          "Select Crop Image",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),
                      mediaData.isNotEmpty
                          ? SizedBox(
                            height: 90,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: mediaData.length,
                              itemBuilder: (context, index) {
                                return MediaConatiner(
                                  mediaUrl: mediaData[index],
                                  ontap: () {
                                    setState(() {
                                      mediaData.removeAt(index);
                                    });
                                  },
                                );
                              },
                            ),
                          )
                          : const SizedBox(),
                      const SizedBox(height: 10),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                        ),
                        onPressed: () async {
                          try {
                            setState(() {
                              isLoading = true;
                            });

                            FilePickerResult? result = await FilePicker.platform
                                .pickFiles(
                                  type: FileType.custom,
                                  allowedExtensions: ['pdf', 'doc', 'docx'],
                                );
                            if (result != null) {
                              setState(() {
                                selectedPdf = File(result.files.single.path!);
                              });
                            }

                            String data = extract_text(selectedPdf!);

                            String geminiPdfResponse = await getAIResponse(
                              "$data\n\nYou are given data extracted from a soil certificate. Analyze the content and extract the following parameters:\n- phosphorus\n- nitrogen\n- pH level\n- rainfall\n- temperature\n- humidity\n\nIf any parameter is missing, put realistic values based on context or whatever you feel is good values for them but don't make any values empty.\n\nReturn a JSON object with keys: \"phosphorus\", \"nitrogen\", \"ph\", \"rainfall\", \"temperature\", \"humidity\".\n\nEnsure the JSON is formatted correctly without any extra text, explanation, or unnecessary information.",
                            );

                            Map<String, dynamic> soilData = {};
                            try {
                              soilData = Map<String, dynamic>.from(
                                await parseJson(geminiPdfResponse),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "Error parsing Gemini response: ${e.toString()}",
                                  ),
                                ),
                              );
                            }
                            var soilper = await getSoilPercentage(
                              nitrogen,
                              phosphorus,
                              43,
                              double.tryParse(soilData['ph'].toString()) ?? 0,
                              double.tryParse(
                                    soilData['temperature'].toString(),
                                  ) ??
                                  0,
                              rainfall,
                              humidity,
                              cropName.text,
                            );

                            setState(() {
                              extractedText = geminiPdfResponse;
                              soilpercentage = soilper;
                              phosphorus =
                                  double.tryParse(
                                    soilData['phosphorus'].toString(),
                                  ) ??
                                  0;
                              nitrogen =
                                  double.tryParse(
                                    soilData['nitrogen'].toString(),
                                  ) ??
                                  0;
                              humidity =
                                  double.tryParse(
                                    soilData['humidity'].toString(),
                                  ) ??
                                  0;
                              rainfall =
                                  double.tryParse(
                                    soilData['rainfall'].toString(),
                                  ) ??
                                  0;
                            });
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Error picking file: ${e.toString()}',
                                ),
                              ),
                            );
                          } finally {
                            setState(() {
                              isLoading = false;
                            });
                          }
                        },
                        icon: const Icon(
                          Icons.upload_file,
                          color: Colors.black,
                        ),
                        label: const Text(
                          "Upload Soil Certificate",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      extractedText.isNotEmpty
                          ? Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.teal[50],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              extractedText,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                          : const SizedBox(),
                      const SizedBox(height: 20),
                      selectedPdf != null
                          ? Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  height: 230,
                                  child: PieChartDipaly(
                                    phophporus: phosphorus,
                                    nitrogen: nitrogen,
                                    humidity: humidity,
                                    rainfall: rainfall,
                                  ),
                                ),
                                Positioned(
                                  child: Text(
                                    'Soil Percentage\n      ${soilpercentage}%',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 17,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                          : SizedBox(),
                      selectedPdf != null
                          ? const SizedBox(height: 10)
                          : SizedBox(),
                      selectedPdf != null
                          ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              legendRow(Colors.blue, "Phosphorus"),
                              legendRow(Colors.red, "Nitrogen"),
                              legendRow(Colors.green, "Humidity"),
                              legendRow(Colors.yellow, "Rainfall"),
                            ],
                          )
                          : SizedBox(),
                      const SizedBox(height: 20),
                      selectedPdf != null && mediaData.isNotEmpty
                          ? Center(
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal,
                              ),
                              onPressed: () {
                                Map<String, String> pdfData = collectPdfData();

                                // Debug Print
                                print("Collected Data: $pdfData");
                                generatePdf(pdfData);
                              },
                              icon: const Icon(
                                Icons.picture_as_pdf,
                                color: Colors.white,
                              ),
                              label: const Text(
                                "Generate Certificate",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          )
                          : SizedBox(),
                    ],
                  ),
                ),
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ChatPage()),
          );
        },
        child: Icon(Icons.chat, color: Colors.teal[100], size: 30),
        backgroundColor: Colors.teal,
      ),
    );
  }

  Widget legendRow(Color color, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(width: 15, height: 15, color: color),
          const SizedBox(width: 5),
          Text(label),
        ],
      ),
    );
  }
}
