import 'package:firebase_database/firebase_database.dart';

class User {
  String key;
  String email;
  String fullName;
  String userId;
  String profilePictureUrl;
  List<String> activeSessions;

  User(this.userId, this.email, this.fullName);

  @override
  String toString() {
    return 'User{email: $email, fullName: $fullName, userId: $userId, profilePictureUrl: $profilePictureUrl, activeSessions: $activeSessions}';
  }
  toJson() {
    return {
      "email": userId,
      "fullName": fullName,
      "userId": userId,
      "profilePictureUrl": profilePictureUrl,
      "activeSessions": activeSessions
    };
  }

  User.fromSnapshot(DataSnapshot snapshot) :
        key = snapshot.key,
        userId = snapshot.value["userId"],
        email = snapshot.value["email"],
        fullName = snapshot.value["fullName"],
        profilePictureUrl = snapshot.value["profilePictureUrl"],
        activeSessions = snapshot.value["activeSessions"];

}