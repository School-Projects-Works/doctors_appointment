import 'dart:convert';

import 'package:doctors_appointment/core/constatnts/doctor_specialty.dart';
import 'package:doctors_appointment/core/constatnts/regions.dart';
import 'package:faker/faker.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class UserModel {
  String? id;
  String? email;
  String? userName;
  String? userRole;
  String? userStatus;
  String? userImage;
  String? userPhone;
  String? userGender;
  String? password;
  Map<String, dynamic>? userAddress;
  Map<String, dynamic>? userMetaData;
  int? createdAt;
  UserModel({
    this.id,
    this.email,
    this.userName,
    this.userRole,
    this.userStatus,
    this.userImage,
    this.userPhone,
    this.userGender,
    this.password,
    this.userAddress,
    this.userMetaData,
    this.createdAt,
  });

  UserModel copyWith({
    ValueGetter<String?>? id,
    ValueGetter<String?>? email,
    ValueGetter<String?>? userName,
    ValueGetter<String?>? userRole,
    ValueGetter<String?>? userStatus,
    ValueGetter<String?>? userImage,
    ValueGetter<String?>? userPhone,
    ValueGetter<String?>? userGender,
    ValueGetter<String?>? password,
    ValueGetter<Map<String, dynamic>?>? userAddress,
    ValueGetter<Map<String, dynamic>?>? userMetaData,
    ValueGetter<int?>? createdAt,
  }) {
    return UserModel(
      id: id != null ? id() : this.id,
      email: email != null ? email() : this.email,
      userName: userName != null ? userName() : this.userName,
      userRole: userRole != null ? userRole() : this.userRole,
      userStatus: userStatus != null ? userStatus() : this.userStatus,
      userImage: userImage != null ? userImage() : this.userImage,
      userPhone: userPhone != null ? userPhone() : this.userPhone,
      userGender: userGender != null ? userGender() : this.userGender,
      password: password != null ? password() : this.password,
      userAddress: userAddress != null ? userAddress() : this.userAddress,
      userMetaData: userMetaData != null ? userMetaData() : this.userMetaData,
      createdAt: createdAt != null ? createdAt() : this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'userName': userName,
      'userRole': userRole,
      'userStatus': userStatus,
      'userImage': userImage,
      'userPhone': userPhone,
      'userGender': userGender,
      'userAddress': userAddress,
      'userMetaData': userMetaData,
      'createdAt': createdAt,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      email: map['email'],
      userName: map['userName'],
      userRole: map['userRole'],
      userStatus: map['userStatus'],
      userImage: map['userImage'],
      userPhone: map['userPhone'],
      userGender: map['userGender'],
      userAddress: Map<String, dynamic>.from(map['userAddress']),
      userMetaData: Map<String, dynamic>.from(map['userMetaData']),
      createdAt: map['createdAt']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserModel(id: $id, email: $email, userName: $userName, userRole: $userRole, userStatus: $userStatus, userImage: $userImage, userPhone: $userPhone, userGender: $userGender, password: $password, userAddress: $userAddress, userMetaData: $userMetaData, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        other.id == id &&
        other.email == email &&
        other.userName == userName &&
        other.userRole == userRole &&
        other.userStatus == userStatus &&
        other.userImage == userImage &&
        other.userPhone == userPhone &&
        other.userGender == userGender &&
        other.password == password &&
        mapEquals(other.userAddress, userAddress) &&
        mapEquals(other.userMetaData, userMetaData) &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        email.hashCode ^
        userName.hashCode ^
        userRole.hashCode ^
        userStatus.hashCode ^
        userImage.hashCode ^
        userPhone.hashCode ^
        userGender.hashCode ^
        password.hashCode ^
        userAddress.hashCode ^
        userMetaData.hashCode ^
        createdAt.hashCode;
  }
}

class PatientMetaData {
  String? patientBloodGroup;
  String? patientWeight;
  String? patientHeight;
  String? patientDOB;
  String? occupation;
  PatientMetaData({
    this.patientBloodGroup,
    this.patientWeight,
    this.patientHeight,
    this.patientDOB,
    this.occupation,
  });

  PatientMetaData copyWith({
    ValueGetter<String?>? patientBloodGroup,
    ValueGetter<String?>? patientWeight,
    ValueGetter<String?>? patientHeight,
    ValueGetter<String?>? patientDOB,
    ValueGetter<String?>? occupation,
  }) {
    return PatientMetaData(
      patientBloodGroup: patientBloodGroup != null
          ? patientBloodGroup()
          : this.patientBloodGroup,
      patientWeight:
          patientWeight != null ? patientWeight() : this.patientWeight,
      patientHeight:
          patientHeight != null ? patientHeight() : this.patientHeight,
      patientDOB: patientDOB != null ? patientDOB() : this.patientDOB,
      occupation: occupation != null ? occupation() : this.occupation,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'patientBloodGroup': patientBloodGroup,
      'patientWeight': patientWeight,
      'patientHeight': patientHeight,
      'patientDOB': patientDOB,
      'occupation': occupation,
    };
  }

  factory PatientMetaData.fromMap(Map<String, dynamic> map) {
    return PatientMetaData(
      patientBloodGroup: map['patientBloodGroup'],
      patientWeight: map['patientWeight'],
      patientHeight: map['patientHeight'],
      patientDOB: map['patientDOB'],
      occupation: map['occupation'],
    );
  }

  String toJson() => json.encode(toMap());

  factory PatientMetaData.fromJson(String source) =>
      PatientMetaData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'PatientMetaData(patientBloodGroup: $patientBloodGroup, patientWeight: $patientWeight, patientHeight: $patientHeight, patientDOB: $patientDOB, occupation: $occupation)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PatientMetaData &&
        other.patientBloodGroup == patientBloodGroup &&
        other.patientWeight == patientWeight &&
        other.patientHeight == patientHeight &&
        other.patientDOB == patientDOB &&
        other.occupation == occupation;
  }

  @override
  int get hashCode {
    return patientBloodGroup.hashCode ^
        patientWeight.hashCode ^
        patientHeight.hashCode ^
        patientDOB.hashCode ^
        occupation.hashCode;
  }
}

