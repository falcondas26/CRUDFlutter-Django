import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/events_provider.dart';
import 'screens/events_list_screen.dart';

void main() {
  runApp(const EventsApp());
}

class EventsApp extends StatelessWidget {
  const EventsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => EventsProvider()),
      ],
      child: MaterialApp(
        title: 'Events App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          primaryColor: const Color(0xFF2196F3),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF2196F3),
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF2196F3),
          ),
          useMaterial3: true,
          cardTheme: const CardThemeData(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2196F3),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        home: const EventsListScreen(),
      ),
    );
  }
}
