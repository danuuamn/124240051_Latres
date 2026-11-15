import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/character_controller.dart';
import '../controllers/favorite_controller.dart';
import '../models/character.dart';
import '../widgets/character_tile.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CharacterController charC = Get.find<CharacterController>();
  final FavoriteController favC = Get.find<FavoriteController>();
  final _searchController = TextEditingController();

  final List<Map<String, String>> _filters = [
    {'label': 'Semua', 'value': ''},
    {'label': 'Alive', 'value': 'alive'},
    {'label': 'Dead', 'value': 'dead'},
    {'label': 'Unknown', 'value': 'unknown'},
  ];

  @override
  void initState() {
    super.initState();
    _searchController.text = charC.searchName;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleFavorite(Character character) {
    final added = favC.toggleFavorite(character);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 1),
        content: Text(added
            ? '${character.name} ditambahkan ke favorit'
            : '${character.name} dihapus dari favorit'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
          child: TextField(
            controller: _searchController,
            onSubmitted: (value) => charC.search(value),
            decoration: InputDecoration(
              labelText: 'Cari nama karakter',
              prefixIcon: const Icon(Icons.search),
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: const Icon(Icons.arrow_forward),
                onPressed: () => charC.search(_searchController.text),
              ),
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(12),
          child: Obx(() {
            final selected = charC.status;
            return Row(
              children: _filters.map((filter) {
                final isSelected = selected == filter['value'];
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            isSelected ? Colors.yellow : Colors.grey[300],
                        foregroundColor:
                            isSelected ? Colors.white : Colors.black87,
                        padding: EdgeInsets.zero,
                      ),
                      onPressed: () => charC.setStatus(filter['value']!),
                      child: Text(
                        filter['label']!,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          }),
        ),

        Expanded(
          child: Obx(() {
            if (charC.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (charC.errorMessage != '') {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.wifi_off, size: 56, color: Colors.grey),
                      const SizedBox(height: 12),
                      Text(charC.errorMessage, textAlign: TextAlign.center),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () => charC.fetchCharacters(),
                        child: const Text('Coba Lagi'),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (charC.characters.isEmpty) {
              return const Center(child: Text('Karakter tidak ditemukan'));
            }

            return ListView.builder(
              itemCount: charC.characters.length,
              itemBuilder: (context, index) {
                final character = charC.characters[index];
                return CharacterTile(
                  character: character,
                  onTap: () => Get.to(() => DetailScreen(characterId: character.id)),
                  trailing: Obx(() {
                    final isFav = favC.isFavorite(character.id);
                    return IconButton(
                      icon: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        color: Colors.red,
                      ),
                      onPressed: () => _toggleFavorite(character),
                    );
                  }),
                );
              },
            );
          }),
        ),
      ],
    );
  }
}
