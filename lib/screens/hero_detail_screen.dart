import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../models/hero_model.dart';

class HeroDetailScreen extends StatelessWidget {
  final HeroModel hero;

  const HeroDetailScreen({super.key, required this.hero});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(hero.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            Hero(
              tag: 'hero_image_${hero.id}',
              child: CachedNetworkImage(
                imageUrl: hero.images.lg,
                fit: BoxFit.cover,
                height: 350,
                placeholder: (context, url) => Container(
                  height: 350,
                  color: Colors.grey[800],
                  child: const Center(
                    child: CircularProgressIndicator.adaptive(),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  height: 350,
                  color: Colors.grey[800],
                  child: const Icon(Icons.error, color: Colors.red, size: 50),
                ),
              ),
            ),


            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle(context, 'Powerstats'),
                  _buildStatBar(
                      'Inteligência', hero.powerstats.intelligence),
                  _buildStatBar('Força', hero.powerstats.strength),
                  _buildStatBar('Velocidade', hero.powerstats.speed),
                  _buildStatBar('Durabilidade', hero.powerstats.durability),
                  _buildStatBar('Poder', hero.powerstats.power),
                  _buildStatBar('Combate', hero.powerstats.combat),
                  const SizedBox(height: 24),

                  _buildSectionTitle(context, 'Aparência'),
                  _buildDetailRow('Gênero', hero.appearance.gender),
                  _buildDetailRow('Raça', hero.appearance.race),
                  _buildDetailRow(
                      'Altura', hero.appearance.height.join(' / ')),
                  _buildDetailRow(
                      'Peso', hero.appearance.weight.join(' / ')),
                  const SizedBox(height: 24),

                  _buildSectionTitle(context, 'Biografia'),
                  _buildDetailRow('Nome Completo', hero.biography.fullName),
                  _buildDetailRow('Editora', hero.biography.publisher),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: Colors.blueAccent,
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 16, color: Colors.white),
          children: [
            TextSpan(
              text: '$label: ',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }

  Widget _buildStatBar(String title, int value) {
    Color statColor = Colors.green;
    if (value < 40) {
      statColor = Colors.red;
    } else if (value < 70) {
      statColor = Colors.yellow;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
              const TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
          const SizedBox(height: 4),
          LinearPercentIndicator(
            percent: value / 100.0,
            lineHeight: 20.0,
            center: Text(
              '$value',
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.grey[800],
            progressColor: statColor,
            barRadius: const Radius.circular(10),
          ),
        ],
      ),
    );
  }
}
