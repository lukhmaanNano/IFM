import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../styles/common Color.dart';

class StackDialog {
  static Future show(
      String? header, String? body, IconData? icon, Color? color) async {
    return Get.snackbar(
      backgroundColor: Colors.white,
      maxWidth: 400,
      header!,
      body!,
      icon: Icon(icon, color: color),
      duration: const Duration(seconds: 3),
      snackPosition: SnackPosition.TOP,
    );
  }
}
