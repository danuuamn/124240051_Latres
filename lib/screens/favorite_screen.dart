import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/favorite_controller.dart';
import '../widgets/character_tile.dart';
import 'detail_screen.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FavoriteController favC = Get.find<FavoriteController>();

    return Obx(() {
      if (favC.favorites.isEmpty) {
        return const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.favorite_border, size: 64, color: Colors.grey),
              SizedBox(height: 12),
              Text(
                'Belum ada karakter favorit',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text('Tekan ikon hati pada karakter untuk menambahkannya'),
            ],
          ),
        );
      }

      return ListView.builder(
        itemCount: favC.favorites.length,
        itemBuilder: (context, index) {
          final character = favC.favorites[index];

          return Dismissible(
            key: Key('fav_${character.id}'),
            direction: DismissDirection.endToStart,
            background: Container(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              padding: const EdgeInsets.only(right: 20),
              alignment: Alignment.centerRight,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            onDismissed: (direction) {
              favC.removeFavorite(character);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: const Duration(seconds: 2),
                  content: Text('${character.name} dihapus dari favorit'),
                ),
              );
            },
            child: CharacterTile(
              character: character,
              onTap: () => Get.to(() => DetailScreen(characterId: character.id)),
            ),
          );
        },
      );
    });
  }
}
