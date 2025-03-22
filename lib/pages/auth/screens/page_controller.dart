import 'package:farmer_app/pages/auth/screens/bankDetails.dart';
import 'package:flutter/material.dart';
import 'package:farmer_app/pages/auth/screens/address_page.dart';
import 'package:farmer_app/pages/auth/screens/identification_page.dart';
import 'package:farmer_app/pages/auth/screens/final_submission.dart';

class PageControllerScreen extends StatefulWidget {
  @override
  _PageControllerScreenState createState() => _PageControllerScreenState();
}

class _PageControllerScreenState extends State<PageControllerScreen> {
  final PageController pageController = PageController();
  Map<String, String> userDetails = {};

  void saveDetails(Map<String, String> data) {
    userDetails.addAll(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          AddressPage(controller: pageController, onNext: saveDetails),
          IdentificationPage(controller: pageController, onNext: saveDetails),
          BankDetailsPage(controller: pageController, onNext: saveDetails),
          FinalSubmissionPage(userDetails: userDetails),
        ],
      ),
    );
  }
}
