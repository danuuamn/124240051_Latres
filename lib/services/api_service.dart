import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/character.dart';
import '../models/episode.dart';

class ApiService {
  static const String baseUrl = 'https://rickandmortyapi.com/api';

  static Future<List<Character>> getCharacters({
    String status = '',
    String name = '',
  }) async {
    String url = '$baseUrl/character?';
    if (status != '') {
      url += 'status=$status&';
    }
    if (name != '') {
      url += 'name=${Uri.encodeComponent(name)}&';
    }

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List<Character> characters = [];
      for (var item in data['results']) {
        characters.add(Character.fromJson(item));
      }
      return characters;
    } else if (response.statusCode == 404) {
      return [];
    } else {
      throw Exception('Failed to load characters');
    }
  }

  static Future<Character> getCharacterDetail(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/character/$id'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Character.fromJson(data);
    } else {
      throw Exception('Failed to load character detail');
    }
  }

  static Future<List<Episode>> getEpisodes() async {
    List<Episode> episodes = [];
    String? url = '$baseUrl/episode';

    while (url != null) {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        for (var item in data['results']) {
          episodes.add(Episode.fromJson(item));
        }
        url = data['info']['next'];
      } else {
        throw Exception('Failed to load episodes');
      }
    }
    return episodes;
  }
}
