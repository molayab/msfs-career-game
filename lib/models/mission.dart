
import 'dart:math';

enum MissionType {
  passenger,
  cargo
}

class Mission {
  final int fromAirportId;
  final int toAirportId;
  final int passengers;
  final int cargo;
  final String destination;
  final double fee;
  final double distance;
  
  late MissionType type = _randomizeMissionType();
  late double reward = generateReward();

  Mission({
    required this.fromAirportId,
    required this.toAirportId,
    required this.passengers,
    required this.cargo,
    required this.destination,
    required this.fee,
    required this.distance,
  });

  MissionType _randomizeMissionType() {
    final random = Random();
    final randomNumber = random.nextInt(MissionType.values.length);
    return MissionType.values[randomNumber];
  }

  double generateReward() {
    // Randomize between $3 and $15 per mile
    final averageRandomCostPerMile = Random().nextInt(12) + 3;
    return (distance * averageRandomCostPerMile) + ((passengers - 1) * 25);
  }
}