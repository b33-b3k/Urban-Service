import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:vendor_app/auth/auth.dart';

String? userId;

Future<String?> getUserIdByEmail() async {
  try {
    final response = await http.get(
      Uri.parse(
          'http://localhost:8000/api/v1/auth/getUserId?email=${emailController.text}'),
    );
    print("Email:${emailController.text}");

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      userId = data['userId'];
      print(data['userId']);
      return data['userId'];
    } else {
      print('Failed to load user ID');
      return null;
    }
  } catch (e) {
    print('Error: $e');
    return null;
  }
}

class UpKeepFormPage extends StatefulWidget {
  final String serviceId;
  const UpKeepFormPage({Key? key, required this.serviceId}) : super(key: key);

  @override
  _UpKeepFormPageState createState() => _UpKeepFormPageState();
}

class _UpKeepFormPageState extends State<UpKeepFormPage> {
  final TextEditingController customerNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController deliveryTimeController = TextEditingController();
  var serviceId;

  String? selectedPaymentMethod;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserIdByEmail();
    ;

    print("USERID:${userId}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(' Order Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buildTextField('Customer Name', customerNameController),
            buildTextField('Address', addressController),
            buildTextField('Phone Number', phoneNumberController),
            buildTextField('Enter delivery time', deliveryTimeController),
            buildPaymentMethodDropdown(),
            SizedBox(height: 20),
            buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget buildPaymentMethodDropdown() {
    List<String> paymentMethods = ['Cash on Delivery', 'Other'];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payment Method',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: selectedPaymentMethod,
            onChanged: (value) {
              setState(() {
                selectedPaymentMethod = value!;
              });
            },
            items:
                paymentMethods.map<DropdownMenuItem<String>>((String method) {
              return DropdownMenuItem<String>(
                value: method,
                child: Text(method),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget buildSubmitButton() {
    return ElevatedButton(
      onPressed: () {
        // TODO: Implement the logic to post data to your Node.js API
        postOrderToAPI();
      },
      child: Text('Confirm Order'),
    );
  }

  late Map<String, dynamic> userData;

  Future<void> postOrderToAPI() async {
    try {
      var response = await http.post(
        Uri.parse('http://localhost:8000/api/v1/order'),
        body: {
          'address': addressController.text,
          'name': customerNameController.text,
          'phone': phoneNumberController.text,
          'serviceId': widget.serviceId,
          'customerId': userId,
          'time': deliveryTimeController.text,
          'userId': userId
        },
      );
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Success: ${data['msg']}')),
        );
        print('Success: ${data['msg']}');
      } else {
        var errorMessage = response.body != null
            ? json.decode(response.body)['error']
            : 'Unknown error occurred';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $errorMessage')),
        );
        print('Error: $errorMessage');
      }
    } catch (error) {
      // Handle network errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Network Error: $error')),
      );
      print('Network Error: $error');
    }
  }
}
