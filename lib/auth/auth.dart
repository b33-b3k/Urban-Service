import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:vendor_app/screens/registerScreen.dart';

//api endpoints sample
const String loginUrl = 'https://your-backend-api.com/login';
const String signupUrl = 'https://your-backend-api.com/signup';
const String logoutUrl = 'your_logout_url_here'; // Replace with your logout URL

Future<String> loginUser(String email, String password) async {
  final response = await http.post(Uri.parse(loginUrl), body: {
    'email': email,
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

Future<String> signupUser(String email, String password) async {
  final response = await http.post(Uri.parse(signupUrl), body: {
    'email': email,
    'password': password,
  });

  if (response.statusCode == 200) {
    // If the server returns a 200 OK response, return the user token
    return json.decode(response.body)['token'];
  } else {
    // If the server did not return a 200 OK response, throw an exception.
    throw Exception('Failed to signup');
  }
}

Future<void> logoutUser(String token) async {
  final response = await http.post(
    Uri.parse(logoutUrl),
    headers: {'Authorization': 'Bearer $token'},
  );

  if (response.statusCode == 200) {
    // If the server returns a 200 OK response, the user is successfully logged out
    print('User logged out successfully');
  } else {
    // If the server did not return a 200 OK response, throw an exception.
    throw Exception('Failed to log out');
  }
}

class AuthenticationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                "asset/images/auth.png"), // Replace with your own image
            fit: BoxFit.cover,
          ),
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
                  _buildInputField(icon: Icons.mail_outline, hint: 'Email'),
                  SizedBox(height: 10),
                  _buildInputField(
                      icon: Icons.lock_outline,
                      hint: 'Password',
                      isPassword: true),
                  SizedBox(height: 20),
                  _buildButton(context, 'Log In', Colors.black, Colors.white),
                  SizedBox(height: 20),
                  _buildButton(context, 'Sign Up', Colors.white, Colors.black),
                  SizedBox(height: 40),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(
      {required IconData icon, required String hint, bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
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
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
      ),
    );
  }

  Widget _buildButton(
      BuildContext context, String text, Color bgColor, Color textColor) {
    return ElevatedButton(
      onPressed: () {
        // Implement navigation logic
      },
      child: Text(text, style: TextStyle(color: textColor)),
      style: ElevatedButton.styleFrom(
        primary: bgColor,
        padding: EdgeInsets.symmetric(horizontal: 130, vertical: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      final response = await http.post(
        Uri.parse('YOUR_API_ENDPOINT'), // Replace with your API endpoint
        body: {
          'email': _emailController.text,
          'password': _passwordController.text,
        },
      );

      if (response.statusCode == 200) {
        // Handle the response, e.g., navigate to another screen
        print('Login successful');
      } else {
        // Handle errors
        print('Failed to log in');
      }
    }
  }

  Widget _buildTextField({required String label, required bool isPassword}) {
    return TextFormField(
      controller: isPassword ? _passwordController : _emailController,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
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
      child: const Text(
        'Login',
        style: TextStyle(color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        primary: Colors.deepPurple,
        padding: EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Center(
      // Add your logo here
      child: Icon(Icons.account_circle, size: 100, color: Colors.deepPurple),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Login',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
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
                _buildTextField(label: 'Password', isPassword: true),
                const SizedBox(height: 30),
                //if not registered register
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUpScreen()),
                    );
                  },
                  child: const Text(
                    "Don't have an account? Sign up",
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
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      final response = await http.post(
        Uri.parse('YOUR_API_ENDPOINT'), // Replace with your API endpoint
        body: {
          'email': _emailController.text,
          'password': _passwordController.text,
        },
      );

      if (response.statusCode == 200) {
        // Handle the response, e.g., navigate to another screen
        print('Login successful');
      } else {
        // Handle errors
        print('Failed to log in');
      }
    }
  }

  Widget _buildTextField({required String label, required bool isPassword}) {
    return TextFormField(
      controller: isPassword ? _passwordController : _emailController,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
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
      child: const Text(
        'Register',
        style: TextStyle(color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        primary: Colors.deepPurple,
        padding: EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Center(
      // Add your logo here
      child: Icon(Icons.account_circle, size: 100, color: Colors.deepPurple),
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
        backgroundColor: Colors.deepPurple,
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
                _buildTextField(label: 'Password', isPassword: true),
                const SizedBox(height: 30),

                //if registered login
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
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

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Reset Password',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple, // Consistent theme color
      ),
      body: SingleChildScrollView(
        // Ensures form is scrollable on smaller devices
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _buildPasswordInputField(label: 'Current Password'),
              const SizedBox(height: 20),
              _buildPasswordInputField(label: 'New Password'),
              const SizedBox(height: 20),
              _buildPasswordInputField(label: 'Confirm New Password'),
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
      obscureText: true,
    );
  }

  Widget _buildResetPasswordButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Implement password reset logic here
      },
      child: const Text(
        'Reset Password',
        style: TextStyle(color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        primary: Colors.deepPurple,
        padding: EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
