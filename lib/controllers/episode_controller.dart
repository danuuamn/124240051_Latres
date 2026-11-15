import 'package:get/get.dart';
import '../models/episode.dart';
import '../services/api_service.dart';

class EpisodeController extends GetxController {
  final RxList<Episode> _episodes = <Episode>[].obs;
  final RxBool _isLoading = false.obs;
  final RxString _errorMessage = ''.obs;

  List<Episode> get episodes => _episodes;
  bool get isLoading => _isLoading.value;
  String get errorMessage => _errorMessage.value;

  @override
  void onInit() {
    fetchEpisodes();
    super.onInit();
  }

  Future<void> fetchEpisodes() async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';
      final data = await ApiService.getEpisodes();
      _episodes.assignAll(data);
    } catch (e) {
      _errorMessage.value = 'Gagal memuat episode. Periksa koneksi internet kamu.';
    }
    _isLoading.value = false;
  }
}
