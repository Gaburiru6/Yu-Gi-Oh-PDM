import 'package:http/http.dart' as http;
import 'dart:convert';
import 'database_helper.dart';
import '../models/hero_model.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

class ApiService {
  final String _apiUrl =
      'https://server-json-hero.vercel.app/api/data';
  final dbHelper = DatabaseHelper.instance;

  Future<void> fetchAndCacheHeroes() async {
    try {
      int heroCount = await dbHelper.getHeroCount();
      if (heroCount > 0) {
        debugPrint('Cache já populado com $heroCount heróis. Não buscando na API.');
        return;
      }

      debugPrint('Cache vazio. Buscando heróis da API...');

      final response = await http.get(Uri.parse(_apiUrl));

      if (response.statusCode == 200) {
        List<HeroModel> heroes = await compute(_parseHeroes, response.body);

        if (heroes.isNotEmpty) {
          await dbHelper.batchInsertHeroes(heroes);
          debugPrint('Cache populado com ${heroes.length} heróis.');
        }
      } else {
        debugPrint(
            'Erro ao buscar da API: Status Code ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Erro no fetchAndCacheHeroes: $e');
    }
  }

  static List<HeroModel> _parseHeroes(String responseBody) {
    final List<dynamic> parsed = json.decode(responseBody);
    return parsed.map<HeroModel>((json) => HeroModel.fromJson(json)).toList();
  }

  Future<List<HeroModel>> getHeroesFromDb(int page, int pageSize) async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    bool hasInternet = connectivityResult.first != ConnectivityResult.none;

    if (hasInternet) {
      fetchAndCacheHeroes();
    }

    return dbHelper.getPaginatedHeroes(page, pageSize);
  }
}

