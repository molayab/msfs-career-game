
import 'dart:math';

import 'package:testai/models/airport.dart';
import 'package:testai/services/sql_service.dart';

import '../models/rect.dart';

class AirportsService {
  final database = SqlService();

  Future<List<Airport>> all() async {
    final db = await database.connect();
    final List<Map<String, dynamic>> maps = await db.query('airports');

    return maps.map((e) => Airport.fromMap(e)).toList();
  }

  Future<Airport> get(String icao) async {
    final db = await database.connect();
    final List<Map<String, dynamic>> maps = await db.query('airports', where: 'icao = ?', whereArgs: [icao]);

    return Airport.fromMap(maps.first);
  }

  Future<List<Airport>> allInRectAndRoute(Rect rect, double meters, Point center, String icao) async {
    final db = await database.connect();
    final List<Map<String, dynamic>> maps = await db.query(
      'airports', 
      where: 'lat > ? AND lat < ? AND lon > ? AND lon < ?', 
      whereArgs: [rect.south.x, rect.north.x, rect.west.y, rect.east.y]);
    final routes = await getRoutesFrom(icao);

    var list = maps.map((e) => Airport.fromMap(e)).toList().map((i) {
      var point = Point(i.latitude, i.longitude);
      if (_pointIsInCircle(center, meters, point) && icao != i.code) {
        return i;
      }
    });

    // concatenate routes and random airports
    var missionList = list.whereType<Airport>().toList();
    missionList.shuffle();
    missionList = missionList.take(100).toList() + routes;
    return missionList;
  }

  Future<List<Airport>> getRoutesFrom(String icao) async {
    final db = await database.connect();
    final current = await get(icao);

    final List<Map<String, dynamic>> maps = await db.rawQuery("""
      SELECT AA.* FROM airports AS AA 
	      INNER JOIN (SELECT R.dst, R.equipment, R.dst_id FROM airports AS A 
		      INNER JOIN routes AS R ON A.id = R.src_id WHERE R.src_id = ? 
	      ) AS H ON H.dst_id = AA.id; 
    """, [current.id]);

    return maps.map((e) => Airport.fromMap(e)).toList();
  }

  bool _pointIsInCircle(Point center, double radius, Point point) {
    return _getDistanceBetweenTwoPoints(center, point) < radius;
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