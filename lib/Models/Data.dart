import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import "Products.dart";



Future<void> createSalesOrder(List<dynamic> temp) async {
  final url =
      Uri.parse('https://core-dev.excitor.tech/api/resource/Sales Order');

  final Map<String, dynamic> requestBody = {
    "customer": "Bhavya Enterprise",
    "transaction_date": DateTime.now().toIso8601String(),
    "order_type": "Sales",
    "currency": "INR",
    "selling_price_list": "Standard Selling",
    "items": temp,
  };

  final response = await http.post(
    url,
    headers: {
      'Authorization': '${dotenv.env['API_KEY']}',
      'Cookie':
          'full_name=Guest; sid=Guest; system_user=no; user_id=Guest; user_image=',
      'Content-Type': 'application/json',
    },
    body: jsonEncode(requestBody),
  );

  if (response.statusCode == 200 || response.statusCode == 201) {
    final data = jsonDecode(response.body);
    print('Sales Order Created: $data');
  } else {
    print(
        'Failed to create Sales Order: ${response.statusCode}, ${response.body}');
  }
}




