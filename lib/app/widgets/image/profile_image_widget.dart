import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ProfileImageWidget extends StatelessWidget {
  const ProfileImageWidget({
    super.key,
    required this.image,
    required this.size,
    this.imageBytes,
  });

  final String? image;
  final double size;
  final Uint8List? imageBytes;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: _buildImageWidget(),
      ),
    );
  }

  Widget _buildImageWidget() {
    if (imageBytes != null) {
      return Image.memory(imageBytes!, fit: BoxFit.cover);
    }

    if (image != null) {
      if (image!.contains('connect-umadim')) {
        return Image.network(
          image!,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Icon(Icons.error, size: size),
        );
      }

      if (!kIsWeb) {
        return CircleAvatar(
          radius: size,
          backgroundImage: FileImage(File(image!)),
        );
      }
    }

    return const CircleAvatar(
      backgroundImage: AssetImage('assets/images/profile.png'),
    );
  }
}
