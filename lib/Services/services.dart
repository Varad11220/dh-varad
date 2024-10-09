import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:dh/Navigation/basescaffold.dart'; // Import BaseScaffold
import 'call_or_book.dart'; // Import individual service pages

class ServicesScreen extends StatefulWidget {
  @override
  _ServicesScreenState createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  final List<String> services = [];
  final List<String> serviceImages = [];
  final List<List<String>> serviceNames = [
    ['Fan Installation', 'Light Repair', 'Wiring Check', 'UnInstallation'],
    ['Pipe Leak Repair', 'Tap Installation', 'Drain Cleaning'],
    ['House Cleaning', 'Dish Washing', 'Laundry'],
    ['Wash and Iron', 'Dry Cleaning', 'Iron Only', 'Clothes'],
    ['Lawn Mowing', 'Plant Watering', 'Garden Maintenance'],
    ['Home Delivery', 'Bulk Order', 'Express Delivery'],
    ['Hourly Rental', 'Daily Rental', 'Weekly Rental'],
    ['Taxi Booking', 'Auto Rickshaw', 'Bus Pass'],
    ['Turf Booking', 'Club Membership', 'Event Hosting'],
  ];

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

  bool _isLoading = true; // Track loading state

  @override
  void initState() {
    super.initState();
    _fetchServices();
  }

  Future<void> _fetchServices() async {
    try {
      final DatabaseReference databaseReference =
      FirebaseDatabase.instance.ref().child('assets').child('images');

      final snapshot = await databaseReference.get();

      if (snapshot.exists) {
        Map<dynamic, dynamic> servicesData =
        snapshot.value as Map<dynamic, dynamic>;

        services.clear();
        serviceImages.clear();

        List<String> desiredOrder = [
          'Electrician',
          'Plumber',
          'Househelp',
          'Laundry',
          'Gardner',
          'Grocery',
          'Bicycle Booking',
          'Local Transport',
          'Turf & Club'
        ];

        for (String serviceName in desiredOrder) {
          servicesData.forEach((key, value) {
            if (value['name'] == serviceName) {
              services.add(value['name']);
              serviceImages.add(value['url']);
            }
          });
        }
      }
    } catch (e) {
      print("Error fetching services: $e");
    }

    // Set loading to false when data fetch is done
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: 'Services',
      body: _isLoading
          ? Center(child: CircularProgressIndicator()) // Show loading indicator while fetching data
          : services.isEmpty
          ? Center(child: Text("You haven't booked any services yet")) // Show message if no data
          : SingleChildScrollView(
        child: Column(
          children: [
            GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                childAspectRatio: 2.5,
              ),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.all(0.0),
              itemCount: services.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
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
                    width: double.infinity,
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Container(
                              margin: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                image: DecorationImage(
                                  image: NetworkImage(serviceImages[index]),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 6.0),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
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
                                        "Visiting Charge: ₹99",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      Text(
                                        "Available - 24 x 7 hrs",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            "View more",
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: const Color.fromARGB(255, 80, 140, 189),
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
