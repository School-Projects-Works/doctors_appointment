import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AppointmentModel {
  String id;
  String doctorId;
  String patientId;
  String doctorName;
  String doctorPhone;
  String doctorImage;
  String patientName;
  String patientPhone;
  String? patientImage;
  String date;
  String time;
  String status;
  int? createdAt;
  AppointmentModel({
    required this.id,
    required this.doctorId,
    required this.patientId,
    required this.doctorName,
    required this.doctorPhone,
    required this.doctorImage,
    required this.patientName,
    required this.patientPhone,
    this.patientImage,
    required this.date,
    required this.time,
    required this.status,
    this.createdAt,
  });

  AppointmentModel copyWith({
    String? id,
    String? doctorId,
    String? patientId,
    String? doctorName,
    String? doctorPhone,
    String? doctorImage,
    String? patientName,
    String? patientPhone,
    ValueGetter<String?>? patientImage,
    String? date,
    String? time,
    String? status,
    ValueGetter<int?>? createdAt,
  }) {
    return AppointmentModel(
      id: id ?? this.id,
      doctorId: doctorId ?? this.doctorId,
      patientId: patientId ?? this.patientId,
      doctorName: doctorName ?? this.doctorName,
      doctorPhone: doctorPhone ?? this.doctorPhone,
      doctorImage: doctorImage ?? this.doctorImage,
      patientName: patientName ?? this.patientName,
      patientPhone: patientPhone ?? this.patientPhone,
      patientImage: patientImage != null ? patientImage() : this.patientImage,
      date: date ?? this.date,
      time: time ?? this.time,
      status: status ?? this.status,
      createdAt: createdAt != null ? createdAt() : this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'doctorId': doctorId,
      'patientId': patientId,
      'doctorName': doctorName,
      'doctorPhone': doctorPhone,
      'doctorImage': doctorImage,
      'patientName': patientName,
      'patientPhone': patientPhone,
      'patientImage': patientImage,
      'date': date,
      'time': time,
      'status': status,
      'createdAt': createdAt,
    };
  }

  factory AppointmentModel.fromMap(Map<String, dynamic> map) {
    return AppointmentModel(
      id: map['id'] ?? '',
      doctorId: map['doctorId'] ?? '',
      patientId: map['patientId'] ?? '',
      doctorName: map['doctorName'] ?? '',
      doctorPhone: map['doctorPhone'] ?? '',
      doctorImage: map['doctorImage'] ?? '',
      patientName: map['patientName'] ?? '',
      patientPhone: map['patientPhone'] ?? '',
      patientImage: map['patientImage'],
      date: map['date'] ?? '',
      time: map['time'] ?? '',
      status: map['status'] ?? '',
      createdAt: map['createdAt']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory AppointmentModel.fromJson(String source) =>
      AppointmentModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AppointmentModel(id: $id, doctorId: $doctorId, patientId: $patientId, doctorName: $doctorName, doctorPhone: $doctorPhone, doctorImage: $doctorImage, patientName: $patientName, patientPhone: $patientPhone, patientImage: $patientImage, date: $date, time: $time, status: $status, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is AppointmentModel &&
      other.id == id &&
      other.doctorId == doctorId &&
      other.patientId == patientId &&
      other.doctorName == doctorName &&
      other.doctorPhone == doctorPhone &&
      other.doctorImage == doctorImage &&
      other.patientName == patientName &&
      other.patientPhone == patientPhone &&
      other.patientImage == patientImage &&
      other.date == date &&
      other.time == time &&
      other.status == status &&
      other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      doctorId.hashCode ^
      patientId.hashCode ^
      doctorName.hashCode ^
      doctorPhone.hashCode ^
      doctorImage.hashCode ^
      patientName.hashCode ^
      patientPhone.hashCode ^
      patientImage.hashCode ^
      date.hashCode ^
      time.hashCode ^
      status.hashCode ^
      createdAt.hashCode;
  }
}
