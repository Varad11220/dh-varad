import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Navigation/basescaffold.dart';
import '../Services/booking_detail_page.dart';
import '../Services/mybookings.dart';

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
    try {
      final databaseRef = FirebaseDatabase.instance.ref('serviceBooking');
      final snapshot = await databaseRef.get();

      if (snapshot.exists) {
        final data = snapshot.value as Map<Object?, Object?>?;

        if (data != null) {
          allBookings.clear(); // Clear previous data before adding new entries

          // Loop through each user's bookings
          for (var userEntry in data.entries) {
            final userPhoneNumber = userEntry.key as String?;
            final userBookings = userEntry.value as Map<Object?, Object?>?;

            if (userPhoneNumber != null && userBookings != null) {
              // Loop through each booking for the current user
              for (var bookingEntry in userBookings.entries) {
                final booking = bookingEntry.value as Map<Object?, Object?>?;
                print("Booking for $userPhoneNumber: $booking");

                if (booking != null) {
                  // Retrieve bookingTime and cancelBooking
                  final bookingTime = booking['bookingTime'] as String?;
                  final isCancelled = booking['cancelBooking'] as bool? ?? false;

                  // Retrieve services details and cost
                  final servicesDetails = booking['servicesDetails'] as Map<Object?, Object?>?;
                  final cost = booking['cost'] as Map<Object?, Object?>?;

                  if (servicesDetails != null && cost != null) {
                    final services = servicesDetails['services'] as List<dynamic>?;

                    // Extract additional details
                    final serviceTime = servicesDetails['serviceTime'] as String?;
                    final serviceDate = servicesDetails['serviceDate'] as String?;
                    final totalAmount = cost['totalAmount'] as int?;
                    final serviceProvider = booking['service_provider'] as String?;

                    // Get the specific image URL from the map
                    String imageUrl = serviceProviderImageUrls[serviceProvider ?? ''] ?? '';

                    // Add booking data to the list if all required data is available
                    if (services != null && totalAmount != null && bookingTime != null) {
                      allBookings.add({
                        'userPhoneNumber': userPhoneNumber,
                        'bookingTime': bookingTime,
                        'totalAmount': totalAmount,
                        'serviceTime': serviceTime,
                        'serviceDate': serviceDate,
                        'services': services,
                        'serviceProvider': serviceProvider,
                        'imageUrl': imageUrl, // Use the static image URL
                        'isCancelled': isCancelled, // Include the cancelBooking status
                      });
                    }
                  }
                }
              }
            }
          }

          // Sort allBookings by status and bookingTime
          allBookings.sort((a, b) {
            int statusComparison = _compareStatus(a['isCancelled'], a['isPending'], b['isCancelled'], b['isPending']);
            if (statusComparison != 0) return statusComparison;

            // Sort by bookingTime if statuses are equal
            return a['bookingTime'].compareTo(b['bookingTime']);
          });

          setState(() {
            isLoading = false; // Data fetched, stop loading
          });

          // Log the allBookings for debugging
          print("allBookings: $allBookings");
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

// Helper function to compare statuses
  int _compareStatus(bool isCancelledA, bool isPendingA, bool isCancelledB, bool isPendingB) {
    if (isPendingA && !isPendingB) return -1; // A is pending, B is not
    if (!isPendingA && isPendingB) return 1;  // B is pending, A is not
    if (isCancelledA && !isCancelledB) return 1; // A is cancelled, B is not
    if (!isCancelledA && isCancelledB) return -1; // B is cancelled, A is not
    return 0; // Both have the same status (either both done or both not cancelled)
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

          return GestureDetector(
            onTap: () {
              // Navigate to the detailed booking page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookingDetailPage(
                    serviceProvider:
                    booking['serviceProvider'] as String? ?? '',
                    selectedService: (booking['services']
                    as List<dynamic>?)
                        ?.map((service) =>
                    service['name'] as String?)
                        .where((name) =>
                    name != null) // Filter out null names
                        .join(", ") ??
                        '', // Join service names
                    serviceDate:
                    booking['serviceDate'] as String? ?? '',
                    serviceTime:
                    booking['serviceTime'] as String? ?? '',
                    totalCost: (booking['totalAmount'] as int?)
                        ?.toDouble() ??
                        0.0,
                    bookingTime:
                    booking['bookingTime'] as String? ?? '',
                    services: [],
                    showCancelButton: false,
                      isCancelled:true,
                  ),
                ),
              );
            },
            child: BookingCard(
              serviceProvider: booking['serviceProvider'],
              bookingTime: booking['bookingTime'],
              serviceTime: booking['serviceTime'],
                serviceDate: booking['serviceDate'],
              totalCost: booking['totalAmount'].toDouble(),
              imageUrl: booking[
              'imageUrl'],
              isCancelled: booking['isCancelled'],// Use the image URL from bookings
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