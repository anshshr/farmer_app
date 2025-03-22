import 'dart:io';

import 'package:farmer_app/pages/auth/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class addressPage extends StatefulWidget {
  addressPage({super.key});

  @override
  State<addressPage> createState() => _addressPageState();
}

class _addressPageState extends State<addressPage> {
  TextEditingController village = TextEditingController();
  TextEditingController district = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController country = TextEditingController();
  TextEditingController postalCode = TextEditingController();
  File? file;

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
      );

      if (result != null) {
        setState(() {
          file = File(result.files.single.path!);
          ;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking file: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: 450,
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Address Details",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              CustomTextfield(
                controller: village,
                hintText: 'Enter Your Village name',
              ),
              CustomTextfield(
                controller: district,
                hintText: 'Enter Your District name',
              ),
              CustomTextfield(
                controller: state,
                hintText: 'Enter Your state name',
              ),
              CustomTextfield(
                controller: country,
                hintText: 'Enter Your country name',
              ),
              CustomTextfield(
                controller: postalCode,
                hintText: 'Enter Your postalCode ',
                inputType: TextInputType.phone,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
