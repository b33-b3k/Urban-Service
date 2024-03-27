// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:vendor_app/screens/homeScreen.dart';

// import 'package:vendor_app/screens/registerScreen.dart';
final TextEditingController emailController = TextEditingController();
final TextEditingController username = TextEditingController();
final TextEditingController passwordController = TextEditingController();

// auth_service.dart

class AuthService {
  // Singleton instance
  static final AuthService _instance = AuthService._internal();

  factory AuthService() {
    return _instance;
  }

  AuthService._internal();

  late String? _token;
  String? _userId;

  String? get token => _token;
  String? get userId => _userId;

  Future<void> loginUser(String email, String password) async {
    final response = await http.post(Uri.parse(loginUrl), body: {
      'emailorusername': email,
      'password': password,
    });

    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = json.decode(response.body);
      _token = responseData['token'];
      _userId = responseData['_id'];
      print('User logged in successfully: $responseData');
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<void> logoutUser() async {
    final response = await http.post(
      Uri.parse(logoutUrl),
      headers: {'Authorization': 'Bearer $_token'},
    );

    if (response.statusCode == 200) {
      _token = null;
      _userId = null;
      print('User logged out successfully');
    } else {
      throw Exception('Failed to log out');
    }
  }
}

final AuthService authService = AuthService();

//api endpoints sample
const String loginUrl = 'http://localhost:8000/api/v1/auth/login';
const String signupUrl = 'http://localhost:8000/api/v1/auth/';
const String logoutUrl = 'http://localhost:8000/api/v1/auth/logout';
const String forgotPassword = 'http://localhost:8000/api/v1/auth/forgot';

void showErrorDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('Close'),
            onPressed: () {
              Navigator.of(context).pop(); // Dismiss the dialog
            },
          ),
        ],
      );
    },
  );
}

Future<String> loginUser(String email, String password) async {
  final response = await http.post(Uri.parse(loginUrl), body: {
    'emailorusername': email,
    'password': password,
  });

  if (response.statusCode == 200) {
    // If the server returns a 200 OK response, return the user token
    return json.decode(response.body)['token'];
  } else {
    // If the server did not return a 200 OK response, throw an exception.
    throw Exception('Failed to login');
  }
}

