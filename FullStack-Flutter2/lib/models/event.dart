import 'location.dart';

class Event {
  final int id;
  final String title;
  final String description;
  final DateTime date;
  final Location location;


  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.location,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'] ?? 0,
      title: json['titulo'] ?? '',
      description: json['descripcion'] ?? '',
      date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
      location: Location.fromJson(json['location'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'location': location.toJson(),
    };
  }
}
