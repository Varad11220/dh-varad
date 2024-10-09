import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Navigation/basescaffold.dart';

class EmergencyCalls extends StatelessWidget {
  const EmergencyCalls({Key? key}) : super(key: key);

  final String policePhoneNumber = '+91 7506541325'; // Emergency number for police
  final String ambulancePhoneNumber = '+91 7506541325'; // Emergency number for ambulance
  final String managerPhoneNumber = '+91 7506541325'; // Manager's contact number without '+91'

  // Method to make a phone call using url_launcher
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber.replaceAll(' ', ''), // Ensure no spaces
    );
    if (!await launchUrl(launchUri)) {
      print("Error: Could not launch $phoneNumber");
      throw 'Could not launch $phoneNumber';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: 'Emergency Contacts', // Set your title here
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildEmergencyCard(
              title: 'Call Police',
              description: 'Contact the nearest police station in case of emergency.',
              phoneNumber: policePhoneNumber,
              icon: Icons.local_police,
            ),
            _buildEmergencyCard(
              title: 'Call Ambulance',
              description: 'Get medical help during emergencies.',
              phoneNumber: ambulancePhoneNumber,
              icon: Icons.local_hospital,
            ),
            _buildEmergencyCard(
              title: 'Call Manager',
              description: 'Contact the manager for assistance.',
              phoneNumber: managerPhoneNumber,
              icon: Icons.person,
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build an emergency card
  Widget _buildEmergencyCard({
    required String title,
    required String description,
    required String phoneNumber,
    required IconData icon,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 5,
      child: ListTile(
        leading: Icon(icon, size: 40, color: Colors.red),
        title: Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(description),
        trailing: ElevatedButton(
          onPressed: () => _makePhoneCall(phoneNumber), // Call functionality
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            backgroundColor: Colors.green, // Button color
          ),
          child: const Text('Call'),
        ),
      ),
    );
  }
}