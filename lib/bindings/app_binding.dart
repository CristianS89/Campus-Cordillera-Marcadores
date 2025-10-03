
import 'package:get/get.dart';
import 'package:macador_bd_cs/controllers/map_controller.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<MapController>(MapController(), permanent: true);
  }
}
