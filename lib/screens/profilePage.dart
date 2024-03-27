import 'package:flutter/material.dart';
import 'package:vendor_app/auth/auth.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/user_icon.png'),
            ),
            SizedBox(height: 16),
            Text(
              username.text,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 8),
            Text(
              emailController.text,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.verified_user,
                  color: Colors.black,
                ),
                SizedBox(width: 8),
                Text(
                  'Verified User',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                //logout
              ],
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
