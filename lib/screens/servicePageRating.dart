import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ServiceDetailsPage extends StatefulWidget {
  final Map<String, dynamic> service;

  ServiceDetailsPage({required this.service});

  @override
  _ServiceDetailsPageState createState() => _ServiceDetailsPageState();
}

class _ServiceDetailsPageState extends State<ServiceDetailsPage> {
  double rating = 0;
  List<String> reviews = [];

  @override
  void initState() {
    super.initState();
    loadSavedData();
  }

  Future<void> loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    final serviceKey =
        widget.service['title']; // Use a unique key for each service

    setState(() {
      reviews = prefs.getStringList('${serviceKey}_reviews') ?? [];
      rating = prefs.getDouble('${serviceKey}_rating') ?? 0;
    });
  }

  Future<void> saveData() async {
    final prefs = await SharedPreferences.getInstance();
    final serviceKey =
        widget.service['title']; // Use a unique key for each service

    prefs.setStringList('${serviceKey}_reviews', reviews);
    prefs.setDouble('${serviceKey}_rating', rating);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.service['title']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.service['title'],
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Image.network(widget.service['image']),
            SizedBox(height: 20),
            Text(
              widget.service['description'],
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 20),
            RatingBar.builder(
              initialRating: rating,
              minRating: 0,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemSize: 30.0,
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (newRating) {
                setState(() {
                  rating = newRating;
                  saveData();
                });
              },
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                hintText: 'Leave a review...',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (review) {
                setState(() {
                  reviews.add(review);
                  saveData();
                });
              },
            ),
            SizedBox(height: 20),
            Text(
              'Reviews',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: reviews.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(reviews[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
