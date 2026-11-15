import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'controllers/character_controller.dart';
import 'controllers/episode_controller.dart';
import 'controllers/favorite_controller.dart';
import 'models/user.dart';
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(UserAdapter());
  await Hive.openBox<User>('users');

  Get.lazyPut<CharacterController>(() => CharacterController());
  Get.lazyPut<FavoriteController>(() => FavoriteController());
  Get.lazyPut<EpisodeController>(() => EpisodeController());

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Rick & Morty Explorer',
      debugShowCheckedModeBanner: false,
      home: const LoginScreen(),
    );
  }
}
