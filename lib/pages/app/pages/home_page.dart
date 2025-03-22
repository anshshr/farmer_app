import 'dart:io';

import 'package:farmer_app/pages/app/pages/chat_page.dart';
import 'package:farmer_app/pages/app/services/create_pdf.dart';
import 'package:farmer_app/pages/app/services/gemini_services.dart';
import 'package:farmer_app/pages/app/services/get_soilper.dart';
import 'package:farmer_app/pages/app/services/pdf_extractor.dart';
import 'package:farmer_app/pages/app/widgets/media_container.dart';
import 'package:farmer_app/pages/app/widgets/parse_josn.dart';
import 'package:farmer_app/pages/app/widgets/pie_chart_dipaly.dart';
import 'package:farmer_app/pages/auth/widgets/custom_appbar.dart';
import 'package:farmer_app/pages/auth/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
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
  List mediaData = [];
  final picker = ImagePicker();
  double rainfall = 0;
  double humidity = 0;
  double nitrogen = 0;
  double phosphorus = 0;
  String calculatedArea = "";
  Future<void> getArea() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? area = prefs.getString('enclosedArea');
    setState(() {
      calculatedArea = area ?? "0"; // Use the retrieved area or default to "0"
    });
  }

  @override
  void initState() {
    super.initState();
    getArea(); // Fetch the area when the page initializes
    String soilpercentage = "";

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
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15),
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
                  style: const TextStyle(fontSize: 16, color: Colors.black54),
                ),
                const Text(
                  "Crop Details",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                CustomTextfield(
                  controller: cropName,
                  hintText: "Enter your Crop Name",
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                  onPressed: () async {
                    final pickedFile = await picker.pickImage(
                      source: ImageSource.gallery,
                    );
                    if (pickedFile == null) return;
                    setState(() {
                      selectedImage = File(pickedFile.path);
                      mediaData.add(selectedImage);
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
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                  onPressed: () async {
                    try {
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

                      // Updated prompt
                      String geminiPdfResponse = await getAIResponse(
                        "$data\n\nYou are given data extracted from a soil certificate. Analyze the content and extract the following parameters:\n- phosphorus\n- nitrogen\n- pH level\n- rainfall\n- temperature\n- humidity\n\nIf any parameter is missing, put a  realistic values based on context or whatever you feel is good values for them but dont make any values empty.\n\nReturn a JSON object with keys: \"phosphorus\", \"nitrogen\", \"ph\", \"rainfall\", \"temperature\", \"humidity\".\n\nEnsure the JSON is formatted correctly without any extra text, explanation, or unnecessary information.",
                      );

                      print("Gemini Response: $geminiPdfResponse");

                      // Parse JSON safely
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
                        double.tryParse(soilData['temprature'].toString()) ?? 0,
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
                            double.tryParse(soilData['nitrogen'].toString()) ??
                            0;
                        humidity =
                            double.tryParse(soilData['humidity'].toString()) ??
                            0;
                        rainfall =
                            double.tryParse(soilData['rainfall'].toString()) ??
                            0;
                      });
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error picking file: ${e.toString()}'),
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.upload_file, color: Colors.black),
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
                        style: const TextStyle(fontWeight: FontWeight.bold),
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
                selectedPdf != null ? const SizedBox(height: 10) : SizedBox(),
                selectedPdf != null
                    ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        legendRow(Colors.blue, "Phosphorus"),
                        legendRow(Colors.green, "Nitrogen"),
                        legendRow(Colors.orange, "Humidity"),
                        legendRow(Colors.purple, "Rainfall"),
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
                        icon: const Icon(Icons.picture_as_pdf),
                        label: const Text("Generate Certificate"),
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
}
