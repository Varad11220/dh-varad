import 'package:flutter/material.dart';
import 'package:dh/Food/food_menu_page.dart'; // Import FoodMenuPage
import '../Navigation/basescaffold.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Foodie App',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: FoodServiceOption(),
    );
  }
}

class FoodServiceOption extends StatefulWidget {
  @override
  _FoodServiceOptionState createState() => _FoodServiceOptionState();
}

class _FoodServiceOptionState extends State<FoodServiceOption> {
  String _selectedOption = 'Dining In';
  int _selectedNavIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(
          child: Text(
            'Foodie App',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_outlined),
            color: Colors.black,
            onPressed: () {
              // Notification button action
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            Text(
              'Choose Your Option',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Welcome to Foodie App! Whether you're dining in, ordering for home delivery, or planning a bulk order for an event, we've got you covered.",
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            SizedBox(height: 24),
            buildOptionButton(
              context,
              label: 'Dining In',
              icon: Icons.restaurant,
              isSelected: _selectedOption == 'Dining In',
              onTap: () {
                setState(() {
                  _selectedOption = 'Dining In';
                });
              },
            ),
            SizedBox(height: 16),
            buildOptionButton(
              context,
              label: 'Home Delivery',
              icon: Icons.local_shipping,
              isSelected: _selectedOption == 'Home Delivery',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FoodMenuPage()),
                );
              },
            ),
            SizedBox(height: 16),
            buildOptionButton(
              context,
              label: 'Bulk Orders',
              icon: Icons.shopping_cart,
              isSelected: _selectedOption == 'Bulk Orders',
              onTap: () {
                setState(() {
                  _selectedOption = 'Bulk Orders';
                });
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedNavIndex,
        onTap: (int index) {
          setState(() {
            _selectedNavIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor:
                _selectedNavIndex == 0 ? Colors.orange[800] : Colors.grey[300],
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
            backgroundColor:
                _selectedNavIndex == 1 ? Colors.orange[800] : Colors.grey[300],
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
            backgroundColor:
                _selectedNavIndex == 2 ? Colors.orange[800] : Colors.grey[300],
          ),
        ],
        selectedItemColor: Colors.orange[800],
        unselectedItemColor: Colors.grey,
      ),
    );
  }

  Widget buildOptionButton(
    BuildContext context, {
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.orange[800] : Colors.grey[300],
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, 3),
              blurRadius: 5,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isSelected ? Colors.white : Colors.black),
            SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
