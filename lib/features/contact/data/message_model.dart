import 'dart:convert';
import 'package:flutter/widgets.dart';

class ContactMessageModel {
  String? message;
  String? id;
  String? senderId;
  String? senderName;
  String? senderEmail;
  int? createdAt;
  ContactMessageModel({
    this.message,
    this.id,
    this.senderId,
    this.senderName,
    this.senderEmail,
    this.createdAt,
  });

  ContactMessageModel copyWith({
    ValueGetter<String?>? message,
    ValueGetter<String?>? id,
    ValueGetter<String?>? senderId,
    ValueGetter<String?>? senderName,
    ValueGetter<String?>? senderEmail,
    ValueGetter<int?>? createdAt,
  }) {
    return ContactMessageModel(
      message: message != null ? message() : this.message,
      id: id != null ? id() : this.id,
      senderId: senderId != null ? senderId() : this.senderId,
      senderName: senderName != null ? senderName() : this.senderName,
      senderEmail: senderEmail != null ? senderEmail() : this.senderEmail,
      createdAt: createdAt != null ? createdAt() : this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'id': id,
      'senderId': senderId,
      'senderName': senderName,
      'senderEmail': senderEmail,
      'createdAt': createdAt,
    };
  }

  factory ContactMessageModel.fromMap(Map<String, dynamic> map) {
    return ContactMessageModel(
      message: map['message'],
      id: map['id'],
      senderId: map['senderId'],
      senderName: map['senderName'],
      senderEmail: map['senderEmail'],
      createdAt: map['createdAt']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory ContactMessageModel.fromJson(String source) => ContactMessageModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ContactMessageModel(message: $message, id: $id, senderId: $senderId, senderName: $senderName, senderEmail: $senderEmail, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is ContactMessageModel &&
      other.message == message &&
      other.id == id &&
      other.senderId == senderId &&
      other.senderName == senderName &&
      other.senderEmail == senderEmail &&
      other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return message.hashCode ^
      id.hashCode ^
      senderId.hashCode ^
      senderName.hashCode ^
      senderEmail.hashCode ^
      createdAt.hashCode;
  }
}
