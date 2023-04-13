
import 'dart:ffi';

class Airport {
  final int id;
  final String name;
  final String code;
  final String? city;
  final String country;
  final int altitude;
  final double latitude;
  final double longitude;

  Airport({
    required this.id,
    required this.name,
    required this.code,
    required this.city,
    required this.country,
    required this.altitude,
    required this.latitude,
    required this.longitude,
  });

  Airport.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'],
        code = map['icao'],
        city = map['city'],
        country = map['country'],
        altitude = map['alt'],
        latitude = map['lat'],
        longitude = map['lon'];
  
  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'icao': code,
      'city': city,
      'country': country,
      'alt': altitude,
      'lat': latitude,
      'lon': longitude,
    };
  }
}