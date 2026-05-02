class CafeModel {
  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final double rating;
  double? distance; 

  CafeModel({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.rating,
    this.distance,
  });

  factory CafeModel.fromMap(String id, Map<String, dynamic> map) {
    return CafeModel(
      id: id,
      name: map['name'] ?? '',
      address: map['address'] ?? '',
      latitude: (map['latitude'] ?? 0).toDouble(),
      longitude: (map['longitude'] ?? 0).toDouble(),
      rating: (map['rating'] ?? 0).toDouble(),
    );
  }
}