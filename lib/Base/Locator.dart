import 'package:firstgame/Services/AuthProvider.dart';
import 'package:firstgame/Services/MusicService.dart';
import 'package:get/get.dart';

setupLocator() {
  Get.put<AuthProvider>(AuthProvider());
  Get.put<MusicService>(MusicService());
}
