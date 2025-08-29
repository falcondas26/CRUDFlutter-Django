import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/event.dart';
import '../models/events_response.dart';
import '../services/events_service.dart';

enum EventsLoadingState { initial, loading, loaded, error }

class EventsProvider extends ChangeNotifier {
  final EventsService _eventsService = EventsService();
  
  // State variables
  List<Event> _events = [];
  EventsLoadingState _loadingState = EventsLoadingState.initial;
  String? _errorMessage;
  int _currentPage = 1;
  static const int _pageSize = 5;
  bool _hasMoreEvents = true;
  
  // Date filters
  DateTime? _fromDate;
  DateTime? _toDate;
  
  // Getters
  List<Event> get events => _events;
  EventsLoadingState get loadingState => _loadingState;
  String? get errorMessage => _errorMessage;
  int get currentPage => _currentPage;
  int get pageSize => _pageSize;
  bool get hasMoreEvents => _hasMoreEvents;
  DateTime? get fromDate => _fromDate;
  DateTime? get toDate => _toDate;
  
  bool get isLoading => _loadingState == EventsLoadingState.loading;
  bool get hasError => _loadingState == EventsLoadingState.error;
  bool get isLoaded => _loadingState == EventsLoadingState.loaded;


 String nextPage = "";
 String previousPage = "";
  int totalEvents = 0;

  Future<void> loadEventsPage({String url = ""}) async {
    final response = await http.get(
      Uri.parse(url),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      _events = (data['events'] as List)
          .map((e) => Event.fromJson(e))
          .toList();

      nextPage = data['pagination']['next'] ?? "";
      previousPage = data['pagination']['previous'] ?? "";
      totalEvents = data['pagination']['count'];

      notifyListeners();
    }
  }
  
  Future<void> loadEvents({
    bool refresh = false,
    DateTime? fromDate,
    DateTime? toDate,
    String nextPageUrl = "",
    String previousPageUrl = "",
  }) async {
    if (refresh) {
      _currentPage = 1;
      _events.clear();
      _hasMoreEvents = true;
    }
    
    if (!_hasMoreEvents && !refresh) return;
    
    _loadingState = EventsLoadingState.loading;
    _errorMessage = null;
    notifyListeners();
    
    try {
      final EventsResponse response = await _eventsService.getEventsFromAPI(
        fromDate: fromDate ?? _fromDate,
        toDate: toDate ?? _toDate,
      );

      if (fromDate != null) _fromDate = fromDate;
      if (toDate != null) _toDate = toDate;
      if (response.pagination.next.isNotEmpty) {
        nextPage = response.pagination.next;
      }
      if (response.pagination.previous.isNotEmpty) {
        previousPage = response.pagination.previous;
      }
      
      if (refresh) {
        _events = response.events;
      } else {
        _events.addAll(response.events);
      }

    
      
      _loadingState = EventsLoadingState.loaded;
      
     
      
    } catch (e) {
      _loadingState = EventsLoadingState.error;
      _errorMessage = "";
    }
    
    notifyListeners();
  }
  
  Future<void> loadNextPage() async {
    if (!_hasMoreEvents || isLoading) return;
    
    _currentPage++;
    await loadEvents();
  }
  
  Future<void> refreshEvents() async {
    await loadEvents(refresh: true);
  }
  
  Future<void> applyDateFilter({DateTime? fromDate, DateTime? toDate}) async {
    _fromDate = fromDate;
    _toDate = toDate;
    await loadEvents(refresh: true, fromDate: fromDate, toDate: toDate);
  }
  
  Future<void> clearDateFilter() async {
    _fromDate = null;
    _toDate = null;
    await loadEvents(refresh: true);
  }
  
  Future<Event?> getEventById(int id) async {
    try {
      for (final event in _events) {
        if (event.id == id) return event;
      }
      
      return await _eventsService.getEventById(id);
    } catch (e) {
      debugPrint('Error getting event by ID: $e');
      return null;
    }
  }
  
  /// Check if filters are active
  bool get hasActiveFilters => _fromDate != null || _toDate != null;
}
