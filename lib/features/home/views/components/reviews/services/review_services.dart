import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctors_appointment/features/home/views/components/reviews/data/review_model.dart';

class ReviewServices{
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final CollectionReference _reviewsCollection = _firestore.collection('reviews');

  static Stream<List<ReviewModel>> getReviews(String doctorId) {
    final snapshot = _reviewsCollection.where('doctorId',isEqualTo: doctorId).snapshots();
    return snapshot.map((event) => event.docs
        .map((e) => ReviewModel.fromMap(e.data() as Map<String, dynamic>))
        .toList());
  }

  static Future<bool> createReview(ReviewModel review) async {
    try{
      await _reviewsCollection.doc(review.id).set(review.toMap());
    return true;
    }catch(e){
      return false;
    }
  }

  static Stream<List<ReviewModel>> getAllReviews() {
    final snapshot = _reviewsCollection.snapshots();
    return snapshot.map((event) => event.docs
        .map((e) => ReviewModel.fromMap(e.data() as Map<String, dynamic>))
        .toList());
  }

  
}