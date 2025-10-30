import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import '../models/hero_model.dart';
import '../services/database_helper.dart';
import '../widgets/super_trump_card.dart';

class MyCardDetailScreen extends StatelessWidget {
  const MyCardDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final HeroModel hero = ModalRoute.of(context)!.settings.arguments as HeroModel;

    void _showAbandonDialog() {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.warning,
        animType: AnimType.bottomSlide,
        title: 'Abandonar Carta',
        desc: 'Você tem certeza que deseja remover ${hero.name} da sua coleção?',
        btnCancelText: 'Cancelar',
        btnOkText: 'Abandonar',
        btnCancelOnPress: () {},
        btnOkOnPress: () async {
          await DatabaseHelper.instance.removeHeroFromMyCards(hero.id);
          if (context.mounted) {
            Navigator.of(context).pop();
          }
        },
      ).show();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(hero.name),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SuperTrumpCard(hero: hero),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.delete_forever),
              label: const Text('Abandonar'),
              onPressed: _showAbandonDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[800],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

