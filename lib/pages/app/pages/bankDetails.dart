import 'package:farmer_app/pages/app/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';

class Bankdetails extends StatelessWidget {
  Bankdetails({super.key});
  TextEditingController bankName = TextEditingController();
  TextEditingController accountNumber = TextEditingController();
  TextEditingController ifscCode = TextEditingController();
  TextEditingController Branch = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: 350,
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Please Enter all of the details",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              CustomTextfield(
                controller: bankName,
                hintText: 'Enter Your Bank Name',
              ),
              CustomTextfield(
                controller: accountNumber,
                hintText: 'Enter Your Account Number',
                inputType: TextInputType.phone,
              ),
              CustomTextfield(
                controller: ifscCode,
                hintText: 'Enter Your IFSC code',
              ),

              CustomTextfield(
                controller: Branch,
                hintText: 'Enter Your Bank Branch',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
