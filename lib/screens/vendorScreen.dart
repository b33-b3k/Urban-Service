import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:vendor_app/auth/auth.dart';

const String vendorUrl = 'http://localhost:8000/api/v1/user/vendor';

class VendorFormScreen extends StatefulWidget {
  @override
  _VendorFormScreenState createState() => _VendorFormScreenState();
}

class _VendorFormScreenState extends State<VendorFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _businessNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _panController = TextEditingController();

  Future<String?> getUserIdByEmail(String email) async {
    try {
      final response = await http.get(
        Uri.parse(
            // 'http://localhost:8000/api/v1/auth/getUserId?email=beebek2004@gmail.com'),
            'http://localhost:8000/api/v1/auth/getUserId?email=${emailController.text}'),
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
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

  Future<void> requestVendor() async {
    try {
      String? userId = await getUserIdByEmail(_emailController.text);
      Map<String, dynamic> createVendorRequestData(String userId) {
        return {
          'user': userId,
        };
      }

      var requestData = createVendorRequestData(userId!);

      var response = await http.post(
        Uri.parse(vendorUrl),
        headers: {"Content-Type": "application/json"},
        body: json.encode(requestData), // Sending as a JSON object
      );

      if (response.statusCode == 200) {
        // Handle successful response
        var data = json.decode(response.body);
        print('Success: ${data['msg']}');
      } else {
// Handle error
        print('Error: ${response.body}');
      }
    } catch (e) {
// Handle network error or other exceptions
      print('Exception: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Become a Vendor'),
        backgroundColor: Colors.greenAccent, // Professional look
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildTextField(
                    _nameController, 'Name', 'Please enter your name'),
                _buildTextField(
                    _emailController, 'Email', 'Please enter your email',
                    keyboardType: TextInputType.emailAddress),
                _buildTextField(_businessNameController, 'Business Name',
                    'Please enter your business name'),
                _buildTextField(
                    _addressController, 'Address', 'Please enter your address'),
                _buildTextField(
                    _phoneController, 'Phone', 'Please enter your phone number',
                    keyboardType: TextInputType.phone),
                _buildTextField(_panController, 'PAN Number',
                    'Please enter your PAN number'),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => requestVendor(),
                  child: const Text('Submit'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.greenAccent,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 15),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, String validationMessage,
      {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          fillColor: Colors.grey[200],
          filled: true,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return validationMessage;
          }
          return null;
        },
        keyboardType: keyboardType,
      ),
    );
  }
}
