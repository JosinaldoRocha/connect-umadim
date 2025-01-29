import 'dart:io';

import 'package:flutter/material.dart';

class ProfileImageWidget extends StatelessWidget {
  const ProfileImageWidget({
    super.key,
    required this.image,
    required this.size,
  });

  final String? image;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: image == null || image!.isEmpty
          ? Center(
              child: CircleAvatar(
                radius: size,
                backgroundImage: AssetImage('assets/images/profile.png'),
              ),
            )
          : SizedBox(
              width: size,
              height: size,
              child: image!.contains('control-concierge-agents')
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.network(
                        image!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(Icons.error, size: size);
                        },
                      ),
                    )
                  : CircleAvatar(
                      radius: size,
                      backgroundImage: FileImage(File(image!)),
                    ),
            ),
    );
  }
}
