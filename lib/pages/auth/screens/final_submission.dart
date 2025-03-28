import 'package:farmer_app/pages/auth/screens/crop_field_map_marker.dart';
import 'package:farmer_app/pages/auth/screens/page_controller.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FinalSubmissionPage extends StatefulWidget {
  FinalSubmissionPage({Key? key}) : super(key: key);

  @override
  _FinalSubmissionPageState createState() => _FinalSubmissionPageState();
}

class _FinalSubmissionPageState extends State<FinalSubmissionPage> {
  Map<String, String> userDetails = {};

  @override
  void initState() {
    super.initState();
    _loadUserDetails();
  }

  void _loadUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userDetails = {
        'Bank Name': prefs.getString('Bank Name') ?? '',
        'Account Number': prefs.getString('Account Number') ?? '',
        'IFSC Code': prefs.getString('IFSC Code') ?? '',
        'Branch': prefs.getString('Branch') ?? '',
        'Village': prefs.getString('Village') ?? '',
        'District': prefs.getString('District') ?? '',
        'State': prefs.getString('State') ?? '',
        'Country': prefs.getString('Country') ?? '',
        'Postal Code': prefs.getString('Postal Code') ?? '',
        'Aadhar': prefs.getString('Aadhar') ?? '',
        'PAN': prefs.getString('PAN') ?? '',
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PageControllerScreen()),
            );
          },
        ),
        title: const Text("Final Submission"),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.network(
              'https://th.bing.com/th/id/OIP.iyYZ6JRT93KJHo-2axvlVwHaF7?rs=1&pid=ImgDetMain',
              fit: BoxFit.cover,
            ),
          ),
          // Semi-transparent overlay
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.5)),
          ),
          // Main Content
          Center(
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Final Submission",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ...userDetails.entries.map(
                      (entry) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${entry.key}:",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            Flexible(
                              child: Text(
                                entry.value,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black54,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FieldMapMarker(),
                          ),
                        ); // Redirect to Homepage
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 20,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "Submit & Go to Home",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}