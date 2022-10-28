// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String name;
  final String email;
  final String profileIamge;
  final int point;
  final String rank;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.profileIamge,
    required this.point,
    required this.rank,
  });

  factory User.fromDoc(DocumentSnapshot userDoc) {
    final userData = userDoc.data() as Map<String, dynamic>?;

    return User(
      id: userDoc.id,
      name: userData!['name'],
      email: userData['email'],
      profileIamge: userData['profileIamge'],
      point: userData['point'],
      rank: userData['rank'],
    );
  }

  factory User.initialUser() {
    return User(
      id: '',
      name: '',
      email: '',
      profileIamge: '',
      point: -1,
      rank: '',
    );
  }

  @override
  List<Object> get props {
    return [
      id,
      name,
      email,
      profileIamge,
      point,
      rank,
    ];
  }

  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email, profileIamge: $profileIamge, point: $point, rank: $rank)';
  }
}
