import 'dart:io';

import 'package:connect_umadim_app/app/data/enums/post_type_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../pages/create_post_page.dart';

mixin CreatePostMixin<T extends CreatePostPage> on ConsumerState<T> {
  final contentController = TextEditingController();
  PostType selectedType = PostType.message;
  File? mediaFile;
  List<String> pollOptions = ['', ''];
  DateTime? pollEndsAt;
  bool isPublishEnabled = false;

  final _picker = ImagePicker();

  @override
  void dispose() {
    contentController.dispose();
    super.dispose();
  }

  void checkPublishEnabled() {
    final hasContent = contentController.text.trim().isNotEmpty;

    final valid = switch (selectedType) {
      PostType.photo || PostType.video => hasContent && mediaFile != null,
      PostType.poll =>
        hasContent && pollOptions.where((o) => o.trim().isNotEmpty).length >= 2,
      _ => hasContent,
    };

    if (valid != isPublishEnabled) {
      setState(() => isPublishEnabled = valid);
    }
  }

  Future<void> pickMedia(
    ImageSource source, {
    required bool isVideo,
    required void Function(File file) onPicked,
  }) async {
    try {
      final XFile? picked = isVideo
          ? await _picker.pickVideo(source: source)
          : await _picker.pickImage(
              source: source,
              imageQuality: 85,
              maxWidth: 1920,
            );

      if (picked != null) {
        onPicked(File(picked.path));
      }
    } catch (e) {
      debugPrint('Erro ao selecionar mídia: $e');
    }
  }
}
