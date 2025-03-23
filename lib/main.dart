import 'package:farmer_app/pages/app/pages/home_page.dart';
import 'package:farmer_app/pages/app/widgets/bottom_nav.dart';
import 'package:farmer_app/pages/auth/screens/cyclone_forecast_screen.dart';
import 'package:farmer_app/pages/auth/screens/page_controller.dart';
import 'package:farmer_app/pages/auth/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> _showAnimation() async {
    // await Future.delayed(const Duration(seconds: 3));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Farmer App',
      theme: ThemeData(
        primaryColor: Colors.green,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.light(
          primary: Colors.green,
          onPrimary: Colors.white,
          secondary: Colors.greenAccent,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black),
          bodyMedium: TextStyle(color: Colors.black),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
        ),
      ),
      home: FutureBuilder(
        future: _showAnimation(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(
                child: SizedBox(
                  height: 300,
                  width: 300,
                  child: ClipOval(
                    child: Image.network(
                      'https://img.etimg.com/thumb/width-1200,height-1200,imgsize-218090,resizemode-75,msid-87639947/small-biz/sme-sector/from-india-to-brazil-farmers-face-post-apocalyptic-food-crisis.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            );
          } else {
            return StreamBuilder<User?>(
              stream: auth.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  //TODO : revert back this
                  return BottomNav(userDetails: {});
                } else {
                  return BottomNav(userDetails: {});
                }
              },
            );
          }
        },
      ),
    );
  }
}
