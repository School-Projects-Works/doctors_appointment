import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctors_appointment/features/appointment/data/appointment_model.dart';

class AppointmentServices {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final CollectionReference _appointmentsCollection =
      _firestore.collection('appointments');

  static Stream<List<AppointmentModel>> getPatientAppointments(String id) {
    final snapshot =
        _appointmentsCollection.where('patientId', isEqualTo: id).snapshots();
    return snapshot.map((event) => event.docs
        .map((e) => AppointmentModel.fromMap(e.data() as Map<String, dynamic>))
        .toList());
  }

  static Stream<List<AppointmentModel>> getDoctorAppointments(String id) {
    final snapshot =
        _appointmentsCollection.where('doctorId', isEqualTo: id).snapshots();
    return snapshot.map((event) => event.docs
        .map((e) => AppointmentModel.fromMap(e.data() as Map<String, dynamic>))
        .toList());
  }

  static Future<bool> createAppointment(AppointmentModel appointment) async {
    try {
      await _appointmentsCollection
          .doc(appointment.id)
          .set(appointment.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }

  //update appointment status
  static Future<bool> updateAppointment(
      String id, Map<String, dynamic> data) async {
    try {
      await _appointmentsCollection.doc(id).update(data);
      return true;
    } catch (e) {
      return false;
    }
  }

  static Stream<List<AppointmentModel>> getAllAppointments() {
    final snapshot = _appointmentsCollection.snapshots();
    return snapshot.map((event) => event.docs
        .map((e) => AppointmentModel.fromMap(e.data() as Map<String, dynamic>))
        .toList());
  }

  static Future<List<AppointmentModel>> getAppByUserAndDoctor(
      String s, String doctorId) async {
    try {
      final snapshot = await _appointmentsCollection
          .where('patientId', isEqualTo: s)
          .where('doctorId', isEqualTo: doctorId)
          .get();
      return snapshot.docs
          .map(
              (e) => AppointmentModel.fromMap(e.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print(e);
      return [];
    }
  }

  static String getId() {
    return _firestore.collection('appointments').doc().id;
  }
}
