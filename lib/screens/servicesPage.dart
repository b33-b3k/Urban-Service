import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:vendor_app/screens/servicePageRating.dart';

class Service {
  final String id;
  final String title;
  final String description;
  final String image;
  final String category;
  //users is an array
  Service({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.category,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['_id'],
      title: json['title'],
      description: json['desc'],
      image: json['image'].isEmpty ? '' : json['image'][0],
      category: json['category'],
    );
  }
}

class ServicePage extends StatefulWidget {
  @override
  _ServicePageState createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage> {
  List<Service> services = [];
  List<Service> filteredServices = [];
  bool isLoading = true;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchServices();
    getAllCategories();
  }

  Future<Map<String, String>> getAllCategories() async {
    try {
      var url =
          'http://localhost:8000/api/v1/service/category'; // Replace with your API endpoint
      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        List<dynamic> categoriesJson = json.decode(response.body);
        Map<String, String> categoryMap = {};
        categoriesJson.forEach((category) {
          String categoryId = category['_id'];
          String categoryName = category['name'];
          categoryMap[categoryId] = categoryName;
        });
        return categoryMap;
      } else {
        print('Failed to load categories');
        return {};
      }
    } catch (e) {
      print(e);
      return {};
    }
  }

  Future<String> getCategoryName(String categoryId) async {
    Map<String, String> allCategories = await getAllCategories();
    return allCategories[categoryId] ?? '';
  }

  void checkCategoryNames(List<String> categoryIds) async {
    for (String categoryId in categoryIds) {
      String? categoryName = await getCategoryName(categoryId);
      if (categoryName != null) {
        print('Category name for ID $categoryId: $categoryName');
      } else {
        print('Failed to get category name for ID $categoryId');
      }
    }
  }

  Future<void> fetchServices() async {
    try {
      var url = 'http://localhost:8000/api/v1/service/';
      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        List<dynamic> serviceJson = json.decode(response.body);
        setState(() {
          services = serviceJson.map((json) => Service.fromJson(json)).toList();
          filteredServices = services;
          isLoading = false;
        });
      } else {
        print('Failed to load services');
      }
    } catch (e) {
      print(e);
    }
  }

  void filterServices(String query) {
    setState(() {
      filteredServices = services
          .where((service) =>
              service.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Service Page'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: ServiceSearch(services));
            },
          ),
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: filteredServices.length,
              itemBuilder: (context, index) {
                final service = filteredServices[index];
                return ListTile(
                  title: Text(service.title),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(service.description),
                      FutureBuilder<String>(
                        future: getCategoryName(service.category),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Text(
                                'Loading category...'); // Placeholder while waiting for the result
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            return Text('Category: ${snapshot.data}');
                          }
                        },
                      ),
                    ],
                  ),
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(service.image),
                  ),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ServiceDetailsPage(
                        id: service.id,
                        title: service.title,
                        description: service.description,
                        photo: service.image,
                        category: service.category,
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class ServiceSearch extends SearchDelegate<String> {
  final List<Service> services;

  ServiceSearch(this.services);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<Map<String, String>>(
      future: getAllCategories(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final categoryNames = snapshot.data!;
          final results = services
              .where((service) =>
                  service.title.toLowerCase().contains(query.toLowerCase()) ||
                  service.category
                      .toLowerCase()
                      .contains(query.toLowerCase()) ||
                  categoryNames[service.category]!
                      .toLowerCase()
                      .contains(query.toLowerCase())) // Search by category name
              .toList();
          return ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              final service = results[index];
              return ListTile(
                title: Text(service.title),
                subtitle: Text(service.description),
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(service.image),
                ),
                onTap: () {
                  close(context, service.title);
                },
              );
            },
          );
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<Map<String, String>>(
      future: getAllCategories(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final categoryNames = snapshot.data!;
          final results = services
              .where((service) =>
                  service.title.toLowerCase().contains(query.toLowerCase()) ||
                  service.category
                      .toLowerCase()
                      .contains(query.toLowerCase()) ||
                  categoryNames[service.category]!
                      .toLowerCase()
                      .contains(query.toLowerCase())) // Search by category name
              .toList();
          return ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              final service = results[index];
              return ListTile(
                title: Text(service.title),
                subtitle: Text(service.description),
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(service.image),
                ),
                onTap: () {
                  query = service.title;
                  showResults(context);
                },
              );
            },
          );
        }
      },
    );
  }

  Future<Map<String, String>> getAllCategories() async {
    try {
      var url =
          'http://localhost:8000/api/v1/service/category'; // Replace with your API endpoint
      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        List<dynamic> categoriesJson = json.decode(response.body);
        Map<String, String> categoryMap = {};
        categoriesJson.forEach((category) {
          String categoryId = category['_id'];
          String categoryName = category['name'];
          categoryMap[categoryId] = categoryName;
        });
        return categoryMap;
      } else {
        print('Failed to load categories');
        return {};
      }
    } catch (e) {
      print(e);
      return {};
    }
  }

  Future<String> getCategoryName(String categoryId) async {
    Map<String, String> allCategories = await getAllCategories();
    return allCategories[categoryId] ?? '';
  }
}
