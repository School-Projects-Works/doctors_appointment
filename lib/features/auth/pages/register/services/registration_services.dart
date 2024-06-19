import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctors_appointment/features/auth/pages/register/data/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:universal_html/html.dart';

class RegistrationServices {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final CollectionReference _users = _firestore.collection('users');
  static final Storage _localStorage = window.localStorage;
  static String getId() {
    return _firestore.collection('users').doc().id;
  }

  static Future<(String, User?)> loginUser(
      String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return ('Login Successfully', userCredential.user!);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return ('No user found for that email.', null);
      } else if (e.code == 'wrong-password') {
        return ('Wrong password provided for that user.', null);
      } else if (e.toString().contains('invalid') ||
          e.toString().contains('incorrect')) {
        return ('No user found for that email.', null);
      }
      return (e.message.toString(), null);
    } catch (e) {
      return ('An error occurred while logging in.', null);
    }
  }

  static Future<(String, User?)> registerUser(UserModel user) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: user.email!, password: user.password!);
      //send verification email
      if (!userCredential.user!.emailVerified) {
        await userCredential.user!.sendEmailVerification();
      }
      user.id = userCredential.user!.uid;
      await _users.doc(user.id).set(user.toMap());
      return ('User created successfully', userCredential.user!);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return ('The password provided is too weak.', null);
      } else if (e.code == 'email-already-in-use') {
        return ('The account already exists for that email.', null);
      }
      return (e.message.toString(), null);
    } catch (e) {
      return ('An error occurred while registering the user.', null);
    }
  }

  static Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    _localStorage.remove('user');
  }

  static Future<UserModel?> getUserData(String uid) async {
    try {
      final DocumentSnapshot documentSnapshot = await _users.doc(uid).get();
      if (documentSnapshot.exists) {
        return UserModel.fromMap(
            documentSnapshot.data() as Map<String, dynamic>);
      }
      return null;
    } catch (error) {
      return null;
    }
  }

  static createUser(UserModel item) async{
    await _users.doc(item.id).set(item.toMap());
  }


  static Stream<List<UserModel>> getUsers(){
    return _users.snapshots().map((event) => event.docs.map((e) => UserModel.fromMap(e.data() as Map<String, dynamic>)).toList());
  }

  static Future<bool> updateUser(UserModel doctor)async {
    try {
     await _users.doc(doctor.id).update(doctor.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }
}