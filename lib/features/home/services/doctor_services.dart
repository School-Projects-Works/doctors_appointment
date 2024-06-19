import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctors_appointment/features/auth/pages/register/data/user_model.dart';

class DoctorServices {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final CollectionReference _doctorsCollection =
      _firestore.collection('users');

  static Stream<List<UserModel>> getDoctors() {
    final snapshot = _doctorsCollection
        .where('userRole', isEqualTo: 'Doctor')
        .where('userStatus', whereIn: ['active', 'inactive']).snapshots();
    return snapshot.map((event) => event.docs
        .map((e) => UserModel.fromMap(e.data() as Map<String, dynamic>))
        .toList());
  }

  static Future<UserModel?> getDoctorById(String id) async {
    final snapshot = await _doctorsCollection.doc(id).get();
    if (snapshot.exists) {
      return UserModel.fromMap(snapshot.data() as Map<String, dynamic>);
    }
    return null;
  }

  static Future<void> updateDoctorStatus(String id, String status) async {
    await _doctorsCollection.doc(id).update({'userStatus': status});
  }

  static Future<void> updateDoctor(UserModel user) async {
    await _doctorsCollection.doc(user.id).update(user.toMap());
  }


  static Future<List<UserModel>> getAllDoctors() async {
    final snapshot = await _doctorsCollection
        .where('userRole', isEqualTo: 'Doctor')
        .get();
    return snapshot.docs
        .map((e) => UserModel.fromMap(e.data() as Map<String, dynamic>))
        .toList();
  }
}
