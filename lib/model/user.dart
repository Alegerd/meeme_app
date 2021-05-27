import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppUser {
  String id;
  String firstName;
  String lastName;
  String profileImageUrl;

  AppUser.fromFireBase(User user) {
    id = user.uid;
  }

  AppUser.fromJson(Map<String, dynamic> values) {
    if (values == null)
      return;

    id = values['id'];
    firstName = values['firstName'];
    lastName = values['lastName'];
    profileImageUrl = values['profileImageUrl'];
  }

  AppUser.fromDocument(DocumentSnapshot documentSnapshot) {
    id = documentSnapshot['id'];
    firstName = documentSnapshot['firstName'];
    lastName = documentSnapshot['lastName'];
    profileImageUrl = documentSnapshot['profileImageUrl'];
  }


  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "firstName": firstName,
      "lastName": lastName,
      "profileImageUrl": profileImageUrl
    };
  }
}