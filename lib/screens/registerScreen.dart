// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// import 'package:vendor_app/auth/auth.dart';

// class registerScreen extends StatefulWidget {
//   @override
//   _registerScreenState createState() => _registerScreenState();
// }

// class _registerScreenState extends State<registerScreen> {
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
//       } else {
//         // Handle login error
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Login')),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               TextFormField(
//                 controller: _emailController,
//                 decoration: InputDecoration(labelText: 'Email'),
//                 validator: (value) => value!.isEmpty ? 'Enter email' : null,
//                 keyboardType: TextInputType.emailAddress,
//               ),
//               TextFormField(
//                 controller: _passwordController,
//                 decoration: InputDecoration(labelText: 'Password'),
//                 validator: (value) => value!.isEmpty ? 'Enter password' : null,
//                 obscureText: true,
//               ),
//               ElevatedButton(
//                 onPressed: _login,
//                 child: Text('Login'),
//               ),
//               TextButton(
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => LoginScreen()),
//                   );
//                 },
//                 child: Text('Already have an account? Login'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
