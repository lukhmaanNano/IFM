import 'package:flutter/material.dart';
import 'package:ifm/styles/CommonSize.dart';

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> toaster(
    context, String message, Color color, IconData icon) {
  return ScaffoldMessenger.of(context as BuildContext).showSnackBar(SnackBar(
      width: displayWidth(context) * 0.6,
      backgroundColor: color,
      duration: const Duration(seconds: 1, milliseconds: 1000),
      behavior: SnackBarBehavior.floating,
      elevation: 6.0,
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(
            width: 12,
          ),
          SizedBox(
            width: displayWidth(context) * 0.4,
            child: Text(
              message,
              style: const TextStyle(
                  overflow: TextOverflow.clip,
                  letterSpacing: 1,
                  fontSize: 12,
                  color: Colors.white),
            ),
          ),
        ],
      )));
}
