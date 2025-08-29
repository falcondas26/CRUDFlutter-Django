class Location {
  final double lat;
  final double lng;
  final String address;

  Location({
    required this.lat,
    required this.lng,
    required this.address,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      lat: double.tryParse(json['lat'] ?? '') ?? 0.0,
      lng: double.tryParse(json['lng'] ?? '') ?? 0.0,
      address: json['address'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lat': lat,
      'lng': lng,
      'address': address,
    };
  }
}
