
class Route {
  final String airline;
  final String src;
  final String dst;
  final String srcId;
  final String dstId;
  final String equipment;

  Route({
    required this.airline,
    required this.src,
    required this.dst,
    required this.srcId,
    required this.dstId,
    required this.equipment,
  });

  Route.fromMap(Map<String, dynamic> map)
      : airline = map['airline'],
        src = map['src'],
        dst = map['dst'],
        srcId = map['src_id'],
        dstId = map['dst_id'],
        equipment = map['equipment'];

  Map<String, Object?> toMap() {
    return {
      'airline': airline,
      'src': src,
      'dst': dst,
      'src_id': srcId,
      'dst_id': dstId,
      'equipment': equipment,
    };
  }
}