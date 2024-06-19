import 'package:doctors_appointment/features/home/views/components/reviews/data/review_model.dart';
import 'package:doctors_appointment/features/home/views/components/reviews/services/review_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final reviewStreamProvider = StreamProvider.autoDispose.family<List<ReviewModel>, String>((ref, doctorId)async* {
  var data = ReviewServices.getReviews(doctorId);
  await for (var item in data) {
    yield item;
  }
});