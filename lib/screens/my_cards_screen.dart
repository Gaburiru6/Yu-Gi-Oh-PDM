import 'package:flutter/material.dart';
import '../services/database_helper.dart';
import '../models/hero_model.dart';
import '../widgets/hero_list_card.dart';

class MyCardsScreen extends StatefulWidget {
  const MyCardsScreen({super.key});

  @override
  State<MyCardsScreen> createState() => _MyCardsScreenState();
}

class _MyCardsScreenState extends State<MyCardsScreen> {
  late Future<List<HeroModel>> _myCardsFuture;
  final dbHelper = DatabaseHelper.instance;

  @override
  void initState() {
    super.initState();
    _loadCards();
  }

  void _loadCards() {
    setState(() {
      _myCardsFuture = dbHelper.getMyCards();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas Cartas'),
      ),
      body: FutureBuilder<List<HeroModel>>(
        future: _myCardsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'Você ainda não possui cartas.\nObtenha sua primeira no Card Diário!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
            );
          } else {
            final cards = snapshot.data!;
            return ListView.builder(
              itemCount: cards.length,
              itemBuilder: (context, index) {
                final hero = cards[index];
                return HeroListCard(
                  hero: hero,
                  onTap: () async {
                    await Navigator.pushNamed(
                      context,
                      '/my-card-detail',
                      arguments: hero,
                    );
                    _loadCards();
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}

