import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Controller for home page state management
class HomeController extends GetxController {
  // Scroll keys
  final GlobalKey featuresKey = GlobalKey();
  final GlobalKey roadmapKey = GlobalKey();
  final GlobalKey downloadKey = GlobalKey();

  // Animation states
  final RxBool isHeroAnimating = true.obs;

  @override
  void onClose() {
    // Clean up resources if needed
    super.onClose();
  }
}
