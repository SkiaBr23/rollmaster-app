import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:rollmaster/model/session.dart';
import 'package:rollmaster/model/user.dart';

String RTDB_REFERENCE = "https://rollmaster-rm23.firebaseio.com/";
final fbDbRef = FirebaseDatabase.instance.reference();
final usersDbRef = fbDbRef.child("users");
final sessionDbRef = fbDbRef.child("sessions");

String getKeyFromRef(DatabaseReference dbRef) {
  return dbRef.push().key;
}

User saveUser(FirebaseUser loggedUser) {
  User user = User.fromFirebase(loggedUser);
  usersDbRef.child(loggedUser.uid).set(user.toJson());
  return user;
}

Future<Session> getSessionById(String sessionId) async {
  Session session;
  await sessionDbRef.child(sessionId).once().then((snapshot) => {
        if (snapshot != null) {session = Session.fromSnapshot(snapshot.value)}
      });
  return session;
}

Future<List<Session>> getSessionsByOwner(User owner) async {
  Map<dynamic, dynamic> values;
  List<Session> sessions = [];
  await sessionDbRef
      .orderByChild("creatorId")
      .equalTo(owner.userId)
      .once()
      .then((snapshot) => {
            if (snapshot != null)
              {
                Map<String, dynamic>.from(snapshot.value).forEach((key, value) {
                  sessions.add(Session.fromMap(value));
                })

              }
          });
  return sessions;
}

Future<List<Session>> getActiveSessionsByUser2(User user) async {
  print("Test getActiveSessionsByUser");
  List<Session> listaSessions = [];
  List<dynamic> list = await usersDbRef
      .child(user.userId)
      .child("activeSessions")
      .once()
      .asStream()
      .map((event) => event.value)
      .toList();

  list.forEach((snapshot) async {
    await snapshot.forEach((key, value) async {
      DataSnapshot snapshotSession = await sessionDbRef.child(value).once();
      if (snapshotSession != null) {
        listaSessions.add(Session.fromSnapshot(snapshotSession));
      }
    });
  });
  return listaSessions;
}

Future<List<Session>> getSessionsByIdList(List<String> idList) async {
  List<Session> listaSessions = [];
  idList.forEach((sessionId) async {
    listaSessions.add(await getSessionById(sessionId));
  });
  Future.delayed(Duration(seconds: 5));
  return listaSessions;
}

Future<List<Session>> getActiveSessionsByUser(User user) async {
  print("Test getActiveSessionsByUser");
  return getSessionsByIdList(user.activeSessions);
}

Future<Session> createSession(User owner) async {
  String sessionKey = getKeyFromRef(sessionDbRef);
  Session newSession =
      Session.start(sessionKey, owner.userId, (owner.fullName + "'s room"));
  await sessionDbRef.child(sessionKey).set(newSession.toJson());
  await usersDbRef
      .child(owner.userId)
      .child("activeSessions")
      .push()
      .set(sessionKey);
  return newSession;
}

Future<User> checkPersistedUser() async {
  User currentUser;
  FirebaseAuth.instance.currentUser().then((user) => {
        usersDbRef.child(user.uid).once().then((DataSnapshot snapshot) => {
              currentUser = snapshot.value != null
                  ? User.fromSnapshot(snapshot)
                  : saveUser(user)
            })
      });
  return Future.value(currentUser);
}
