import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/favorite_controller.dart';
import '../models/character.dart';
import '../services/api_service.dart';
import '../widgets/status_text.dart';

class DetailScreen extends StatefulWidget {
  final int characterId;
  const DetailScreen({super.key, required this.characterId});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final FavoriteController favC = Get.find<FavoriteController>();

  Character? character;
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchCharacter();
  }

  Future<void> fetchCharacter() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });
    try {
      final data = await ApiService.getCharacterDetail(widget.characterId);
      if (!mounted) return;
      setState(() {
        character = data;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        errorMessage = 'Gagal memuat detail. Periksa koneksi internet kamu.';
        isLoading = false;
      });
    }
  }

  void _toggleFavorite(Character c) {
    final added = favC.toggleFavorite(c);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 1),
        content: Text(added
            ? '${c.name} ditambahkan ke favorit'
            : '${c.name} dihapus dari favorit'),
      ),
    );
  }

  Widget _infoRow(String label, Widget value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: value),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (character == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.wifi_off, size: 56, color: Colors.grey),
              const SizedBox(height: 12),
              Text(errorMessage, textAlign: TextAlign.center),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: fetchCharacter,
                child: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
      );
    }

    final c = character!;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            c.image,
            width: double.infinity,
            height: 300,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  c.name,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        _infoRow('Status', StatusText(status: c.status)),
                        _infoRow('Species', Text(c.species)),
                        _infoRow('Gender', Text(c.gender)),
                        _infoRow('Origin', Text(c.origin)),
                        _infoRow('Location', Text(c.location)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Obx(() {
                  final isFav = favC.isFavorite(c.id);
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isFav ? Colors.red : Colors.yellow,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () => _toggleFavorite(c),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(isFav ? Icons.favorite : Icons.favorite_border),
                          const SizedBox(width: 8),
                          Text(isFav ? 'Hapus dari Favorit' : 'Tambah ke Favorit'),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.yellow,
        foregroundColor: Colors.white,
      ),
      body: _buildContent(),
    );
  }
}
