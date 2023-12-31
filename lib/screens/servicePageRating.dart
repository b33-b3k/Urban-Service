import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ServiceDetailsPage extends StatefulWidget {
  final Map<String, dynamic> service;

  const ServiceDetailsPage({Key? key, required this.service}) : super(key: key);

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
    final serviceKey = widget.service['title']; // Unique key for each service

    setState(() {
      reviews = prefs.getStringList('${serviceKey}_reviews') ?? [];
      rating = prefs.getDouble('${serviceKey}_rating') ?? 0;
    });
  }

  Future<void> saveData() async {
    final prefs = await SharedPreferences.getInstance();
    final serviceKey = widget.service['title']; // Unique key for each service

    prefs.setStringList('${serviceKey}_reviews', reviews);
    prefs.setDouble('${serviceKey}_rating', rating);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.service['title']),
        backgroundColor: Colors.blueGrey, // Example color
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
          ],
        ),
      ),
    );
  }

  Widget buildServiceTitle() {
    return Text(
      widget.service['title'],
      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    );
  }

  Widget buildServiceImage() {
    return Image.network(
      widget.service['image'],
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
      widget.service['description'],
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
                  leading: const Icon(Icons.person, color: Colors.blueGrey),
                  title: Text(reviews[index]),
                ),
              );
            },
          );
  }
}
