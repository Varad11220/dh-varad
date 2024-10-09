import 'package:dh/Food/food_service_options.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Navigation/basescaffold.dart'; // Import url_launcher package

class FoodCallBookPage extends StatelessWidget {
  final String imageUrl =
      'https://firebasestorage.googleapis.com/v0/b/doodleshomes-7ffe2.appspot.com/o/images%2Fcaesarsalad.png?alt=media&token=7489dc2a-6cde-4a48-95c7-86b8857e6bfe';
  final String _phoneNumber = '+91 8669727126';

  Future<void> _makePhoneCall() async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: _phoneNumber,
    );

    if (!await launchUrl(launchUri)) {
      throw Exception('Could not launch $launchUri');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: "Food Details",
      body: Center(
        child: Card(
          elevation: 5,
          margin: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  border: Border.all(
                    color: Colors.blue,
                    width: 3.0,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Image.network(
                    imageUrl,
                    height: 300, // Increased height for a larger image
                    width: double.infinity, // Full width
                    fit: BoxFit.cover, // Cover the container
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'What do you like to do ?',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  SizedBox(
                    width: 100,
                    child: ElevatedButton(
                      onPressed: _makePhoneCall,
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        backgroundColor: Colors.green, // Set button color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        shadowColor: Colors.greenAccent,
                        elevation: 5,
                      ),
                      child: const Text('Call'),
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigate to FoodMenuPage
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FoodServiceOption()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        backgroundColor: Colors.redAccent, // Set button color
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(30), // Rounded corners
                        ),
                        shadowColor: Colors.redAccent, // Shadow color
                        elevation: 5, // Elevation
                      ),
                      child: const Text('Book'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 150),
            ],
          ),
        ),
      ),
    );
  }
}
