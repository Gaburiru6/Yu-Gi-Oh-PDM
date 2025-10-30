import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../models/hero_model.dart';

class SuperTrumpCard extends StatelessWidget {
  final HeroModel hero;

  const SuperTrumpCard({super.key, required this.hero});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: const BorderSide(color: Colors.red, width: 3),
      ),
      clipBehavior: Clip.antiAlias,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.grey[850]!, Colors.grey[900]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                hero.name.toUpperCase(),
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),
            ),

            CachedNetworkImage(
              imageUrl: hero.images.md,
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                height: 250,
                color: Colors.grey[800],
                child: const Center(child: CircularProgressIndicator.adaptive()),
              ),
              errorWidget: (context, url, error) => Container(
                height: 250,
                color: Colors.grey[800],
                child: const Icon(Icons.error, color: Colors.red),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildStatRow('Inteligência', hero.powerstats.intelligence),
                  _buildStatRow('Força', hero.powerstats.strength),
                  _buildStatRow('Velocidade', hero.powerstats.speed),
                  _buildStatRow('Durabilidade', hero.powerstats.durability),
                  _buildStatRow('Poder', hero.powerstats.power),
                  _buildStatRow('Combate', hero.powerstats.combat),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String title, int value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title.toUpperCase(),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white70,
            ),
          ),
          Text(
            value.toString(),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
