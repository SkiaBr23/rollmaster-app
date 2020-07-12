import 'package:firebase_database/firebase_database.dart';
import 'package:rollmaster/model/roll_check.dart';
import 'package:rollmaster/util/dice_roller.dart';

class Roll {
  String key;
  String command;
  String playerId;
  String sessionId;
  String playerName;
  double probability;
  double probabilityAtLeast;
  int result;
  RollCheck rollCheck;
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
      "probabilityAtLeast": probabilityAtLeast,
      "result": result,
      "timestamp": timestamp.toIso8601String(),
      "type": type
    };
  }

  Roll.newRoll(String key, RollCheck rollCheck, String type, String userId,
      String userName, String sessionId)
      : key = key,
        command = rollCheckToCommand(rollCheck),
        playerId = userId,
        playerName = userName,
        sessionId = sessionId,
        rollCheck = rollCheck,
        result = rollDice(rollCheck, type),
        timestamp = DateTime.now(),
        type = type;

  Roll.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        command = snapshot.value["command"],
        playerId = snapshot.value["playerId"],
        sessionId = snapshot.value["sessionId"],
        playerName = snapshot.value["playerName"],
        probability = snapshot.value["probability"] + .0,
        probabilityAtLeast = snapshot.value["probabilityAtLeast"] + .0,
        result = snapshot.value["result"],
        timestamp = DateTime.parse(snapshot.value["timestamp"]),
        type = snapshot.value["type"];

  static int rollDice(RollCheck rollCheck, String type) {
    return DiceRoller.roll(
        faces: rollCheck.faces,
        dices: rollCheck.dices,
        modifier: rollCheck.modifier);
  }

  void evalProbabilities() {
    this.probability = DiceRoller.probability(
        this.result, this.rollCheck.faces, this.rollCheck.dices);
    this.probabilityAtLeast = DiceRoller.probability(
        this.result, this.rollCheck.faces, this.rollCheck.dices);
  }

  static String rollCheckToCommand(RollCheck roll) {
    if (roll.modifier > 0)
      return roll.dices.toString() +
          "d" +
          roll.faces.toString() +
          " + " +
          roll.modifier.toString();
    if (roll.modifier == 0)
      return roll.dices.toString() + "d" + roll.faces.toString();
    if (roll.modifier < 0)
      return roll.dices.toString() +
          "d" +
          roll.faces.toString() +
          " - " +
          (roll.modifier * -1).toString();
    return "";
  }
}
