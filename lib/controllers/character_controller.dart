import 'package:get/get.dart';
import '../models/character.dart';
import '../services/api_service.dart';

class CharacterController extends GetxController {
  final RxList<Character> _characters = <Character>[].obs;
  final RxBool _isLoading = false.obs;
  final RxString _errorMessage = ''.obs;
  final RxString _status = ''.obs;

  String searchName = '';

  List<Character> get characters => _characters;
  bool get isLoading => _isLoading.value;
  String get errorMessage => _errorMessage.value;
  String get status => _status.value;

  @override
  void onInit() {
    fetchCharacters();
    super.onInit();
  }

  Future<void> fetchCharacters() async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';
      final data = await ApiService.getCharacters(
        status: _status.value,
        name: searchName,
      );
      _characters.assignAll(data);
    } catch (e) {
      _errorMessage.value = 'Gagal memuat data. Periksa koneksi internet kamu.';
    }
    _isLoading.value = false;
  }

  void setStatus(String newStatus) {
    _status.value = newStatus;
    fetchCharacters();
  }

  void search(String name) {
    searchName = name.trim();
    fetchCharacters();
  }
}
