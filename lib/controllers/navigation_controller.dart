import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/app_constants.dart';
import 'home_controller.dart';

/// Controller for navigation and scrolling
class NavigationController extends GetxController {
  // Scroll to section method
  void scrollToSection(GlobalKey key, {bool closeDrawer = false}) {
    if (key.currentContext != null) {
      Scrollable.ensureVisible(
        key.currentContext!,
        duration: AppConstants.scrollDuration,
        curve: Curves.fastOutSlowIn,
        alignment: 0.05,
      );
    }
    // Close drawer if on mobile
    if (closeDrawer && Get.context != null) {
      final navigator = Navigator.of(Get.context!);
      if (navigator.canPop()) {
        navigator.pop();
      }
    }
  }

  void scrollToFeatures({bool closeDrawer = false}) {
    final controller = Get.find<HomeController>();
    scrollToSection(controller.featuresKey, closeDrawer: closeDrawer);
  }

  void scrollToRoadmap({bool closeDrawer = false}) {
    final controller = Get.find<HomeController>();
    scrollToSection(controller.roadmapKey, closeDrawer: closeDrawer);
  }

  void scrollToDownload({bool closeDrawer = false}) {
    final controller = Get.find<HomeController>();
    scrollToSection(controller.downloadKey, closeDrawer: closeDrawer);
  }
}
