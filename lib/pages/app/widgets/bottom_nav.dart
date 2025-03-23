import 'package:farmer_app/pages/app/pages/account_page.dart';
import 'package:farmer_app/pages/app/pages/features_page.dart';
import 'package:farmer_app/pages/app/pages/home_page.dart';
import 'package:farmer_app/pages/app/pages/schemes_page.dart';
import 'package:farmer_app/pages/auth/screens/final_submission.dart';
import 'package:flutter/material.dart';

class BottomNav extends StatefulWidget {
  final Map<String, String> userDetails; // Add userDetails as a parameter

  const BottomNav({required this.userDetails, super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  late List<Widget> pages;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // Pass the userDetails to the AccountPage
    pages = [HomePage(), SchemeListPage(), FeaturesPage(), AccountPage()];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        backgroundColor: Colors.black,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.black, size: 30),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_box, color: Colors.black, size: 30),
            label: 'Projects',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.dashboard_customize,
              color: Colors.black,
              size: 30,
            ),
            label: 'Features',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: Colors.black, size: 30),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}
