import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/style/app_colors.dart';
import '../../../../widgets/image/profile_image_widget.dart';

class SelectUserImageWidget extends StatelessWidget {
  const SelectUserImageWidget({
    super.key,
    required this.image,
    required this.onTap,
    this.imageBytes,
    this.networkPhotoUrl,
  });
  final File? image;
  final Function() onTap;
  final Uint8List? imageBytes;
  /// URL da foto atual (ex: Supabase) - usada quando não há image/imageBytes
  final String? networkPhotoUrl;

  @override
  Widget build(BuildContext context) {
    final displayImage = image?.path ?? networkPhotoUrl;
    return Center(
      child: SizedBox(
        height: 104,
        width: 104,
        child: Stack(
          children: [
            ProfileImageWidget(
              image: displayImage,
              imageBytes: imageBytes,
              size: 100,
            ),
            Positioned(
              top: 66,
              left: 66,
              child: GestureDetector(
                onTap: onTap,
                child: SvgPicture.asset(
                  'assets/icons/edit.svg',
                  colorFilter: const ColorFilter.mode(
                    AppColor.orange500,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
