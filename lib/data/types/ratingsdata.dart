import 'package:cloud_firestore/cloud_firestore.dart';

class Rating {
  final String userId;
  final double rating;
  final Timestamp timestamp;

  Rating({
    required this.userId,
    required this.rating,
    required this.timestamp,
  });

  // Convert the Rating object to a Map
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'rating': rating,
      'timestamp': timestamp,
    };
  }
}
