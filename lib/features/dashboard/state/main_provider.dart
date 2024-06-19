import 'package:doctors_appointment/features/appointment/data/appointment_model.dart';
import 'package:doctors_appointment/features/appointment/services/appointment_services.dart';
import 'package:doctors_appointment/features/auth/pages/register/data/user_model.dart';
import 'package:doctors_appointment/features/auth/pages/register/services/registration_services.dart';
import 'package:doctors_appointment/features/home/views/components/reviews/data/review_model.dart';
import 'package:doctors_appointment/features/home/views/components/reviews/services/review_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DataModel {
  List<UserModel> doctors;
  List<UserModel> patients;
  List<ReviewModel> reviews;
  List<AppointmentModel> appointments;
  DataModel({
    this.doctors = const [],
    this.patients = const [],
    this.reviews = const [],
    this.appointments = const [],
  });
}

final allDataStreamProvider = StreamProvider<DataModel>((ref) async* {
  var data = DataModel();
  var users = RegistrationServices.getUsers();
  var reviews = ReviewServices.getAllReviews();
  var appointments = AppointmentServices.getAllAppointments();
  await for (var item in users) {
    data.doctors = item.where((element) => element.userRole!.toLowerCase() == 'doctor').toList();
    data.patients = item.where((element) => element.userRole!.toLowerCase() == 'patient').toList();
    yield data;
  }
  await for (var item in reviews) {
    data.reviews = item;
    yield data;
  }
  await for (var item in appointments) {
    data.appointments = item;
    yield data;
  }
});