class DoctorMetaData {
  String? doctorSpeciality;
  String? doctorExperience;
  String? hospitalName;
  DoctorMetaData({
    this.doctorSpeciality,
    this.doctorExperience,
    this.hospitalName,
  });

  DoctorMetaData copyWith({
    ValueGetter<String?>? doctorSpeciality,
    ValueGetter<String?>? doctorExperience,
    ValueGetter<String?>? hospitalName,
  }) {
    return DoctorMetaData(
      doctorSpeciality:
          doctorSpeciality != null ? doctorSpeciality() : this.doctorSpeciality,
      doctorExperience:
          doctorExperience != null ? doctorExperience() : this.doctorExperience,
      hospitalName: hospitalName != null ? hospitalName() : this.hospitalName,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'doctorSpeciality': doctorSpeciality,
      'doctorExperience': doctorExperience,
      'hospitalName': hospitalName,
    };
  }

  factory DoctorMetaData.fromMap(Map<String, dynamic> map) {
    return DoctorMetaData(
      doctorSpeciality: map['doctorSpeciality'],
      doctorExperience: map['doctorExperience'],
      hospitalName: map['hospitalName'],
    );
  }

  String toJson() => json.encode(toMap());

  factory DoctorMetaData.fromJson(String source) =>
      DoctorMetaData.fromMap(json.decode(source));

  @override
  String toString() =>
      'DoctorMetaData(doctorSpeciality: $doctorSpeciality, doctorExperience: $doctorExperience, hospitalName: $hospitalName)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DoctorMetaData &&
        other.doctorSpeciality == doctorSpeciality &&
        other.doctorExperience == doctorExperience &&
        other.hospitalName == hospitalName;
  }

  @override
  int get hashCode =>
      doctorSpeciality.hashCode ^
      doctorExperience.hashCode ^
      hospitalName.hashCode;
}

class UserAddressModel {
  String? address;
  String? city;
  String? region;
  UserAddressModel({
    this.address,
    this.city,
    this.region,
  });

  UserAddressModel copyWith({
    ValueGetter<String?>? address,
    ValueGetter<String?>? city,
    ValueGetter<String?>? region,
  }) {
    return UserAddressModel(
      address: address != null ? address() : this.address,
      city: city != null ? city() : this.city,
      region: region != null ? region() : this.region,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'address': address,
      'city': city,
      'region': region,
    };
  }

