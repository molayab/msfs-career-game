
class User {
  final int? id;
  final String name;
  final String location;
  final int rank;

  User({
    required this.id,
    required this.name,
    required this.location,
    required this.rank,
  });

  User.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'],
        location = map['location'],
        rank = map['rank'];

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'rank': rank,
    };
  }
}