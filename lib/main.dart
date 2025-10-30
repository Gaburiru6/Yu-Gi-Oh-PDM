import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/api_service.dart';
import 'screens/home_screen.dart';
import 'screens/heroes_list_screen.dart';
import 'screens/daily_card_screen.dart';
import 'screens/my_cards_screen.dart';
import 'screens/my_card_detail_screen.dart';
import 'screens/battle_screen.dart';

void main() {
  runApp(
    Provider<ApiService>(
      create: (context) => ApiService(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yu-Gi-Oh',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[900],
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey[850],
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue[600],
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        cardTheme: CardThemeData(
          color: Colors.grey[800],
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/heroes': (context) => const HeroesListScreen(),
        '/daily-card': (context) => const DailyCardScreen(),
        '/my-cards': (context) => const MyCardsScreen(),
        '/my-card-detail': (context) => const MyCardDetailScreen(),
        '/battle': (context) => const BattleScreen(),
      },
    );
  }
}

