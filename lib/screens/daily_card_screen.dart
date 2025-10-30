import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../models/hero_model.dart';
import '../services/api_service.dart';
import '../services/database_helper.dart';
import '../widgets/super_trump_card.dart';

class DailyCardScreen extends StatefulWidget {
  const DailyCardScreen({super.key});

  @override
  State<DailyCardScreen> createState() => _DailyCardScreenState();
}

class _DailyCardScreenState extends State<DailyCardScreen> {
  static const String _lastDrawDateKey = 'lastDrawDate';
  static const String _dailyHeroIdKey = 'dailyHeroId';

  Future<HeroModel?>? _dailyHeroFuture;
  bool _canObtain = false;
  bool _isObtained = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _dailyHeroFuture = _checkAndGetDailyHero();
  }

  String _getTodayString() {
    return DateTime.now().toIso8601String().split('T').first;
  }

  Future<HeroModel?> _checkAndGetDailyHero() async {
    final prefs = await SharedPreferences.getInstance();
    final dbHelper = DatabaseHelper.instance;
    final db = await dbHelper.database;
    final api = Provider.of<ApiService>(context, listen: false);

    final String today = _getTodayString();
    final String? lastDrawDate = prefs.getString(_lastDrawDateKey);
    final int? dailyHeroId = prefs.getInt(_dailyHeroIdKey);

    HeroModel? hero;

    int heroCount = await dbHelper.getHeroCount();
    if (heroCount == 0) {
      await api.fetchAndCacheHeroes();
    }

    if (lastDrawDate == today && dailyHeroId != null) {
      var res = await db.query(DatabaseHelper.tableHeroes,
          where: 'id = ?', whereArgs: [dailyHeroId]);
      if (res.isNotEmpty) {
        hero = HeroModel.fromMap(res.first);
      }
    } else {
      hero = await dbHelper.getRandomHero();
      if (hero != null) {
        await prefs.setString(_lastDrawDateKey, today);
        await prefs.setInt(_dailyHeroIdKey, hero.id);
      }
    }

    if (hero != null) {
      await _checkButtonState(hero.id);
    }
    return hero;
  }

  Future<void> _checkButtonState(int heroId) async {
    final dbHelper = DatabaseHelper.instance;
    int myCardsCount = await dbHelper.getMyCardsCount();
    bool alreadyInCollection = await dbHelper.isHeroInMyCards(heroId);

    setState(() {
      _isObtained = alreadyInCollection;

      if (myCardsCount >= 15 && !alreadyInCollection) {
        _canObtain = false;
        _errorMessage = "Você já atingiu o limite de 15 cartas!";
      } else {
        _canObtain = !alreadyInCollection;
        _errorMessage = '';
      }
    });
  }

  Future<void> _obtainCard(HeroModel hero) async {
    final dbHelper = DatabaseHelper.instance;
    await dbHelper.addHeroToMyCards(hero.id);

    setState(() {
      _isObtained = true;
      _canObtain = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${hero.name} foi adicionado à sua coleção!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Card Diário'),
      ),
      body: Center(
        child: FutureBuilder<HeroModel?>(
          future: _dailyHeroFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator.adaptive();
            }

            if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
              return const Text(
                'Não foi possível sortear um herói. Tente novamente.',
                textAlign: TextAlign.center,
              );
            }

            final hero = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SuperTrumpCard(hero: hero),

                  const SizedBox(height: 24),

                  _buildButtonOrMessage(hero),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildButtonOrMessage(HeroModel hero) {
    if (_errorMessage.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Text(
          _errorMessage,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.redAccent,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    if (_isObtained) {
      return ElevatedButton.icon(
        icon: const Icon(Icons.check_circle),
        label: const Text('Obtido'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey[700],
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
          textStyle: const TextStyle(fontSize: 18),
        ),
        onPressed: null,
      );
    }

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      onPressed: _canObtain ? () => _obtainCard(hero) : null,
      child: const Text('Obter'),
    );
  }
}

