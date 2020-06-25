import 'package:firebase_database/firebase_database.dart';

class Roll {
  String key;
  String command;
  String playerId;
  String sessionId;
  String playerName;
  double probability;
  double probabilityAtLeast;
  String result;
  DateTime timestamp;
  String type;

  Roll(this.command, this.playerId, this.sessionId, this.type);

  @override
  String toString() {
    return 'Roll{key: $key, command: $command, playerId: $playerId, sessionId: '
        '$sessionId, playerName: $playerName, probability: $probability, '
        'probabilityAtLeast: $probabilityAtLeast, result: $result, timestamp: '
        '$timestamp, type: $type}';
  }

  toJson() {
    return {
      "command": command,
      "playerId": playerId,
      "sessionId": sessionId,
      "playerName": playerName,
      "probability": probability,
      "probabilityAtLeast" : probabilityAtLeast,
      "result": result,
      "timestamp": timestamp,
      "type": type
    };
  }

  Roll.fromSnapshot(DataSnapshot snapshot) :
        key = snapshot.key,
        command = snapshot.value["command"],
        playerId = snapshot.value["playerId"],
        sessionId = snapshot.value["sessionId"],
        playerName = snapshot.value["playerName"],
        probability = snapshot.value["probability"],
        probabilityAtLeast = snapshot.value["probabilityAtLeast"],
        result = snapshot.value["result"],
        timestamp = snapshot.value["timestamp"],
        type = snapshot.value["type"];
  }