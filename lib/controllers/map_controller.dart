
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:image_picker/image_picker.dart';
import 'package:macador_bd_cs/models/marker_model.dart';
import 'package:macador_bd_cs/services/db_service.dart';

class MapController extends GetxController {
  final markers = <MarkerModel>[].obs;
  final selected = Rxn<LatLng>();
  final title = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadMarkers();
  }

  Future<void> loadMarkers() async {
    markers.value = await DBService.fetchAll();
  }

  void setTitle(String t) => title.value = t;
  void setSelected(LatLng? point) => selected.value = point;

  Future<String?> pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      return picked.path;
    }
    return null;
  }

  Future<void> saveSelectedWithImage() async {
    if (selected.value == null || title.value.trim().isEmpty) {
      Get.snackbar('Faltan datos', 'Selecciona un punto y escribe un Campus');
      return;
    }
    final imagePath = await pickImage();
    final m = MarkerModel(
      title: title.value.trim(),
      lat: selected.value!.latitude,
      lng: selected.value!.longitude,
      imagePath: imagePath,
    );
    await DBService.insert(m);
    await loadMarkers();
    Get.snackbar('Guardado', 'Campus con imagen almacenado');
  }

  Future<void> updateMarker(int id, String newTitle) async {
    final old = markers.firstWhere((e) => e.id == id);
    final updated = MarkerModel(
      id: id,
      title: newTitle,
      lat: old.lat,
      lng: old.lng,
      imagePath: old.imagePath,
    );
    await DBService.update(updated);
    await loadMarkers();
    Get.snackbar('Actualizado', 'Campus editado correctamente');
  }

  Future<void> remove(int id) async {
    await DBService.delete(id);
    await loadMarkers();
  }

  Future<void> clearAll() async {
    await DBService.clear();
    await loadMarkers();
  }
}
