import 'package:flutter/material.dart';
import 'spacing_size.dart';

class SpaceVertical extends StatelessWidget {
  final double height;

  const SpaceVertical.x1({super.key}) : height = Spacing.x1;
  const SpaceVertical.x2({super.key}) : height = Spacing.x2;
  const SpaceVertical.x3({super.key}) : height = Spacing.x3;
  const SpaceVertical.x4({super.key}) : height = Spacing.x4;
  const SpaceVertical.x5({super.key}) : height = Spacing.x5;
  const SpaceVertical.x6({super.key}) : height = Spacing.x6;
  const SpaceVertical.x7({super.key}) : height = Spacing.x7;
  const SpaceVertical.x8({super.key}) : height = Spacing.x8;
  const SpaceVertical.x9({super.key}) : height = Spacing.x9;
  const SpaceVertical.x10({super.key}) : height = Spacing.x10;
  @override
  Widget build(BuildContext context) {
    return SizedBox(height: height);
  }
}
