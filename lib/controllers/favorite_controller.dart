import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/character.dart';

class FavoriteController extends GetxController {
  final RxList<Character> _favorites = <Character>[].obs;
  List<Character> get favorites => _favorites;

  @override
  void onInit() {
    _loadFavorites();
    super.onInit();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('favorites');
    if (saved != null) {
      final List<dynamic> data = jsonDecode(saved);
      for (var item in data) {
        _favorites.add(Character.fromJson(item));
      }
    }
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> data = [];
    for (var character in _favorites) {
      data.add(character.toJson());
    }
    await prefs.setString('favorites', jsonEncode(data));
  }

  bool isFavorite(int id) {
    for (var character in _favorites) {
      if (character.id == id) {
        return true;
      }
    }
    return false;
  }

  bool toggleFavorite(Character character) {
    if (isFavorite(character.id)) {
      removeFavorite(character);
      return false;
    }
    _favorites.add(character);
    _saveFavorites();
    return true;
  }

  void removeFavorite(Character character) {
    for (int i = 0; i < _favorites.length; i++) {
      if (_favorites[i].id == character.id) {
        _favorites.removeAt(i);
        break;
      }
    }
    _saveFavorites();
  }
}
