import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/episode_controller.dart';

class EpisodeScreen extends StatelessWidget {
  const EpisodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final EpisodeController epC = Get.find<EpisodeController>();

    return Obx(() {
      if (epC.isLoading) {
        return const Center(child: CircularProgressIndicator());
      }

      if (epC.errorMessage != '') {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.wifi_off, size: 56, color: Colors.grey),
                const SizedBox(height: 12),
                Text(epC.errorMessage, textAlign: TextAlign.center),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => epC.fetchEpisodes(),
                  child: const Text('Coba Lagi'),
                ),
              ],
            ),
          ),
        );
      }

      return ListView.builder(
        itemCount: epC.episodes.length,
        itemBuilder: (context, index) {
          final episode = epC.episodes[index];
          return Card(
            elevation: 2,
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: ListTile(
              leading: const Icon(Icons.play_circle, color: Colors.yellow),
              title: Text(
                episode.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(episode.airDate),
            ),
          );
        },
      );
    });
  }
}
