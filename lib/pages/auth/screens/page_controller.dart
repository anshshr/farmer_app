import 'package:farmer_app/pages/auth/screens/address_page.dart';
import 'package:farmer_app/pages/auth/screens/bankDetails.dart';
import 'package:farmer_app/pages/auth/screens/identification_page.dart';
import 'package:farmer_app/pages/auth/splash_screen.dart';
import 'package:flutter/material.dart';

class PageControllerScreen extends StatelessWidget {
   PageControllerScreen({super.key});
  final pageControllerInstance = PageController();

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: pageControllerInstance,
      allowImplicitScrolling: true,
      children: [
        SplashScreen(),
        addressPage(),
        IdentificationPage(),
        Bankdetails(),
      ],
    );
  }
}