  factory UserAddressModel.fromMap(Map<String, dynamic> map) {
    return UserAddressModel(
      address: map['address'],
      city: map['city'],
      region: map['region'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserAddressModel.fromJson(String source) =>
      UserAddressModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'UserAddressModel(address: $address, city: $city, region: $region)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserAddressModel &&
        other.address == address &&
        other.city == city &&
        other.region == region;
  }

  @override
  int get hashCode => address.hashCode ^ city.hashCode ^ region.hashCode;
}

List<Map<String, dynamic>> images = [
  {
    'image':
        'https://t4.ftcdn.net/jpg/03/55/64/53/360_F_355645384_lPYHUp9YBvmq479otGTB9qJNN8efv69X.jpg',
    'gender': 'Male'
  },
  {
    'image':
        'https://media.istockphoto.com/id/1366374033/photo/shot-of-a-young-doctor-using-a-digital-tablet-in-a-modern-hospital.webp?b=1&s=170667a&w=0&k=20&c=I3nSyS-hAorfMhDCXrv16JyQ7VYgaFr7rrZDW2bC-qs=',
    'gender': 'Female'
  },
  {
    'image':
        'https://images.rawpixel.com/image_png_800/cHJpdmF0ZS9sci9pbWFnZXMvd2Vic2l0ZS8yMDI0LTAxL3Jhd3BpeGVsb2ZmaWNlNl9waG90b19wb3J0cmFpdF9raW5kX29mX2JsYWNrX21lbl93ZWFyaW5nX21lZGljYV9kZmMzNDBlMy1lOWJiLTQxY2QtODc5NS0xYTAwOTc1MWE0MWUucG5n.png',
    'gender': 'Male'
  },
  {
    'image':
        'https://img.freepik.com/free-photo/front-view-female-doctor-wearing-stethoscope_23-2149856262.jpg',
    'gender': 'Female'
  },
  {
    'image':
        'https://www.shape.com/thmb/q-mU0BCcgv9JhCkETuSILva8yfg=/1500x0/filters:no_upscale():max_bytes(200000):strip_icc()/black-female-doctor-6d6a6c2ec3ae48ceaeeae61f78b7038e.jpg',
    'gender': 'Female'
  },
  {
    'image':
        'https://i.pinimg.com/474x/96/7f/2c/967f2c118013d1002a8b672b112eab81.jpg',
    'gender': 'Female'
  },
  {
    'image':
        'https://image1.masterfile.com/getImage/NjEwOS0wNjAwNTkwOWVuLjAwMDAwMDAw=ALdGf8/6109-06005909en_Masterfile.jpg',
    'gender': 'Male'
  },
  {
    'image':
        'https://weillcornell.org/sites/default/files/styles/custom__1440x960_/public/news_images/shutterstock_1696376632.jpg?itok=cRsjNLtX',
    'gender': 'Male'
  },
  {
    'image':
        'https://lirp.cdn-website.com/61285143/dms3rep/multi/opt/BE_female-doctor-natural-hair-shutterstock-640w.jpg',
    'gender': 'Female'
  },
  {
    'image':
        'https://st2.depositphotos.com/10539404/45326/i/450/depositphotos_453260358-stock-photo-portrait-female-african-american-doctor.jpg',
    'gender': 'Female'
  },
  {
    'image':
        'https://images.rawpixel.com/image_800/cHJpdmF0ZS9sci9pbWFnZXMvd2Vic2l0ZS8yMDIzLTA5L3Jhd3BpeGVsb2ZmaWNlMl9waG90b19vZl9hX2JsYWNrX3BsdXNfc2l6ZV9mZW1hbGVfZG9jdG9yX2luX2hvc19mOGU4MTBlMi1kOWEyLTQ5OTMtOWM0Zi1kNWI2OTQ5ODVmZTNfMi5qcGc.jpg',
    'gender': 'Female'
  },
  {
    'image':
        'https://static.boredpanda.com/blog/wp-content/uploads/2020/06/black-doctor-scrubs-hoodie-respect-3-5ee9e62645745__700.jpg',
    'gender': 'Male'
  },
  {
    'image':
        'https://us.123rf.com/450wm/deniskalinichenko/deniskalinichenko2007/deniskalinichenko200700082/150715026-african-american-black-young-doctor-man-isolated-white-background.jpg?ver=6',
    'gender': 'Male'
  },
  {
    'image':
        'https://img.freepik.com/free-photo/african-american-black-doctor-man-with-stethoscope-isolated-white-background_231208-2222.jpg',
    'gender': 'Male'
  },
  {
    'image':
        'https://media.istockphoto.com/id/995966942/photo/his-surgeries-follow-a-high-success-rate.jpg?s=612x612&w=0&k=20&c=Oa-vkOGfC7lGkq7X23CyMnlaOR8newD0px1hMJPnEQk=',
    'gender': 'Male'
  },
  {
    'image':
        'https://thumbs.dreamstime.com/b/happy-male-doctor-giving-handshake-to-his-patient-closeup-portrait-smiling-healthcare-professional-stethoscope-holding-48010579.jpg',
    'gender': 'Male'
  },
  {
    'image':
        'https://img.freepik.com/free-photo/medium-shot-smiley-man-working_23-2149633863.jpg',
    'gender': 'Male'
  },
  {
    'image':
        'https://images.rawpixel.com/image_800/czNmcy1wcml2YXRlL3Jhd3BpeGVsX2ltYWdlcy93ZWJzaXRlX2NvbnRlbnQvbHIvMzQwLXBhaTI1MzAuanBn.jpg',
    'gender': 'Female'
  },
  {
    'image':
        'https://img.freepik.com/premium-photo/african-medical-doctor-man_93675-19177.jpg',
    'gender': 'Male'
  },
  {
    'image':
        'https://img.freepik.com/premium-photo/doctor-with-stethoscope-isolated-white_93675-82762.jpg?size=626&ext=jpg',
    'gender': 'Male'
  },
  {
    'image':
        'https://media.istockphoto.com/id/171296819/photo/african-american-female-doctor-holding-a-clipboard-isolated.jpg?s=612x612&w=0&k=20&c=hCJk-9gsOff8Fac04a11VMOwflMYiRXUVfAj3UTn67U=',
    'gender': 'Female'
  },
];

List<Map<String, dynamic>> africanDoctors = [
  {'userName': 'Kwame Asante', 'userGender': 'Male'},
  {'userName': 'Amina Nwachukwu', 'userGender': 'Female'},
  {'userName': 'Chukwudi Okonkwo', 'userGender': 'Male'},
  {'userName': 'Fatoumata Traore', 'userGender': 'Female'},
  {'userName': 'Juma Nyambe', 'userGender': 'Male'},
  {'userName': 'Ngozi Eze', 'userGender': 'Female'},
  {'userName': 'Malusi Dlamini', 'userGender': 'Male'},
  {'userName': 'Adebayo Olufemi', 'userGender': 'Male'},
  {'userName': 'Sanaa Abubakar', 'userGender': 'Female'},
  {'userName': 'Kofi Osei', 'userGender': 'Male'},
  {'userName': 'Zanele Ndlovu', 'userGender': 'Female'},
  {'userName': 'Ifeoma Nwokocha', 'userGender': 'Female'},
  {'userName': 'Musa Ibrahim', 'userGender': 'Male'},
  {'userName': 'Chioma Amadi', 'userGender': 'Female'},
  {'userName': 'Jabari Mwangi', 'userGender': 'Male'},
  {'userName': 'Aisha Mohammed', 'userGender': 'Female'},
  {'userName': 'Tunde Adewale', 'userGender': 'Male'},
  {'userName': 'Nala Chikwamba', 'userGender': 'Female'},
  {'userName': 'Oluwakemi Adeboye', 'userGender': 'Female'},
  {'userName': 'Lethabo Motloung', 'userGender': 'Male'},
  {'userName': 'Abebe Tadesse', 'userGender': 'Male'},
  {'userName': 'Fatima Kamara', 'userGender': 'Female'},
  {'userName': 'Jelani Mbeki', 'userGender': 'Male'},
  {'userName': 'Ama Agyemang', 'userGender': 'Female'},
  {'userName': 'Yaw Mensah', 'userGender': 'Male'},
  {'userName': 'Efua Dede', 'userGender': 'Female'},
  {'userName': 'Kojo Mensah', 'userGender': 'Male'},
  {'userName': 'Akua Aidoo', 'userGender': 'Female'},
  {'userName': 'Kwasi Boateng', 'userGender': 'Male'}
];

List<UserModel> dummyDoctor() {
  List<UserModel> doctors = [];
  var _faker = Faker();
  List<Map<String, dynamic>> takenNames = [];
  for (var i = 0; i < images.length; i++) {
    var gender = images[i]['gender'];
    var availableName = africanDoctors
        .where((element) =>
            element['userGender'] == gender && !takenNames.contains(element))
        .toList();
    var address = UserAddressModel(
        address: _faker.address.streetAddress(),
        city: _faker.address.city(),
        region: _faker.randomGenerator.element<String>(regionsInGhana));

    var metaData = PatientMetaData(
      patientBloodGroup: _faker.randomGenerator.element<String>(bloodGroups),
      patientWeight: _faker.randomGenerator.integer(100, min: 20).toString(),
      patientHeight: _faker.randomGenerator.integer(100, min: 20).toString(),
      patientDOB: DateFormat('yyyy-MM-dd')
          .format(_faker.date.dateTime(minYear: 1960, maxYear: 2005)),
      occupation: _faker.company.name(),
    );

    var user = UserModel(
        email: _faker.internet.email(),
        userName: availableName.first['userName'],
        userRole: 'Patient',
        userStatus: _faker.randomGenerator.boolean() ? 'active' : 'inactive',
        userImage: images[i]['image'],
        userPhone: _faker.phoneNumber.us(),
        userGender: images[i]['gender'],
        userAddress: address.toMap(),
        userMetaData: metaData.toMap(),
        createdAt: DateTime(
          _faker.randomGenerator.integer(2020, min: 2019),
          _faker.randomGenerator.integer(12, min: 1),
          _faker.randomGenerator.integer(12, min: 1),
          _faker.randomGenerator.integer(28, min: 1),
          0,
          0,
          0,
        ).millisecondsSinceEpoch);
    takenNames.add(availableName.first);
    doctors.add(user);
  }
  return doctors;
}
