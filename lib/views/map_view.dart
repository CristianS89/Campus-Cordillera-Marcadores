import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart' as fm;
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:macador_bd_cs/controllers/map_controller.dart';

//Accedemos al controlador MapController de Getx para trabajar con la lógica creada
class MapView extends GetView<MapController> {
  const MapView({super.key});

  @override
  Widget build(BuildContext context) {
    final txt = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Campus Cordillera')),
      drawer: Drawer(
        child: Obx(() {
          final list = controller.markers;
          return ListView(
            padding: EdgeInsets.zero,
            children: [
              SizedBox(
                height: 90,
                child: DrawerHeader(
                  decoration: BoxDecoration(color: Color(0xFF2ECC71)),
                  child: Text(
                    "Campus Registrados",
                    style: TextStyle(color: Colors.white, fontSize: 19),
                  ),
                ),
              ),
              ...list.map(
                (m) => ListTile(
                  leading: const Icon(
                    Icons.location_on,
                    color: Color.fromARGB(255, 38, 196, 24),
                  ),
                  title: Text(m.title),
                  //subtitle: Text("Lat: ${m.lat}, Lng: ${m.lng}"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Lat: ${m.lat}, Lng: ${m.lng}"),
                      const SizedBox(height: 4),
                      if (m.imagePath != null)
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (_) => Dialog(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: Image.file(
                                    File(m.imagePath!),
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            );
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Image.file(
                              File(m.imagePath!),
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    //onPressed: () => controller.remove(m.id!),
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Cofirmar acción'),
                          content: const Text(
                            'Está seguro de eliminar este Campus Seleccionado?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text('NO'),
                            ),
                            ElevatedButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.redAccent,
                              ),
                              child: const Text(
                                'SI',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                      if (confirm == true) {
                        controller.remove(m.id!);
                      }
                    },
                  ),
                  onTap: () {
                    controller.selected(LatLng(m.lat, m.lng));
                    Navigator.pop(context);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Image.asset(
                  'assets/images/logoItsco.png',
                  width: 200,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          );
        }),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: txt,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Nombre del campus',
                      hintText: 'Ej.: Campus Matriz',
                    ),
                    onChanged: controller.setTitle,
                  ),
                ),
                const SizedBox(width: 8),
                //Creamos el botón para almacenar el marcador o el campus
                ElevatedButton.icon(
                  onPressed: controller.saveSelectedWithImage,
                  icon: const Icon(Icons.bookmark_add_outlined),
                  label: const Text('Guardar'),
                ),
                const SizedBox(width: 8),
                //Creamos el botón para eliminar todos los marcadores o campus registrados con una pregunta al usuario para confirmar esta acción
                OutlinedButton.icon(
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Cofirmar acción'),
                        content: const Text(
                          'Está seguro de eliminar los marcadores de todos los Campus Ingresados?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text('NO'),
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                            ),
                            child: const Text(
                              'SI',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                    if (confirm == true) {
                      controller.clearAll();
                    }
                  },
                  icon: const Icon(Icons.delete_sweep_outlined),
                  label: const Text('Limpiar'),
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              final points = controller.markers;
              return fm.FlutterMap(
                options: fm.MapOptions(
                  initialCenter: const LatLng(-0.1807, -78.4678),
                  initialZoom: 12,
                  onTap: (tapPosition, point) => controller.setSelected(point),
                ),
                children: [
                  fm.TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.map_markers_sqlite_v3',
                  ),
                  fm.MarkerLayer(
                    markers: [
                      ...points.map(
                        (m) => fm.Marker(
                          point: LatLng(m.lat, m.lng),
                          width: 140,
                          height: 160,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.location_on,
                                size: 36,
                                color: Color.fromARGB(255, 38, 196, 24),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(6),
                                  boxShadow: const [
                                    BoxShadow(
                                      blurRadius: 4,
                                      color: Colors.black26,
                                    ),
                                  ],
                                ),
                                child: Text(
                                  m.title,
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                              if (m.imagePath != null)
                                Container(
                                  width: 60,
                                  height: 60,
                                  margin: const EdgeInsets.only(top: 4),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(6),
                                    image: DecorationImage(
                                      image: FileImage(File(m.imagePath!)),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              //Se crea este botón para eliminar un Campus seleccionado dentro de la visualización del mapa
                              IconButton(
                                onPressed: () => controller.remove(m.id!),
                                icon: const Icon(
                                  Icons.delete_forever,
                                  size: 18,
                                ),
                                tooltip: 'Eliminar',
                              ),
                            ],
                          ),
                        ),
                      ),
                      //Marcamos con un ícono el punto seleccionado dentro del mapa para su posterior registro
                      if (controller.selected.value != null)
                        fm.Marker(
                          point: controller.selected.value!,
                          width: 40,
                          height: 40,
                          child: const Icon(
                            Icons.place,
                            color: Colors.blue,
                            size: 36,
                          ),
                        ),
                    ],
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}
