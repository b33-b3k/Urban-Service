// import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:vendor_app/screens/servicePageRating.dart';

class ServicePage extends StatelessWidget {
  final List<Map<String, String>> services = [
    {
      'title': 'Service 1',
      'description': 'Description for Service 1',
      'image': 'https://via.placeholder.com/150',
      'category': 'Category 1',
    },
    {
      'title': 'Service 2',
      'description': 'Description for Service 2',
      'image': 'https://via.placeholder.com/150',
      'category': 'Category 1',
    },
    {
      'title': 'Service 3',
      'description': 'Description for Service 3',
      'image': 'https://via.placeholder.com/150',
      'category': 'Category 2',
    },
    {
      'title': 'Service 4',
      'description': 'Description for Service 4',
      'image': 'https://via.placeholder.com/150',
      'category': 'Category 2',
    },
  ];

  @override
  Widget build(BuildContext context) {
    Map<String, List<Map<String, String>>> categorizedServices = {};
    services.forEach((service) {
      if (!categorizedServices.containsKey(service['category'])) {
        categorizedServices[service['category']!] = [];
      }
      categorizedServices[service['category']]!.add(service);
    });

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categorizedServices.keys.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Chip(
                      label: Text(
                        categorizedServices.keys.elementAt(index),
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Colors.blue,
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: 10,
            ),
            ...categorizedServices.entries.map((entry) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      entry.key,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: entry.value.map((service) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ServiceDetailsPage(
                                  service: service,
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
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                    ),
                                    image: DecorationImage(
                                      image: NetworkImage(service['image']!),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        service['title']!,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        service['description']!,
                                        style: TextStyle(
                                          fontSize: 14,
                                        ),
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
                ],
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
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
