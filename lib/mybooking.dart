import 'package:flutter/material.dart';
import 'package:dh/Food/foodbooking.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart';
import '../Navigation/basescaffold.dart';
import 'package:dh/Services/booking_detail_page.dart';
import 'package:dh/Services/servicebooking.dart';

class MyBooking extends StatefulWidget {
  const MyBooking({Key? key}) : super(key: key);

  @override
  _MyBookingState createState() => _MyBookingState();
}

class _MyBookingState extends State<MyBooking> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  final List<Widget> _widgetOptions = <Widget>[
    Center(child: Text('Home Page', style: TextStyle(fontSize: 20))),
    Center(
        child: ServiceTab()), // Updated to display booking list for "Service"
    Center(child: FoodTab()),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: 'My Bookings',
      body: Column(
        children: [
          Expanded(child: _widgetOptions[_selectedIndex]),
          BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.miscellaneous_services), label: 'Service'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.fastfood), label: 'Food'),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.orange,
            onTap: _onItemTapped,
          ),
        ],
      ),
    );
  }
}

class ServiceTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Use the booking list UI here
    return ServiceBooking(); // Assuming `MyBooking` contains the logic for displaying the bookings
  }
}

class FoodTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Use the booking list UI here
    return FoodBooking(); // Assuming `MyBooking` contains the logic for displaying the bookings
  }
}
