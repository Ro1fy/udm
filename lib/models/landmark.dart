class Landmark {
  final String id;
  final String name;
  final String nameUdmurt;
  final String description;
  final double latitude;
  final double longitude;
  final String category;
  final String emoji;
  final String location;
  final double radius;

  const Landmark({
    required this.id,
    required this.name,
    required this.nameUdmurt,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.category,
    required this.emoji,
    required this.location,
    this.radius = 500,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'nameUdmurt': nameUdmurt,
        'description': description,
        'latitude': latitude,
        'longitude': longitude,
        'category': category,
        'emoji': emoji,
        'location': location,
        'radius': radius,
      };

  factory Landmark.fromJson(Map<String, dynamic> json) => Landmark(
        id: json['id'] as String,
        name: json['name'] as String,
        nameUdmurt: json['nameUdmurt'] as String,
        description: json['description'] as String,
        latitude: json['latitude'] as double,
        longitude: json['longitude'] as double,
        category: json['category'] as String,
        emoji: json['emoji'] as String,
        location: json['location'] as String,
        radius: (json['radius'] as num?)?.toDouble() ?? 500,
      );
}
