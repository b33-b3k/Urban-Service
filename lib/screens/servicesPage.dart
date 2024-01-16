// import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:vendor_app/screens/servicePageRating.dart';
import 'package:http/http.dart' as http;

class Service {
  final String id;
  final String title;
  final String description;
  final String image;
  final String category;

  Service(
      {required this.id,
      required this.title,
      required this.description,
      required this.image,
      required this.category});

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['_id'],
      title: json['title'],
      description: json['desc'],
      image: json['image'].isEmpty
          ? ''
          : json['image'][0], // Assuming image is an array
      category: json['category'],
    );
  }
}

class ServicePage extends StatefulWidget {
  @override
  State<ServicePage> createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage> {
  List<Service> services = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchServices();
  }

  Future<void> fetchServices() async {
    try {
      var url =
          'http://localhost:8000/api/v1/service'; // Replace with your API URL
      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        List<dynamic> serviceJson = json.decode(response.body);
        print(serviceJson);
        setState(() {
          services = serviceJson.map((json) => Service.fromJson(json)).toList();
          isLoading = false;
        });
      } else {
        // Handle error
        print('Failed to load services');
      }
    } catch (e) {
      print(e);
      // Handle exception
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: services.map((service) {
            return GestureDetector(
              onTap: () {
                //navigate to
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ServiceDetailsPage(
                      title: service.title,
                      description: service.description,
                      photo: service.image,
                      category: service.category,
                    ),
                  ),
                );
              },
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: 150,
                      width: 150,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                        image: DecorationImage(
                          image: NetworkImage(service.image!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            service.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            service.description,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

// class ServicePage extends StatelessWidget {
//   final List<String> categories = [
//     'Category 1',
//     'Category 2',
//     'Category 3',
//     'Category 4'
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Services'),
//       ),
//       body: ListView.builder(
//         itemCount: categories.length,
//         itemBuilder: (BuildContext context, int index) {
//           return Padding(
//             padding:
//                 const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//             child: Card(
//               elevation: 4,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10.0),
//               ),
//               child: ListTile(
//                 contentPadding:
//                     EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
//                 title: Text(
//                   categories[index],
//                   style: TextStyle(
//                     fontSize: 18.0,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 trailing: Icon(Icons.arrow_forward_ios),
//                 onTap: () {
//                   // Handle category selection here
//                 },
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
}
