import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:dh/basescaffold.dart'; // Import BaseScaffold
import 'electrician.dart'; // Import individual service pages

class ServicesScreen extends StatefulWidget {
  @override
  _ServicesScreenState createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  // List of all Services names and Images
  final List<String> services = [];
  final List<String> serviceImages = [];

  // Names of a particular service's sub-services
  final List<List<String>> serviceNames = [
    [
      'Fan Installation',
      'Light Repair',
      'Wiring Check',
      'UnInstallation',
    ],
    [
      'Pipe Leak Repair',
      'Tap Installation',
      'Drain Cleaning',
    ],
    [
      'House Cleaning',
      'Dish Washing',
      'Laundry',
    ],
    [
      'Wash and Iron',
      'Dry Cleaning',
      'Iron Only',
      'Clothes',
    ],
    [
      'Lawn Mowing',
      'Plant Watering',
      'Garden Maintenance',
    ],
    [
      'Home Delivery',
      'Bulk Order',
      'Express Delivery',
    ],
    [
      'Hourly Rental',
      'Daily Rental',
      'Weekly Rental',
    ],
    [
      'Taxi Booking',
      'Auto Rickshaw',
      'Bus Pass',
    ],
    [
      'Turf Booking',
      'Club Membership',
      'Event Hosting',
    ],
  ];

  // Price of all sub-services of each service
  final List<List<int>> servicesCharge = [
    [50, 52, 54, 56],
    [50, 52, 54],
    [50, 52, 54],
    [50, 52, 54, 60],
    [50, 52, 54],
    [50, 52, 54],
    [50, 52, 54],
    [50, 52, 54],
    [50, 52, 54],
  ];

  @override
  void initState() {
    super.initState();
    _fetchServices();
  }

  Future<void> _fetchServices() async {
    final DatabaseReference databaseReference =
        FirebaseDatabase.instance.ref().child('assets').child('images');

    // Using the get method to retrieve data
    final snapshot = await databaseReference.get();

    // Check if the snapshot contains data
    if (snapshot.exists) {
      // Cast snapshot value to Map<dynamic, dynamic>
      Map<dynamic, dynamic> servicesData =
          snapshot.value as Map<dynamic, dynamic>;

      // Clear the lists before repopulating
      services.clear();
      serviceImages.clear();

      // Manually specifying the desired order
      List<String> desiredOrder = [
        'Electrician', // right
        'Plumber', // right
        'Househelp', // right
        'Laundry', // right
        'Gardner',
        'Grocery',
        'Bicycle Booking', // right
        'Local Transport',
        'Turf & Club'
      ];

      // Loop through the desired order to maintain the order in services and serviceImages
      for (String serviceName in desiredOrder) {
        servicesData.forEach((key, value) {
          if (value['name'] == serviceName) {
            services.add(value['name']);
            serviceImages.add(value['url']);
          }
        });
      }

      setState(() {}); // Trigger a rebuild to display the fetched data
    } else {
      print('No data available');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: 'Services',
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Using GridView.builder for cards
            GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1, // One column to take full width
                childAspectRatio: 2.5, // Adjust the aspect ratio as needed
              ),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.all(0.0),
              itemCount: services.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    // Navigate to the service details page when tapping anywhere on the card
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ElectricianPage(
                          title: services[index],
                          imagePath: serviceImages[index],
                          serviceOptions: [serviceNames[index]],
                          servicesCharge: [servicesCharge[index]],
                        ),
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.all(6.0),
                    width: double.infinity, // Full width of the screen
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Row(
                        children: [
                          // First Column: Image
                          Expanded(
                            flex: 2, // Adjust flex as needed
                            child: Container(
                              margin: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                image: DecorationImage(
                                  image: NetworkImage(serviceImages[index]),
                                  fit: BoxFit.cover, // Maintain aspect ratio
                                ),
                              ),
                            ),
                          ),

                          // Second Column: Title and Info
                          Expanded(
                            flex: 3, // Adjust flex as needed
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 6.0), // Add top padding
                              child: Align(
                                alignment: Alignment
                                    .topLeft, // Aligning text to the top left
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal:
                                          8.0), // Side padding for spacing from the border
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start, // Aligning content to start (left)
                                    children: [
                                      Text(
                                        services[index],
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        "Visiting Charge: ₹99", // Replace with dynamic visiting charge if needed
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      Text(
                                        "Available - 24 x 7 hrs", // Replace with dynamic availability info if needed
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: Padding(
                                          padding: const EdgeInsets.all(
                                              8.0), // Add some padding to move it away from edges
                                          child: Text(
                                            "View more", // Replace with dynamic availability info if needed
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: const Color.fromARGB(
                                                  255, 80, 140, 189),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
