
import 'package:testai/models/airport.dart';
import 'package:testai/services/airports_service.dart';
import 'dart:math';

import '../helpers/coords_helper.dart';
import '../models/mission.dart';

// $4 per gas galon.

// Avioneta tiene en promedio de 30 a 80 Gal
// Consume en promedio 6 a 10 Gal por hora.
//

class MissionService {
  final airportService = AirportsService();

  Future<List<Airport>> getRoutesFrom(String icao) async {
    return await airportService.getRoutesFrom(icao);
  }

  Future<List<Mission>> generateOnLocation(String icao, double nm) async {
    final meters = nm * 1852;
    // Serch for airports in 100km radius
    final currentPosition = await airportService.get(icao);
    final point = Point(currentPosition.latitude, currentPosition.longitude);
    
    final sercheanbleArea = CoordsHelper.createSerchableArea(point, meters);
    final a = await airportService.allInRectAndRoute(sercheanbleArea, meters, point, icao);

    a.sort((a, b) => _getDistanceBetweenTwoPoints(point, Point(a.latitude, a.longitude))
        .compareTo(_getDistanceBetweenTwoPoints(point, Point(b.latitude, b.longitude))));

    final randomNumberOfPassengers = Random().nextInt(100);
    final randomWeight = Random().nextInt(100);
    final randomAirportFee = Random().nextInt(100);

    return a.map((e) => Mission(
      fromAirportId: currentPosition.id,
      toAirportId: e.id,
      passengers: randomNumberOfPassengers,
      cargo: randomWeight,
      destination: e.code,
      fee: randomAirportFee.toDouble(),
      distance: _getDistanceBetweenTwoPoints(point, Point(e.latitude, e.longitude)) / 1852,
    )).toList();
  }

  double _getDistanceBetweenTwoPoints(Point p1, Point p2) {
    const radius = 6371000;
    final lat1 = p1.x * (pi / 180);
    final lat2 = p2.x * (pi / 180);
    final lon1 = p1.y * (pi / 180);
    final lon2 = p2.y * (pi / 180);

    final dLat = lat2 - lat1;
    final dLon = lon2 - lon1;

    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1) * cos(lat2) * sin(dLon / 2) * sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return radius * c;
  }
}

