import 'package:farmer_app/pages/app/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';

class IdentificationPage extends StatelessWidget {
  IdentificationPage({super.key});
  TextEditingController aadhar = TextEditingController();
  TextEditingController pan = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: 240,
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Please Enter any One of the details",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              CustomTextfield(
                controller: aadhar,
                hintText: 'Enter Your Aadhar card Number',
                inputType: TextInputType.phone,
              ),

              CustomTextfield(
                controller: pan,
                hintText: 'Enter Your PAN CARD number',
                inputType: TextInputType.phone,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
