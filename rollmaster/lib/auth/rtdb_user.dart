import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:rollmaster/model/user.dart';

String RTDB_REFERENCE = "https://rollmaster-rm23.firebaseio.com/";
final usersDbRef = FirebaseDatabase.instance.reference().child("users");

User saveUser(FirebaseUser loggedUser) {
  User user = User.fromFirebase(loggedUser);
  usersDbRef.child(loggedUser.uid).set(user.toJson());
  return user;
}

User checkPersistedUser(String value) {
  User currentUser;
  FirebaseAuth.instance.currentUser().then((user) => {
        usersDbRef.child(user.uid).once().then((DataSnapshot snapshot) => {
              currentUser = snapshot.value != null
                  ? User.fromSnapshot(snapshot)
                  : saveUser(user)
            })
      });
  return currentUser;
}
