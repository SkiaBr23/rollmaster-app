import 'package:firebase_database/firebase_database.dart';

class Session {
  String key;
  String creatorId;
  String title;
  String code;
  DateTime creationDate;
  // String qrCodePictureUrl?
  List<String> activePlayers;

  Session(this.key, this.creatorId, this.title, this.creationDate);

  Session.start(String key, String creatorId, String title){
    this.key = key;
    this.creatorId = creatorId;
    this.title = title;
    this.creationDate = DateTime.now();
    this.activePlayers = [creatorId];
  }

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
      "creationDate": creationDate.toIso8601String()
    };
  }

  Session.fromSnapshot(DataSnapshot snapshot) :
        key = snapshot.key,
        creatorId = snapshot.value["creatorId"],
        title = snapshot.value["title"],
        code = snapshot.value["code"],
        creationDate = DateTime.parse(snapshot.value["creationDate"]);

  Session.fromMap(Map<dynamic,dynamic> map) :
        key = map["key"],
        creatorId = map["creatorId"],
        title = map["title"],
        code = map["code"],
        creationDate = DateTime.parse(map["creationDate"]);
}

