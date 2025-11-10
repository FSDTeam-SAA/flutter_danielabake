import 'package:flutter/material.dart';

/// A utility class for creating SizedBox with custom height and width.
class Gap extends StatelessWidget {
  final double? h;
  final double? w;

  const Gap({super.key, this.h, this.w});

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: h, width: w);
  }

  // Predefined vertical gaps
  static const Gap h4 = Gap(h: 4);
  static const Gap h8 = Gap(h: 8);
  static const Gap h12 = Gap(h: 12);
  static const Gap h16 = Gap(h: 16);
  static const Gap h20 = Gap(h: 20);
  static const Gap h24 = Gap(h: 24);
  static const Gap h32 = Gap(h: 32);
  static const Gap h40 = Gap(h: 40);
  static const Gap h48 = Gap(h: 48);
  static const Gap h56 = Gap(h: 56);
  static const Gap h64 = Gap(h: 64);

  // Predefined horizontal gaps
  static const Gap w4 = Gap(w: 4);
  static const Gap w8 = Gap(w: 8);
  static const Gap w12 = Gap(w: 12);
  static const Gap w16 = Gap(w: 16);
  static const Gap w20 = Gap(w: 20);
  static const Gap w24 = Gap(w: 24);
  static const Gap w32 = Gap(w: 32);
  static const Gap w40 = Gap(w: 40);
  static const Gap w48 = Gap(w: 48);
  static const Gap w64 = Gap(w: 64);

  // Semantic gaps
  static const Gap bottomBarGap = Gap(h: 56);
}