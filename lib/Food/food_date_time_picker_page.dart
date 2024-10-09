import 'package:dh/Food/food_bill_summery.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimePickerPage extends StatefulWidget {
  final List<Map<String, dynamic>>
      cartItems; // Add this line to accept cartItems

  DateTimePickerPage({required this.cartItems}); // Update the constructor

  @override
  _DateTimePickerPageState createState() => _DateTimePickerPageState();
}

class _DateTimePickerPageState extends State<DateTimePickerPage> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  // Method to select date
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.redAccent, // Header background color
              onPrimary: Colors.white, // Header text color
              onSurface: Colors.black, // Body text color
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  // Method to select time
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.redAccent, // Clock circle color
              onSurface: Colors.black, // Clock text color
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedTime != null && pickedTime != selectedTime) {
      setState(() {
        selectedTime = pickedTime;
      });
    }
  }

  // Method to format DateTime into a readable format
  String _formatDateTime() {
    if (selectedDate == null || selectedTime == null) {
      return 'No date and time selected';
    }

    final formattedDate = DateFormat('yMMMMd').format(selectedDate!);
    final formattedTime = selectedTime!.format(context);
    return '$formattedDate at $formattedTime';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Date & Time'),
        backgroundColor: Colors.redAccent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Header with Illustration
              Container(
                width: double.infinity,
                height: 180,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                        'https://img.freepik.com/free-vector/schedule-calendar-flat-style_78370-1550.jpg'), // Calendar illustration
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Date Selection Card
              GestureDetector(
                onTap: () => _selectDate(context),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 3,
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        selectedDate == null
                            ? 'Select Date'
                            : DateFormat('yMMMMd').format(selectedDate!),
                        style: TextStyle(
                          fontSize: 18,
                          color: selectedDate == null
                              ? Colors.grey
                              : Colors.black87,
                        ),
                      ),
                      Icon(Icons.calendar_today, color: Colors.redAccent),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Time Selection Card
              GestureDetector(
                onTap: () => _selectTime(context),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 3,
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        selectedTime == null
                            ? 'Select Time'
                            : selectedTime!.format(context),
                        style: TextStyle(
                          fontSize: 18,
                          color: selectedTime == null
                              ? Colors.grey
                              : Colors.black87,
                        ),
                      ),
                      Icon(Icons.access_time, color: Colors.redAccent),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 40),
              // Display Selected Date and Time
              Text(
                'Selected Date & Time:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                _formatDateTime(),
                style: TextStyle(fontSize: 16, color: Colors.blueGrey),
              ),
              SizedBox(height: 40),
              // Confirm Button
              // Confirm Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  backgroundColor: Colors.redAccent,
                ),
                onPressed: selectedDate != null && selectedTime != null
                    ? () {
                        // Log the cart details, date, and time to the console
                        print(
                            'Cart Items: ${widget.cartItems}'); // Log cart items
                        print(
                            'Selected Date: $selectedDate'); // Log selected date
                        print(
                            'Selected Time: $selectedTime'); // Log selected time

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FoodBillSummeryPage(
                              cartItems: widget.cartItems, // Pass the cartItems
                              date: selectedDate, // Pass the selected date
                              time: selectedTime, // Pass the selected time
                            ),
                          ),
                        );
                      }
                    : null, // Button is disabled if date or time is not selected
                child: Text(
                  'Confirm',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
