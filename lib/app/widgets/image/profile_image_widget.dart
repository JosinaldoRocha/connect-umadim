import 'dart:io';
import 'package:connect_umadim_app/app/core/supabase/supabase_init.dart';
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
      if (image!.contains('connect-umadim') && isSupabaseImageUrlValid(image)) {
        return Image.network(
          image!,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Icon(Icons.error, size: size),
        );
      }

      // Só usa File para caminhos locais (não URLs http/https)
      final isLocalPath = !image!.startsWith('http://') && !image!.startsWith('https://');
      if (!kIsWeb && isLocalPath) {
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
