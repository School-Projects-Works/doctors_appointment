import 'dart:convert';

import 'package:faker/faker.dart';



class ReviewModel {
  String id;
  String review;
  String userId;
  String userName;
  double rating;
  String doctorId;
  int createdAt;
  ReviewModel({
    required this.id,
    required this.review,
    required this.userId,
    required this.userName,
    required this.rating,
    required this.doctorId,
    required this.createdAt,
  });

  ReviewModel copyWith({
    String? id,
    String? review,
    String? userId,
    String? userName,
    double? rating,
    String? doctorId,
    int? createdAt,
  }) {
    return ReviewModel(
      id: id ?? this.id,
      review: review ?? this.review,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      rating: rating ?? this.rating,
      doctorId: doctorId ?? this.doctorId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'review': review,
      'userId': userId,
      'userName': userName,
      'rating': rating,
      'doctorId': doctorId,
      'createdAt': createdAt,
    };
  }

  factory ReviewModel.fromMap(Map<String, dynamic> map) {
    return ReviewModel(
      id: map['id'] ?? '',
      review: map['review'] ?? '',
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? '',
      rating: map['rating']?.toDouble() ?? 0.0,
      doctorId: map['doctorId'] ?? '',
      createdAt: map['createdAt']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory ReviewModel.fromJson(String source) => ReviewModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ReviewModel(id: $id, review: $review, userId: $userId, userName: $userName, rating: $rating, doctorId: $doctorId, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is ReviewModel &&
      other.id == id &&
      other.review == review &&
      other.userId == userId &&
      other.userName == userName &&
      other.rating == rating &&
      other.doctorId == doctorId &&
      other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      review.hashCode ^
      userId.hashCode ^
      userName.hashCode ^
      rating.hashCode ^
      doctorId.hashCode ^
      createdAt.hashCode;
  }

 static List<ReviewModel> dummyReviews(String doctorId){
    final _faker = Faker();
    List<ReviewModel> reviews = [];
    var count = _faker.randomGenerator.integer(15, min: 5);
    for (var i = 0; i < count; i++) {
      reviews.add(ReviewModel(
        id: _faker.guid.guid(),
        review: _faker.lorem.sentences(_faker.randomGenerator.integer(5, min: 1)).join(' '),
        userId: _faker.guid.guid(),
        userName: _faker.person.name(),
        rating: _faker.randomGenerator.decimal(scale: 5),
        doctorId: doctorId,
        createdAt: DateTime.now().millisecondsSinceEpoch,
      ));
    }
    return reviews;
  }
}
