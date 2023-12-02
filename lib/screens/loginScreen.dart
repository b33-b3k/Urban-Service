// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:vendor_app/auth/auth.dart';
// import 'package:vendor_app/screens/homeScreen.dart';
// import 'package:vendor_app/screens/registerScreen.dart';
// import 'dart:convert';

// class LoginScreen extends StatefulWidget {
//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   Future<void> _login() async {
//     if (_formKey.currentState!.validate()) {
//       // Implement API call for login
//       final response = await http.post(
//         Uri.parse('YOUR_LOGIN_API_ENDPOINT'),
//         body: {
//           'email': _emailController.text,
//           'password': _passwordController.text,
//         },
//       );

//       if (response.statusCode == 200) {
//         // Handle successful login
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => HomeScreen()),
//         );
//       } else {
//         // Handle login error
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Container(
//           padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               SizedBox(height: 40),
//               _buildLogo(),
//               SizedBox(height: 50),
//               _buildForm(),
//               SizedBox(height: 20),
//               _buildLoginButton(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildLogo() {
//     return Container(
//       height: 200, // Height of the container
//       width: double.infinity, // Width of the container
//       child: Image.network(
//         'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Image_created_with_a_mobile_phone.png/1280px-Image_created_with_a_mobile_phone.png',
//         fit: BoxFit.cover, // This is to ensure the image covers the container
//       ),
//     );
//   }

//   Form _buildForm() {
//     return Form(
//       key: _formKey,
//       child: Column(
//         children: [
//           TextFormField(
//             controller: _emailController,
//             decoration: InputDecoration(
//               labelText: 'Email',
//               border: OutlineInputBorder(),
//             ),
//             validator: (value) => value!.isEmpty ? 'Enter email' : null,
//             keyboardType: TextInputType.emailAddress,
//           ),
//           SizedBox(height: 16),
//           TextFormField(
//             controller: _passwordController,
//             decoration: InputDecoration(
//               labelText: 'Password',
//               border: OutlineInputBorder(),
//             ),
//             validator: (value) => value!.isEmpty ? 'Enter password' : null,
//             obscureText: true,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildLoginButton() {
//     return ElevatedButton(
//       onPressed: _login,
//       child: Text('loginnn'),
//       style: ElevatedButton.styleFrom(
//         padding: EdgeInsets.symmetric(vertical: 15.0),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(8.0),
//         ),
//       ),
//     );
//   }

//   Widget _buildRegisterButton(BuildContext context) {
//     return TextButton(
//       onPressed: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => SignUpScreen()),
//         );
//       },
//       child: Text(
//         "Don't have an account? Sign up",
//         style: TextStyle(color: Colors.blue),
//       ),
//     );
//   }
// }
