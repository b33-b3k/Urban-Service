import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
//http
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:vendor_app/screens/formPage.dart';

class ServiceDetailsPage extends StatefulWidget {
  final String id;
  final String title;
  final String description;
  final String photo;
  final String category;
  const ServiceDetailsPage({
    Key? key,
    required this.title,
    required this.description,
    required this.photo,
    required this.category,
    required this.id,
  }) : super(key: key);

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
    final serviceKey = widget.title; // Unique key for each service

    setState(() {
      reviews = prefs.getStringList('${serviceKey}_reviews') ?? [];
      rating = prefs.getDouble('${serviceKey}_rating') ?? 0;
    });
  }

  Future<void> saveData() async {
    final prefs = await SharedPreferences.getInstance();
    final serviceKey = widget.title; // Unique key for each service

    prefs.setStringList('${serviceKey}_reviews', reviews);
    prefs.setDouble('${serviceKey}_rating', rating);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.greenAccent, // Example color
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildServiceTitle(),
            const SizedBox(height: 10),
            buildServiceImage(),
            const SizedBox(height: 20),
            buildServiceDescription(),
            const SizedBox(height: 20),
            buildRatingBar(),
            const SizedBox(height: 20),
            buildReviewInput(),
            const SizedBox(height: 20),
            buildReviewsHeader(),
            const SizedBox(height: 10),
            buildReviewsList(),
            const SizedBox(height: 10),
            buildBookingButton(),
          ],
        ),
      ),
    );
  }

  void showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Booking Successful'),
          content: Text('You have successfully booked ${widget.title}!'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'OK',
              ),
            ),
          ],
        );
      },
    );
  }

  Widget buildBookingButton() {
    return ElevatedButton(
      onPressed: () {
        // Simulate a successful booking response from the backend
        // Replace this with actual backend integration logic
        // For demonstration purposes, we'll assume a successful booking after a delay
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => UpKeepFormPage(
                      serviceId: widget.id,
                    )));
        // Future.delayed(Duration(seconds: 2), () {
        //   showSuccessDialog();
        // });
      },
      child: const Center(
          child: Text('Book Now',
              style: TextStyle(
                  color: Colors.greenAccent,
                  fontSize: 18,
                  fontWeight: FontWeight.bold))),
    );
  }

  Widget buildServiceTitle() {
    return Text(
      widget.title,
      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    );
  }

  Widget buildServiceImage() {
    return Image.network(
      widget.photo,
      height: 200,
      width: double.infinity,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return const Center(child: CircularProgressIndicator());
      },
      errorBuilder: (context, error, stackTrace) =>
          Image.asset('assets/images/placeholder.png'),
    );
  }

  Widget buildServiceDescription() {
    return Text(
      widget.description,
      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
    );
  }

  Widget buildRatingBar() {
    return RatingBar.builder(
      initialRating: rating,
      minRating:
          1, // Minimum rating, can be set to 0 if you want 0 stars to be an option
      direction: Axis.horizontal,
      allowHalfRating: true,
      itemCount: 5,
      itemSize: 30.0,
      itemBuilder: (context, _) => Icon(
        // This is how you define itemBuilder for RatingBar
        Icons.star,
        color: Colors.amber,
      ),
      onRatingUpdate: (newRating) {
        setState(() {
          rating = newRating;
          saveData();
        });
      },
    );
  }

  Widget buildReviewInput() {
    return TextField(
      decoration: const InputDecoration(
        hintText: 'Leave a review...',
        border: OutlineInputBorder(),
        filled: true,
      ),
      onSubmitted: (review) {
        if (review.isNotEmpty) {
          setState(() {
            reviews.add(review);
            saveData();
          });
        }
      },
    );
  }

  Widget buildReviewsHeader() {
    return const Text(
      'Reviews',
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }

  Widget buildReviewsList() {
    return reviews.isEmpty
        ? const Text("No reviews yet.")
        : ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: reviews.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.person, color: Colors.deepPurple),
                  title: Text(reviews[index]),
                ),
              );
            },
          );
  }
}
