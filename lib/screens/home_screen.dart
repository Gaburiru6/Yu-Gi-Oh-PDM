import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yu-Gi-Oh'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.shield),
                label: const Text('Heróis'),
                onPressed: () {
                  Navigator.pushNamed(context, '/heroes');
                },
              ),
              const SizedBox(height: 20),

              ElevatedButton.icon(
                icon: const Icon(Icons.calendar_today),
                label: const Text('Card Diário'),
                onPressed: () {
                  Navigator.pushNamed(context, '/daily-card');
                },
              ),
              const SizedBox(height: 20),

              ElevatedButton.icon(
                icon: const Icon(Icons.style),
                label: const Text('Minhas Cartas'),
                onPressed: () {
                  Navigator.pushNamed(context, '/my-cards');
                },
              ),
              const SizedBox(height: 20),

              ElevatedButton.icon(
                icon: const Icon(Icons.bolt),
                label: const Text('Batalhar'),
                onPressed: () {
                  Navigator.pushNamed(context, '/battle');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

