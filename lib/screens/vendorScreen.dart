import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // If the form is valid, send the data to the API
      final url = Uri.parse('YOUR_API_ENDPOINT_URL');
      final response = await http.post(
        url,
        body: {
          'name': _nameController.text,
          'email': _emailController.text,
          'businessName': _businessNameController.text,
          'address': _addressController.text,
          'phone': _phoneController.text,
          'pan': _panController.text,
        },
      );

      if (response.statusCode == 200) {
        // If the API call is successful, handle the response here
        print('Form data sent successfully');
      } else {
        // If the API call fails, handle the error here
        print('Failed to send form data');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Become a Vendor'),
        backgroundColor: Colors.blueGrey, // Professional look
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
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
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text('Submit'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blueGrey,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
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
          border: OutlineInputBorder(),
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
