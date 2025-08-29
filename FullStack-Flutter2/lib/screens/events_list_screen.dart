import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/events_provider.dart';
import '../widgets/event_card.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_widget.dart' as custom_widgets;
import '../widgets/empty_state_widget.dart';
import 'event_detail_screen.dart';

class EventsListScreen extends StatefulWidget {
  const EventsListScreen({super.key});

  @override
  State<EventsListScreen> createState() => _EventsListScreenState();
}

class _EventsListScreenState extends State<EventsListScreen> {
  final ScrollController _scrollController = ScrollController();
  DateTime? _selectedFromDate;
  DateTime? _selectedToDate;

  @override
  void initState() {
    super.initState();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EventsProvider>().loadEvents(refresh: true);
    });
    
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= 
        _scrollController.position.maxScrollExtent - 200) {
      context.read<EventsProvider>().loadNextPage();
    }
  }

  Future<void> _onRefresh() async {
    await context.read<EventsProvider>().refreshEvents();
  }

  void _showDateFilter() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _DateFilterBottomSheet(
        initialFromDate: _selectedFromDate,
        initialToDate: _selectedToDate,
        onApplyFilter: _applyDateFilter,
        onClearFilter: _clearDateFilter,
      ),
    );
  }

  void _applyDateFilter(DateTime? fromDate, DateTime? toDate) {
    setState(() {
      _selectedFromDate = fromDate;
      _selectedToDate = toDate;
    });
    context.read<EventsProvider>().applyDateFilter(
      fromDate: fromDate,
      toDate: toDate,
    );
  }

  void _clearDateFilter() {
    setState(() {
      _selectedFromDate = null;
      _selectedToDate = null;
    });
    context.read<EventsProvider>().clearDateFilter();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Events',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
           SizedBox(
    width: 200,
  ),
          IconButton(
            onPressed: _showDateFilter,
            icon: Icon(
              context.watch<EventsProvider>().hasActiveFilters
                  ? Icons.filter_alt
                  : Icons.filter_alt_outlined,
            ),
            tooltip: 'Filtrar por fecha',
          ),
        ],
      ),
      body: Consumer<EventsProvider>(
        builder: (context, eventsProvider, child) {
          if (eventsProvider.loadingState == EventsLoadingState.loading && 
              eventsProvider.events.isEmpty) {
            return const LoadingWidget(message: 'Cargando eventos...');
          }

          if (eventsProvider.hasError && eventsProvider.events.isEmpty) {
            return custom_widgets.ErrorWidget(
              message: eventsProvider.errorMessage ?? 'Error desconocido',
              onRetry: () => eventsProvider.loadEvents(refresh: true),
            );
          }

          if (eventsProvider.events.isEmpty) {
            return const EmptyStateWidget(
              title: 'No hay eventos',
              message: 'No se encontraron eventos que coincidan con los filtros aplicados.',
              icon: Icons.event_busy,
            );
          }

          return RefreshIndicator(
            onRefresh: _onRefresh,
            child: Column(
              children: [
                // Filter indicator
                if (eventsProvider.hasActiveFilters)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    child: Row(
                      children: [
                        Icon(
                          Icons.filter_alt,
                          size: 16,
                          color: Theme.of(context).primaryColor,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Filtros aplicados',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: _clearDateFilter,
                          child: const Text('Limpiar'),
                        ),
                      ],
                    ),
                  ),
                
                // Events list
                Expanded(
  child: Column(
    children: [
      Expanded(
        child: ListView.builder(
          padding: const EdgeInsets.only(top: 8, bottom: 8),
          itemCount: eventsProvider.events.length,
          itemBuilder: (context, index) {
            final event = eventsProvider.events[index];
            return EventCard(
              event: event,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EventDetailScreen(
                      eventId: event.id,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),

      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: eventsProvider.previousPage != ""
                ? () => eventsProvider.loadEventsPage(url: eventsProvider.previousPage!)
                : null,
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: eventsProvider.nextPage != ""
                ? () => eventsProvider.loadEventsPage(url: eventsProvider.nextPage)
                : null,
          ),
        ],
      ),
    ],
  ),
)
              ],
            ),
          );
        },
      ),
    );
  }
}

class _DateFilterBottomSheet extends StatefulWidget {
  final DateTime? initialFromDate;
  final DateTime? initialToDate;
  final Function(DateTime?, DateTime?) onApplyFilter;
  final VoidCallback onClearFilter;

  const _DateFilterBottomSheet({
    this.initialFromDate,
    this.initialToDate,
    required this.onApplyFilter,
    required this.onClearFilter,
  });

  @override
  State<_DateFilterBottomSheet> createState() => _DateFilterBottomSheetState();
}

class _DateFilterBottomSheetState extends State<_DateFilterBottomSheet> {
  DateTime? _fromDate;
  DateTime? _toDate;

  @override
  void initState() {
    super.initState();
    _fromDate = widget.initialFromDate;
    _toDate = widget.initialToDate;
  }

  Future<void> _selectFromDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _fromDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _fromDate = picked;
        if (_toDate != null && _toDate!.isBefore(picked)) {
          _toDate = null;
        }
      });
    }
  }

  Future<void> _selectToDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _toDate ?? _fromDate ?? DateTime.now(),
      firstDate: _fromDate ?? DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _toDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Filtrar por fecha',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          
          // From date
          ListTile(
            leading: const Icon(Icons.calendar_today),
            title: const Text('Fecha desde'),
            subtitle: Text(_fromDate?.toString().split(' ')[0] ?? 'Seleccionar'),
            onTap: _selectFromDate,
            trailing: _fromDate != null
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () => setState(() => _fromDate = null),
                  )
                : null,
          ),
          
          // To date
          ListTile(
            leading: const Icon(Icons.calendar_today),
            title: const Text('Fecha hasta'),
            subtitle: Text(_toDate?.toString().split(' ')[0] ?? 'Seleccionar'),
            onTap: _selectToDate,
            trailing: _toDate != null
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () => setState(() => _toDate = null),
                  )
                : null,
          ),
          
          const SizedBox(height: 24),
          
          // Action buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    widget.onClearFilter();
                    Navigator.pop(context);
                  },
                  child: const Text('Limpiar'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    widget.onApplyFilter(_fromDate, _toDate);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Aplicar'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
