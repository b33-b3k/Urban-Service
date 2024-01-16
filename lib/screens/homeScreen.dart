import 'package:flutter/material.dart';
import 'package:vendor_app/auth/auth.dart';
import 'package:vendor_app/screens/servicesPage.dart';
import 'package:vendor_app/screens/vendorScreen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Urban Services'),
        backgroundColor: Colors.greenAccent, // Consistent theme color
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Logic for notifications
            },
          ),
        ],
      ),
      drawer: Theme(
        // Enhanced drawer style
        data: Theme.of(context).copyWith(
          canvasColor: Colors.greenAccent, // Changes drawer background color
        ),
        child: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              UserAccountsDrawerHeader(
                // Improved header with user account details
                accountName: Text(username.text),
                accountEmail: Text(emailController.text),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Text(
                    "U",
                    style: TextStyle(fontSize: 40.0, color: Colors.deepPurple),
                  ),
                ),
              ),
              _createDrawerItem(
                icon: Icons.home,
                text: 'Home',
                onTap: () => Navigator.pop(context),
              ),
              _createDrawerItem(
                icon: Icons.business,
                text: 'Become Vendor',
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => VendorFormScreen())),
              ),
              _createDrawerItem(
                icon: Icons.exit_to_app,
                text: 'Logout',
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AuthenticationScreen()));
                },
              ),
            ],
          ),
        ),
      ),
      body: ServicePage(),
    );
  }

  // Refactored ListTile creation to reduce code repetition
  Widget _createDrawerItem(
      {required IconData icon,
      required String text,
      required GestureTapCallback onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(text),
          )
        ],
      ),
      onTap: onTap,
    );
  }
}
