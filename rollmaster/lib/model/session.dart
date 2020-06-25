import 'package:firebase_database/firebase_database.dart';

class Session {
  String key;
  String creatorId;
  String title;
  String code;
  String creationDate;
  // String qrCodePictureUrl?
  // List<String> playerIdList?

  Session(this.creatorId, this.title, this.creationDate);

  @override
  String toString() {
    return 'Session{key: $key, creatorId: $creatorId, title: $title, code: $code, creationDate: $creationDate}';
  }

  toJson() {
    return {
      "key": key,
      "creatorId": creatorId,
      "title": title,
      "code": code,
      "creationDate": creationDate
    };
  }

  Session.fromSnapshot(DataSnapshot snapshot) :
        key = snapshot.key,
        creatorId = snapshot.value["creatorId"],
        title = snapshot.value["title"],
        code = snapshot.value["code"],
        creationDate = snapshot.value["creationDate"];
}