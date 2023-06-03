import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Padding webShimmer(double height) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Shimmer.fromColors(
      baseColor: const Color(0xffE6E8EB),
      highlightColor: const Color(0xffF9F9FB),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(0.1, 1.0),
                blurRadius: 6.0,
              ),
            ],
          ),
          width: double.infinity,
          height: height,
        ),
      ),
    ),
  );
}
