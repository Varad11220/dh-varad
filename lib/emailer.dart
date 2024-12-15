import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> sendBookingEmail({
  required String recipient,
  required String bookingDateTime,
  required String serviceType,
  required List<Map<String, String>> services,
  required String serviceTime,
  required int subtotal,
  required int gst,
  required int totalAmount,
  required int clothingPrice,
  required int turfCharge,
  required int membership,
  required String clothingType,
}) async {
  final url = Uri.parse('http://192.168.0.104:3000/send-booking-email');

  final data = {
    'recipient': recipient,
    'bookingDateTime': bookingDateTime,
    'serviceType': serviceType,
    'services': services,
    'serviceTime': serviceTime,
    'subtotal': subtotal,
    'gst': gst,
    'totalAmount': totalAmount,
    'clothingPrice': clothingPrice,
    'turfCharge': turfCharge,
    'membership': membership,
    'clothingType': clothingType,
  };

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );

    if (response.statusCode == 200) {
      print('Email sent successfully!');
    } else {
      print('Failed to send email: ${response.body}');
    }
  } catch (e) {
    print('Error: $e');
  }
}
