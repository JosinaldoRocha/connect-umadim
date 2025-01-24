import 'package:flutter/material.dart';
import 'spacing_size.dart';

class SpaceHorizontal extends StatelessWidget {
  final double width;

  const SpaceHorizontal.x1({super.key}) : width = Spacing.x1;
  const SpaceHorizontal.x2({super.key}) : width = Spacing.x2;
  const SpaceHorizontal.x3({super.key}) : width = Spacing.x3;
  const SpaceHorizontal.x4({super.key}) : width = Spacing.x4;
  const SpaceHorizontal.x5({super.key}) : width = Spacing.x5;
  const SpaceHorizontal.x6({super.key}) : width = Spacing.x6;
  const SpaceHorizontal.x7({super.key}) : width = Spacing.x7;
  const SpaceHorizontal.x8({super.key}) : width = Spacing.x8;
  const SpaceHorizontal.x9({super.key}) : width = Spacing.x9;
  const SpaceHorizontal.x10({super.key}) : width = Spacing.x10;
  @override
  Widget build(BuildContext context) {
    return SizedBox(width: width);
  }
}
