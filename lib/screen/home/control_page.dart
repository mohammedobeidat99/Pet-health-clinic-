import 'package:flutter/material.dart';
import 'package:pethhealth/components/applocal.dart';
import 'package:pethhealth/constant/color.dart';
import 'package:pethhealth/screen/home/home_screen.dart';
import 'package:pethhealth/screen/home/store_pages/cart_screen.dart';
import 'package:pethhealth/screen/home/store_pages/store_screen.dart';
import 'package:pethhealth/screen/home/profile/profile_screen.dart';
import 'package:pethhealth/screen/home/vet/vet_screen.dart';

class BottomNavigationExample extends StatefulWidget {
  const BottomNavigationExample({super.key});

  @override
  _BottomNavigationExampleState createState() =>
      _BottomNavigationExampleState();
}

class _BottomNavigationExampleState extends State {
  int _selectedTab = 0;

  List _pages = [
    const HomeScreen(),
    const StoreScreen(),
    
    // CartPage(),
    BookingScreen(),
   const ProfileScreen(),
  ];

  _changeTab(int index) {
    setState(() {
      _selectedTab = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedTab],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTab,
        onTap: (index) => _changeTab(index),
        selectedItemColor: mainColor2,
        unselectedItemColor: Colors.grey,
        items: [
           BottomNavigationBarItem(icon: Icon(Icons.home), label: getLang(context, 'home')),
           BottomNavigationBarItem(icon: Icon(Icons.store), label:getLang(context, 'store')),
           
                BottomNavigationBarItem(icon:  Icon(Icons.date_range_outlined), label:getLang(context, 'booking')),
           BottomNavigationBarItem(icon: Icon(Icons.person), label:getLang(context, 'profile')),
        ],
      ),
    );
  }
}
