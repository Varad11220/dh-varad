import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../basescaffold.dart';

class AdminAllBooking extends StatefulWidget {
  @override
  _AdminAllBookingState createState() => _AdminAllBookingState();
}

class _AdminAllBookingState extends State<AdminAllBooking> {
  List<Map<String, dynamic>> allBookings = []; // List to store all bookings
  bool isLoading = true; // Flag to show loading indicator

  // Map for storing specific image URLs for each service provider
  Map<String, String> serviceProviderImageUrls = {
    'Electrician':
        'https://firebasestorage.googleapis.com/v0/b/doodleshomes-7ffe2.appspot.com/o/images%2F1001217108.jpg?alt=media&token=b77f7549-74ef-49c9-ad77-26e0eb94aa52',
    'Plumber':
        'https://firebasestorage.googleapis.com/v0/b/doodleshomes-7ffe2.appspot.com/o/images%2F1001217096.jpg?alt=media&token=d41ecdf4-fc91-427d-8429-2ec4e4ba015f',
    'Househelp':
        'https://firebasestorage.googleapis.com/v0/b/doodleshomes-7ffe2.appspot.com/o/images%2F1001217106.jpg?alt=media&token=d6ceb594-ed38-42d4-b351-eb13184132d9',
    'Laundry':
        'https://firebasestorage.googleapis.com/v0/b/doodleshomes-7ffe2.appspot.com/o/images%2F1001217092.jpg?alt=media&token=0c9b7b90-30d4-4657-8ddd-c065839de97c',
    'Gardener':
        'https://firebasestorage.googleapis.com/v0/b/doodleshomes-7ffe2.appspot.com/o/images%2F1001217089.jpg?alt=media&token=f17fc776-58ce-4abe-9967-5379131f6f8c',
    'Grocery':
        'https://firebasestorage.googleapis.com/v0/b/doodleshomes-7ffe2.appspot.com/o/images%2F1001217109.jpg?alt=media&token=952144b4-1589-410a-8e53-16629c554238',
    'Bicycle Booking':
        'https://firebasestorage.googleapis.com/v0/b/doodleshomes-7ffe2.appspot.com/o/images%2F1001217101.jpg?alt=media&token=b05deb6c-f9d9-4fe0-8857-00dd186d6668',
    'Local Transport':
        'https://firebasestorage.googleapis.com/v0/b/doodleshomes-7ffe2.appspot.com/o/images%2F1001217098.jpg?alt=media&token=1b8b70e9-29d3-430f-86fa-b35b947f1903',
    'Turf & Club':
        'https://firebasestorage.googleapis.com/v0/b/doodleshomes-7ffe2.appspot.com/o/images%2F1001217103.jpg?alt=media&token=206fe6c6-3f94-4e34-a30d-2c7eccf41ca5',
  };

  @override
  void initState() {
    super.initState();
    _fetchAllBookings();
  }

  Future<void> _fetchAllBookings() async {
    final databaseRef = FirebaseDatabase.instance.ref('serviceBooking');

    try {
      final snapshot = await databaseRef.get();
      if (snapshot.exists) {
        final data = snapshot.value as Map<Object?, Object?>?;
        if (data != null) {
          allBookings.clear(); // Clear previous data before adding new entries

          // Loop through each booking entry
          data.forEach((userPhoneNumber, bookingsData) {
            final bookingsList = bookingsData as Map<Object?, Object?>?;

            bookingsList?.forEach((bookingID, bookingDetails) {
              final booking = bookingDetails as Map<Object?, Object?>?;
              final servicesDetails =
                  booking != null && booking['servicesDetails'] is Map
                      ? booking['servicesDetails'] as Map
                      : null;
              final cost = booking != null && booking['cost'] is Map
                  ? booking['cost'] as Map
                  : null;

              if (servicesDetails != null && cost != null) {
                final services =
                    servicesDetails['services'] as List<dynamic>? ?? [];
                final serviceTime =
                    servicesDetails['serviceTime'] as String? ?? "N/A";
                final serviceDate =
                    servicesDetails['serviceDate'] as String? ?? "N/A";
                final totalAmount = cost['totalAmount'] as int? ?? 0;
                final bookingTime = booking?['bookingTime'] as String? ?? "N/A";
                final serviceProvider =
                    booking?['service_provider'] as String? ?? "Unknown";

                // Get the specific image URL for the service provider
                String imageUrl =
                    serviceProviderImageUrls[serviceProvider] ?? '';

                if (services.isNotEmpty &&
                    totalAmount > 0 &&
                    bookingTime.isNotEmpty) {
                  setState(() {
                    allBookings.add({
                      'bookingTime': bookingTime,
                      'totalAmount': totalAmount,
                      'serviceTime': serviceTime,
                      'serviceDate': serviceDate,
                      'services': services,
                      'serviceProvider': serviceProvider,
                      'imageUrl': imageUrl, // Use the static image URL
                    });
                  });
                }
              }
            });
          });

          setState(() {
            isLoading = false; // Data fetched, stop loading
          });
        } else {
          setState(() {
            allBookings = [];
            isLoading = false; // No data found, stop loading
          });
        }
      } else {
        setState(() {
          allBookings = [];
          isLoading = false; // No data found, stop loading
        });
      }
    } catch (error) {
      setState(() {
        isLoading = false; // Stop loading on error
      });
      print('Error fetching data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: "Admin All Bookings",
      body: isLoading
          ? Center(
              child:
                  CircularProgressIndicator(), // Show loading indicator while fetching data
            )
          : allBookings.isNotEmpty
              ? ListView.builder(
                  itemCount: allBookings.length,
                  itemBuilder: (context, index) {
                    final booking = allBookings[index];

                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Service Provider: ${booking['serviceProvider']}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                      'Booking Time: ${booking['bookingTime']}'),
                                  SizedBox(height: 8),
                                  Text(
                                      'Service Time: ${booking['serviceTime']}'),
                                  SizedBox(height: 8),
                                  Text(
                                    'Total Cost: ₹${booking['totalAmount']}',
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 16),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.black,
                                    width: 2), // Border color and width
                                borderRadius:
                                    BorderRadius.circular(10), // Border radius
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Image.network(
                                  alignment: Alignment.bottomRight,
                                  booking['imageUrl'].isEmpty
                                      ? 'https://via.placeholder.com/90'
                                      : booking['imageUrl'],
                                  width: 110,
                                  height: 110,
                                  fit: BoxFit.cover,
                                  errorBuilder: (BuildContext context,
                                      Object error, StackTrace? stackTrace) {
                                    return Image.network(
                                      'https://via.placeholder.com/90',
                                      width: 110,
                                      height: 110,
                                      fit: BoxFit.cover,
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                )
              : Center(
                  child: Text(
                    "No bookings available",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ),
    );
  }
}
