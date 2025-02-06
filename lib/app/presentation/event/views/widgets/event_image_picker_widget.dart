import 'dart:io';
import 'package:connect_umadim_app/app/core/style/app_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../core/style/app_colors.dart';

class EventImagePickerWidget extends StatelessWidget {
  const EventImagePickerWidget({
    super.key,
    required this.image,
    required this.onTap,
    this.imageBytes,
  });
  final File? image;
  final Function() onTap;
  final Uint8List? imageBytes;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            height: image != null || imageBytes != null ? 250 : 66,
            child: _buildImageWidget(),
          ),
        ),
      ),
    );
  }

  Widget _buildImageWidget() {
    if (imageBytes != null) {
      return Image.memory(imageBytes!, fit: BoxFit.cover);
    }

    if (image != null) {
      if (image!.path.contains('connect-umadim')) {
        return Image.network(
          image!.path,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Icon(Icons.error, size: 100),
        );
      }

      if (!kIsWeb) {
        return Image.file(File(image!.path));
      }
    }

    return Column(
      children: [
        Icon(
          Icons.image,
          size: 48,
          color: AppColor.mediumGrey,
        ),
        Text(
          'Toque para selecionar uma imagem',
          style: AppText.text().bodySmall,
        ),
      ],
    );
  }
}
