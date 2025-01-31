import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/style/app_colors.dart';

class LoadingHomeAppBarWidget extends StatelessWidget {
  const LoadingHomeAppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColor.lightGrey2,
      highlightColor: const Color.fromARGB(255, 244, 244, 244),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildItem(20, 250),
              _buildItem(20, 150),
            ],
          ),
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: AppColor.lightGrey2,
              shape: BoxShape.circle,
            ),
          )
        ],
      ),
    );
  }

  Padding _buildItem(double height, double? width) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Container(
        height: height,
        width: width ?? double.infinity,
        decoration: BoxDecoration(
          color: AppColor.lightGrey2,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
