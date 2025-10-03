
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:macador_bd_cs/bindings/app_binding.dart';
import 'package:macador_bd_cs/views/welcome_view.dart';

void main() {
  runApp(const MapApp());
}

class MapApp extends StatelessWidget {
  const MapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Campus Cordillera',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(useMaterial3: true),
      initialBinding: AppBinding(),
      home: const WelcomeView(),
    );
  }
}
