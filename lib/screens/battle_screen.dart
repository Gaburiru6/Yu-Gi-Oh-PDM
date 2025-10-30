import 'package:flutter/material.dart';
import '../services/database_helper.dart';
import '../models/hero_model.dart';
import '../widgets/super_trump_card.dart';
import 'dart:math';

class BattleScreen extends StatefulWidget {
  const BattleScreen({super.key});

  @override
  State<BattleScreen> createState() => _BattleScreenState();
}

class _BattleScreenState extends State<BattleScreen> {
  late Future<List<HeroModel>> _cardsFuture;
  List<HeroModel> _shuffledCards = [];
  int _currentIndex = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAndShuffleCards();
  }

  Future<void> _loadAndShuffleCards() async {
    final db = DatabaseHelper.instance;
    List<HeroModel> myCards = await db.getMyCards();

    myCards.shuffle(Random());

    setState(() {
      _shuffledCards = myCards;
      _isLoading = false;
    });
  }

  void _nextCard() {
    if (_currentIndex < _shuffledCards.length - 1) {
      setState(() {
        _currentIndex++;
      });
    } else {
      setState(() {
        _currentIndex = _shuffledCards.length;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modo Batalha'),
        centerTitle: true,
      ),
      body: _buildBattleView(),
    );
  }

  Widget _buildBattleView() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_shuffledCards.isEmpty) {
      return const Center(
        child: Text(
          'Você não possui cartas para batalhar.\nObtenha cartas no Card Diário.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
      );
    }

    if (_currentIndex >= _shuffledCards.length) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Fim de Jogo!',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'Todas as suas cartas foram usadas.\nConte seus pontos com seu oponente.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Voltar ao Menu'),
            )
          ],
        ),
      );
    }

    final currentCard = _shuffledCards[_currentIndex];

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Carta ${_currentIndex + 1} de ${_shuffledCards.length}',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white70),
            ),
            const SizedBox(height: 10),

            SuperTrumpCard(hero: currentCard),
            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: _nextCard,
              style:
              ElevatedButton.styleFrom(backgroundColor: Colors.green[600]),
              child: const Text('Ganhei!'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _nextCard,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red[600]),
              child: const Text('Perdi'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _nextCard,
              style:
              ElevatedButton.styleFrom(backgroundColor: Colors.grey[600]),
              child: const Text('Empate'),
            ),
          ],
        ),
      ),
    );
  }
}

