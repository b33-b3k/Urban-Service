import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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

  String? selectedPaymentMethod;
  String? userId;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getUserIdByEmail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Form'),
        backgroundColor: Colors.greenAccent,
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
      onPressed: isLoading ? null : () => postOrderToAPI(),
      child: Text('Confirm Order'),
    );
  }

  Future<void> getUserIdByEmail() async {
    // your implementation
  }

  Future<void> postOrderToAPI() async {
    setState(() {
      isLoading = true;
    });

    if (_validateInputs()) {
      try {
        var response = await http.post(
          Uri.parse('http://localhost:8000/api/v1/order'),
          body: {
            'address': addressController.text,
            'name': customerNameController.text,
            'phone': phoneNumberController.text,
            'serviceId': widget.serviceId,
            'customerId': userId!,
            'time': deliveryTimeController.text,
            'userId': userId!,
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
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields')),
      );
    }
  }

  bool _validateInputs() {
    return customerNameController.text.isNotEmpty &&
        addressController.text.isNotEmpty &&
        phoneNumberController.text.isNotEmpty &&
        deliveryTimeController.text.isNotEmpty &&
        selectedPaymentMethod != null;
  }
}
