import 'event.dart';
import 'pagination_info.dart';

class EventsResponse {
  final List<Event> events;
  final PaginationInfo pagination;

  EventsResponse({
    required this.events,
    required this.pagination,
  });

  factory EventsResponse.fromJson(Map<String, dynamic> json) {
    return EventsResponse(
      events: (json['events'] as List<dynamic>?)
          ?.map((eventJson) => Event.fromJson(eventJson))
          .toList() ?? [],
      pagination: PaginationInfo.fromJson(json['pagination'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'events': events.map((event) => event.toJson()).toList(),
      'pagination': pagination.toJson(),
    };
  }
}
