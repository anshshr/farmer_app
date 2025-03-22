import 'package:farmer_app/pages/auth/widgets/custom_appbar.dart';
import 'package:farmer_app/pages/auth/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:shared_preferences/shared_preferences.dart';

class AddressPage extends StatefulWidget {
  final PageController controller;
  final Function(Map<String, String>) onNext;

  AddressPage({required this.controller, required this.onNext, Key? key})
    : super(key: key);

  @override
  _AddressPageState createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  final TextEditingController village = TextEditingController();
  final TextEditingController district = TextEditingController();
  final TextEditingController state = TextEditingController();
  final TextEditingController country = TextEditingController();
  final TextEditingController postalCode = TextEditingController();
void goToNextPage() async {
  if (village.text.isNotEmpty &&
      district.text.isNotEmpty &&
      state.text.isNotEmpty &&
      country.text.isNotEmpty &&
      postalCode.text.isNotEmpty) {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('Village', village.text);
    prefs.setString('District', district.text);
    prefs.setString('State', state.text);
    prefs.setString('Country', country.text);
    prefs.setString('Postal Code', postalCode.text);

    widget.onNext({
      'Village': village.text,
      'District': district.text,
      'State': state.text,
      'Country': country.text,
      'Postal Code': postalCode.text,
    });
    widget.controller.nextPage(
      duration: Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  'https://th.bing.com/th/id/OIP.iyYZ6JRT93KJHo-2axvlVwHaF7?rs=1&pid=ImgDetMain',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Dark Overlay
          Container(color: Colors.black.withOpacity(0.1)),

          Center(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: SingleChildScrollView(
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  elevation: 2,
                  color: Colors.white.withOpacity(0.75),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomTextfield(
                          controller: village,
                          hintText: 'Enter Your Village Name',
                          inputType: TextInputType.text,
                        ),
                        SizedBox(height: 15),
                        CustomTextfield(
                          controller: district,
                          hintText: 'Enter Your District Name',
                          inputType: TextInputType.text,
                        ),
                        SizedBox(height: 15),
                        CustomTextfield(
                          controller: state,
                          hintText: 'Enter Your State Name',
                          inputType: TextInputType.text,
                        ),
                        SizedBox(height: 15),
                        CustomTextfield(
                          controller: country,
                          hintText: 'Enter Your Country Name',
                          inputType: TextInputType.text,
                        ),
                        SizedBox(height: 15),
                        CustomTextfield(
                          controller: postalCode,
                          hintText: 'Enter Your Postal Code',
                          inputType: TextInputType.number,
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: goToNextPage,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 15,
                            ),
                          ),
                          child: Text(
                            "Next",
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
            ),
          ),
        ],
      ),
    );
  }
}
