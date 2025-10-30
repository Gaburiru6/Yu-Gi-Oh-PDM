import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import '../models/hero_model.dart';
import '../services/api_service.dart';
import '../widgets/hero_list_card.dart';
import 'hero_detail_screen.dart';

class HeroesListScreen extends StatefulWidget {
  const HeroesListScreen({super.key});

  @override
  State<HeroesListScreen> createState() => _HeroesListScreenState();
}

class _HeroesListScreenState extends State<HeroesListScreen> {
  static const _pageSize = 20;
  final PagingController<int, HeroModel> _pagingController =
  PagingController(firstPageKey: 1);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final apiService = Provider.of<ApiService>(context, listen: false);
      final newItems = await apiService.getHeroesFromDb(pageKey, _pageSize);

      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Biblioteca de Heróis'),
      ),
      body: PagedListView<int, HeroModel>(
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<HeroModel>(
          itemBuilder: (context, item, index) => HeroListCard(
            hero: item,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HeroDetailScreen(hero: item),
                ),
              );

            },
          ),
          firstPageProgressIndicatorBuilder: (_) =>
          const Center(child: CircularProgressIndicator.adaptive()),
          newPageProgressIndicatorBuilder: (_) =>
          const Center(child: CircularProgressIndicator.adaptive()),
          firstPageErrorIndicatorBuilder: (_) => _buildErrorWidget(),
          newPageErrorIndicatorBuilder: (_) => _buildErrorWidget(),
          noItemsFoundIndicatorBuilder: (_) => _buildNoItemsWidget(),
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 50),
          const SizedBox(height: 16),
          const Text(
            "Não foi possível carregar os heróis.",
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => _pagingController.retryLastFailedRequest(),
            child: const Text('Tentar Novamente'),
          ),
        ],
      ),
    );
  }

  Widget _buildNoItemsWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.info_outline, color: Colors.grey, size: 50),
          const SizedBox(height: 16),
          const Text(
            "Nenhum herói encontrado no cache.",
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => _pagingController.refresh(),
            child: const Text('Recarregar'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
