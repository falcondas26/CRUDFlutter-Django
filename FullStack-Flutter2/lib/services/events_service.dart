import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import '../models/event.dart';
import '../models/events_response.dart';
import '../models/pagination_info.dart';

class EventsService {
  static const String _mockDataPath = 'assets/data/events_mock.json';
  
  static const String baseUrl = 'http://localhost:8000/api'; 
  
  Future<Event?> getEventById(int id) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      
      final String jsonString = await rootBundle.loadString(_mockDataPath);
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      
      final EventsResponse response = EventsResponse.fromJson(jsonData);
      
      try {
        return response.events.firstWhere((event) => event.id == id);
      } catch (e) {
        return null; 
      }
    } catch (e) {
      throw Exception('Error loading event: $e');
    }
  }
  
  
  Future<EventsResponse> getEventsFromAPI({
    DateTime? fromDate,
    DateTime? toDate,
  }) async {

    final Map<String, String> queryParams = {
      'size': "5",
    };

     if (fromDate != null) {
      queryParams['from_date'] = fromDate.toIso8601String().split('T')[0];
    }
    if (toDate != null) {
      queryParams['to_date'] = toDate.toIso8601String().split('T')[0];
    }
    
    final uri = Uri.parse('$baseUrl/Event').replace(queryParameters: queryParams);
    final response = await http.get(uri);
    
    // final uri = Uri.parse('$baseUrl/Event');
    // final response = await http.get(uri);
    
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return EventsResponse.fromJson(jsonData);
    } else {
      throw Exception('Failed to load events: ${response.statusCode}');
    }
  }
  
  Future<Event?> getEventByIdFromAPI(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/Event/$id'));
    
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return Event.fromJson(jsonData);
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception('Failed to load event: ${response.statusCode}');
    }
  }
 
}

extension PaginationInfoExtension on PaginationInfo {
  PaginationInfo copyWith({
    int? count,
    String next = "",
    String previous = "",
    int? totalPages,
  }) {
    return PaginationInfo(
      count: count ?? this.count,
      next: next,
      previous: previous,
    );
  }
}
