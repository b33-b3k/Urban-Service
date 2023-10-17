import 'package:flutter/material.dart';
import 'package:vendor_app/screens/servicesPage.dart';
import 'package:vendor_app/screens/vendorScreen.dart';

//main screen of the app homescreen where services are displayed
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const SizedBox(
              height: 40,
            ),
            const ListTile(
              title: Text("Urban Services",
                  style: TextStyle(
                      color: Colors.deepPurple,
                      fontSize: 30,
                      fontWeight: FontWeight.bold)),
            ),
            const SizedBox(
              height: 20,
            ),
            const Divider(),
            ListTile(
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            const Divider(),
            const SizedBox(
              height: 10,
            ),
            ListTile(
              title: const Text('Become Vendor'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => VendorFormScreen()));
              },
            ),
            const Divider(),
            const SizedBox(
              height: 10,
            ),
            const SizedBox(
              height: 10,
            ),
            ListTile(
              title: const Text('Logout'),
              onTap: () {
                // Add about logic here
              },
            ),
            const Divider(),//a simpler line divider
          ],
        ),
      ),
      body: ServicePage(),
    );
  }
}
