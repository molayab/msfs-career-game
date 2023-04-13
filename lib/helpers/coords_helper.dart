
import 'dart:math';

import '../models/rect.dart';

class CoordsHelper {
  static Point calculateDerivedPosition(Point src, double range, double bearing) {
    const radius = 6371000;
    final angularDistance = range / radius;
    final latitude = src.x * (pi / 180);
    final longitude = src.y * (pi / 180);
    final bearingRad = bearing * (pi / 180);

    final destLatitude = asin(sin(latitude) * cos(angularDistance) +
        cos(latitude) * sin(angularDistance) * cos(bearingRad));

    final destLongitude = longitude +
        atan2(sin(bearingRad) * sin(angularDistance) * cos(latitude),
            cos(angularDistance) - sin(latitude) * sin(destLatitude));

    return Point(destLatitude * (180 / pi), destLongitude * (180 / pi));
  }

  static Rect createSerchableArea(Point initialPoint, double radius) {
    const mult = 1.1;

    final north = calculateDerivedPosition(initialPoint, mult * radius, 0);
    final south = calculateDerivedPosition(initialPoint, mult * radius, 180);
    final east = calculateDerivedPosition(initialPoint, mult * radius, 90);
    final west = calculateDerivedPosition(initialPoint, mult * radius, 270);

    return Rect(north, south, east, west);
  }
}