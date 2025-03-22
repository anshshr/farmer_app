import 'package:farmer_app/pages/app/pages/account_page.dart';
import 'package:farmer_app/pages/app/pages/home_page.dart';
import 'package:farmer_app/pages/app/pages/schemes_page.dart';
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
    pages = [HomePage(), SchemeListPage(), AccountPage()];
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
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_box),
            label: 'Projects',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
        ],
      ),
    );
  }
}
