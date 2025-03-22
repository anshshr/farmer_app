// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class CustomTextfield extends StatelessWidget {
  TextEditingController controller;
  String hintText;
  TextInputType? inputType;
  CustomTextfield({
    super.key,
    required this.controller,
    required this.hintText,
    this.inputType,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: inputType,

      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.black, width: 1),
        ),

        contentPadding: EdgeInsets.all(13),
      ),
    );
  }
}
