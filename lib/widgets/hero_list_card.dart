import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../models/hero_model.dart';

class HeroListCard extends StatelessWidget {
  final HeroModel hero;
  final VoidCallback onTap;

  const HeroListCard({
    super.key,
    required this.hero,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Hero(
              tag: 'hero_image_${hero.id}',
              child: CachedNetworkImage(
                imageUrl: hero.images.sm,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  width: 100,
                  height: 100,
                  color: Colors.grey[800],
                  child: const Center(
                    child: CircularProgressIndicator.adaptive(),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  width: 100,
                  height: 100,
                  color: Colors.grey[800],
                  child: const Icon(Icons.error, color: Colors.red),
                ),
              ),
            ),
            const SizedBox(width: 16),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hero.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),

                    Text(
                      "Raça: ${hero.appearance.race ?? 'N/A'}",
                      style: const TextStyle(
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 4),

                    Text(
                      "Força: ${hero.powerstats.strength}",
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 4),

                    Text(
                      "Velocidade: ${hero.powerstats.speed}",
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Icon(Icons.chevron_right, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