class AuthenticationScreen extends StatelessWidget {
  const AuthenticationScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    Future<void> logoutUser(String token) async {
      final response = await http.post(
        Uri.parse(logoutUrl),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        // If the server returns a 200 OK response, the user is successfully logged out
        print('User logged out successfully');
        //navigate to authenticate screen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AuthenticationScreen()),
        );
      } else {
        // If the server did not return a 200 OK response, throw an exception.
        throw Exception('Failed to log out');
      }
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.greenAccent, // Set the background color to green accent
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 60.0),
                child: Center(
                  child: Image.asset(
                    'asset/images/auth.png', // Replace with your logo
                    height: 100.0,
                  ),
                ),
              ),
              Column(
                children: [
                  _buildInputField(
                    icon: Icons.mail_outline,
                    hint: 'Email',
                  ),
                  const SizedBox(height: 10),
                  _buildInputField(
                    icon: Icons.lock_outline,
                    hint: 'Password',
                    isPassword: true,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () {
                      //navigate to login
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignUpScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 130,
                        vertical: 20,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      backgroundColor: Colors.white,
                    ),
                    icon: const Icon(
                      Icons.person_add,
                      color: Colors.black,
                    ),
                    label: const Text(
                      "Signup",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 130,
                        vertical: 20,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      backgroundColor: Colors.white,
                    ),
                    icon: const Icon(
                      Icons.login,
                      color: Colors.black,
                    ),
                    label: const Text(
                      "Login",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required IconData icon,
    required String hint,
    bool isPassword = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        obscureText: isPassword,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.black),
          hintText: hint,
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      final response = await http.post(
        Uri.parse(
            'http://localhost:8000/api/v1/auth/login'), // Replace with your API endpoint
        body: {
          'emailorusername': emailController.text,
          'password': passwordController.text,
        },
      );

      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");
      print(response);

      if (response.statusCode == 200) {
        // Handle the response, e.g., navigate to another screen
        print('Login successfulllll');

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User logged in successfully'),
          ),
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        // Handle errors
        print('Failed to log in');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${response.body}'),
          ),
        );
      }
    }
  }

  Widget _buildTextField({required String label, required bool isPassword}) {
    return TextFormField(
      controller: isPassword ? passwordController : emailController,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      obscureText: isPassword,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your $label';
        }
        return null;
      },
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return ElevatedButton(
      onPressed: _login,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.greenAccent,
        padding: const EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: const Text(
        'Login',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildLogo() {
    return Center(
      // Add your logo here
      child: InkWell(
        child: const Icon(Icons.account_circle,
            size: 100, color: Colors.greenAccent),
        onLongPress: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        },
      ),
    );
  }

  var obscureText = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Login',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.greenAccent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                _buildLogo(),
                const SizedBox(height: 30),
                _buildTextField(label: 'Email', isPassword: false),
                const SizedBox(height: 20),
                TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                    suffixIcon:
                        // show password icon
                        IconButton(
                      icon: obscureText
                          ? Icon(Icons.visibility_off)
                          : Icon(Icons.visibility),
                      onPressed: () {
                        // change the state of the password field
                        // ignore: invalid_use_of_protected_member
                        setState(() {
                          // ignore: invalid_use_of_protected_member
                          obscureText = !obscureText;
                        });
                      },
                    ),
                  ),
                  obscureText: obscureText,
                  // show password icon

                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                //if not registered register
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignUpScreen()),
                    );
                  },
                  child: const Text(
                    "Don't have an account? Sign up",
                    style: TextStyle(color: Colors.purple),
                  ),
                ),

                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ForgotPasswordScreen()),
                    );
                  },
                  child: const Text(
                    "Forgot Password",
                    style: TextStyle(color: Colors.purple),
                  ),
                ),

                //register
                // ElevatedButton(
                //   onPressed: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(builder: (context) => SignUpScreen()),
                //     );
                //   },
                //   child: const Text('Register'),
                // ),
                _buildLoginButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController address = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  Widget _buildTextField(
      {required String label,
      required TextEditingController controller,
      required bool isPassword}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      obscureText: isPassword,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your $label';
        }
        return null;
      },
    );
  }

  Future<String> signupUser(
      String email, String password, String address, String username) async {
    final response = await http.post(
      Uri.parse(signupUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        'email': email,
        'username': username,
        'password': password,
        'address': address,
      }),
    );

    print("Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");
    //scaffold

    print(response);

    if (response.statusCode == 200) {
      // Handle successful registration
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User registered successfully'),
        ),
      );
      return json.decode(response.body)['token'];
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response.body.toString()),
        ),
      );
      // Handle different statuses and error responses
      throw Exception('Failed to signup: ${response.body}');
      //scaffold
    }
  }

  Widget _buildLoginButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () => signupUser(_emailController.text,
          _passwordController.text, address.text, username.text),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.greenAccent,
        padding: const EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: const Text(
        'Register',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildLogo() {
    return const Center(
      // Add your logo here
      child: Icon(Icons.account_circle, size: 100, color: Colors.greenAccent),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Register',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.greenAccent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                _buildLogo(),
                const SizedBox(height: 30),
                _buildTextField(
                    label: 'Username', isPassword: false, controller: username),
                const SizedBox(height: 20),
                _buildTextField(
                    label: 'Address', isPassword: false, controller: address),
                const SizedBox(height: 20),
                _buildTextField(
                    label: 'Email',
                    isPassword: false,
                    controller: _emailController),
                const SizedBox(height: 20),
                _buildTextField(
                    label: 'Password',
                    isPassword: true,
                    controller: _passwordController),
                const SizedBox(height: 20),
                _buildTextField(
                    label: 'Confirm Password',
                    isPassword: true,
                    controller: _passwordController),
                const SizedBox(height: 30),

                //if registered login
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()),
                    );
                  },
                  child: const Text(
                    "Already have an account? Login",
                    style: TextStyle(color: Colors.purple),
                  ),
                ),
                _buildLoginButton(context),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();

  Future<void> requestResetPassword(String email) async {
    // Call API to request password reset
    final response = await http.post(
      Uri.parse(forgotPassword),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({'email': email}),
    );
    //print response
    print(email);
    print("Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 200) {
      // Handle success, maybe show a success message
      final responseBody = jsonDecode(response.body);

      String resetToken = responseBody['resetToken'];
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Reset link sent, please check your email.'),
        ),
      );
      print('Reset link sent, please check your email.');
    } else {
      // Handle error, show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to request password reset.'),
        ),
      );
      throw Exception('Failed to request password reset.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Reset Password',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.greenAccent, // Consistent theme color
      ),
      body: SingleChildScrollView(
        // Ensures form is scrollable on smaller devices
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _buildPasswordInputField(label: 'Enter your email'),
              const SizedBox(height: 30),
              _buildResetPasswordButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordInputField({required String label}) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        fillColor: Colors.grey[200],
        filled: true,
      ),
      obscureText: false,
      controller: _emailController,
    );
  }

  Widget _buildResetPasswordButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        requestResetPassword(_emailController.text);
      },
      child: const Text(
        'Reset Password',
        style: TextStyle(color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.greenAccent,
        padding: const EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}

// class ResetPasswordScreen extends StatefulWidget {
//   const ResetPasswordScreen({super.key});

//   @override
//   State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
// }

// class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _re_enter_passwordController =
//       TextEditingController();

//   final TextEditingController _tokenController = TextEditingController();

//   Future<void> requestResetPassword(String email) async {
//     // Call API to request password reset
//     final response = await http.post(
//       Uri.parse(forgotPassword),
//       headers: {"Content-Type": "application/json"},
//       body: jsonEncode({'email': email}),
//     );
//     //print response
//     print(email);
//     print("Status Code: ${response.statusCode}");
//     print("Response Body: ${response.body}");

//     if (response.statusCode == 200) {
//       // Handle success, maybe show a success message
//       final responseBody = jsonDecode(response.body);

//       String resetToken = responseBody['resetToken'];
//       _tokenController.text = resetToken;

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Reset link sent, please check your email.'),
//         ),
//       );
//     } else {
//       // Handle error, show an error message
//       throw Exception('Failed to request password reset.');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Reset Password'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: <Widget>[
//             const SizedBox(height: 20),
//             TextFormField(
//               controller: _passwordController,
//               decoration: const InputDecoration(
//                 labelText: 'New Password',
//                 border: OutlineInputBorder(),
//               ),
//               obscureText: true,
//             ),
//             const SizedBox(height: 20),
//             TextFormField(
//               controller: _re_enter_passwordController,
//               decoration: const InputDecoration(
//                 labelText: 'Re-enter your Password',
//                 border: OutlineInputBorder(),
//               ),
//               obscureText: true,
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () => requestResetPassword(_passwordController.text),
//               child: const Text('Reset Password'),
//               style: ElevatedButton.styleFrom(
//                 primary: Theme.of(context).primaryColor,
//                 padding: const EdgeInsets.symmetric(vertical: 15),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
