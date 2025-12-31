import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String? userId;
  final String? fullName;
  final String? accessToken;
  final String? email;
  final String? gender;

  const UserModel({
    this.userId,
    this.fullName,
    this.accessToken,
    this.email,
    this.gender
  });

  static fromJson(Map<String, dynamic>? mapData) {
    if (mapData == null) return null;

    final String? userId = mapData['userId'];
    final String? fullName = mapData['fullName'];
    final String? accessToken = mapData['accessToken'];
    final String? email = mapData['email'];
    final String? gender = mapData['gender'];

    return UserModel(
      userId: userId,
      fullName: fullName,
      accessToken: accessToken,
      email: email,
      gender: gender
    );
  }

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'fullName': fullName,
    'accessToken': accessToken,
    'email': email,
    'gender': gender
  };

  UserModel copyWith({
    String? userId,
    String? fullName,
    String? accessToken,
    String? email,
    String? gender
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      fullName: fullName ?? this.fullName,
      accessToken: accessToken ?? this.accessToken,
      email: email ?? this.email,
      gender: gender ?? this.gender
    );
  }

  @override
  List<Object?> get props => [userId];

  @override
  String toString() {
    return 'User: id:$userId, fullName: $fullName, accessToken: $accessToken, email: $email, gender: $gender';
  }
}
