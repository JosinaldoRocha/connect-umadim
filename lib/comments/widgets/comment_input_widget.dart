import 'package:connect_umadim_app/app/core/style/app_colors.dart';
import 'package:connect_umadim_app/app/core/style/app_text.dart';
import 'package:connect_umadim_app/app/data/models/comment_model.dart';
import 'package:flutter/material.dart';

import '../../app/core/style/app_decoration.dart';

class CommentInputWidget extends StatefulWidget {
  final Future<void> Function(String content) onSend;
  final CommentModel? replyingTo;
  final VoidCallback onClearReply;

  const CommentInputWidget({
    super.key,
    required this.onSend,
    required this.replyingTo,
    required this.onClearReply,
  });

  @override
  State<CommentInputWidget> createState() => _CommentInputWidgetState();
}

class _CommentInputWidgetState extends State<CommentInputWidget> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  bool _hasText = false;
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final has = _controller.text.trim().isNotEmpty;
      if (has != _hasText) setState(() => _hasText = has);
    });
  }

  @override
  void didUpdateWidget(CommentInputWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Foca o input quando começa a responder
    if (widget.replyingTo != null &&
        oldWidget.replyingTo != widget.replyingTo) {
      _focusNode.requestFocus();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _isSending) return;

    setState(() => _isSending = true);
    _controller.clear();
    _focusNode.unfocus();

    await widget.onSend(text);

    if (mounted) setState(() => _isSending = false);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 10,
          bottom: MediaQuery.of(context).viewInsets.bottom > 0 ? 10 : 14,
        ),
        child: Row(
          children: [
            // Input
            Expanded(
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                maxLines: 4,
                minLines: 1,
                maxLength: 500,
                buildCounter: (_,
                        {required currentLength,
                        maxLength,
                        required isFocused}) =>
                    null,
                style: AppText.bodySmall(context).copyWith(fontSize: 13),
                decoration: InputDecoration(
                  hintText: widget.replyingTo != null
                      ? 'Responder a @${widget.replyingTo!.authorName}...'
                      : 'Adicionar comentário...',
                  hintStyle: AppText.bodySmall(context).copyWith(
                    color: isDark
                        ? AppColor.darkOnSurfaceMuted
                        : AppColor.lightOnSurfaceMuted,
                    fontSize: 13,
                  ),
                  filled: true,
                  fillColor: isDark
                      ? AppColor.darkSurfaceVariant
                      : AppColor.lightSurfaceVariant,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: AppDecoration.radiusFull,
                    borderSide: BorderSide(
                      color:
                          isDark ? AppColor.darkBorder : AppColor.lightBorder,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: AppDecoration.radiusFull,
                    borderSide: BorderSide(
                      color:
                          isDark ? AppColor.darkBorder : AppColor.lightBorder,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: AppDecoration.radiusFull,
                    borderSide:
                        const BorderSide(color: AppColor.orange500, width: 1.5),
                  ),
                ),
                onSubmitted: (_) => _send(),
              ),
            ),
            const SizedBox(width: 8),

            // Botão enviar
            AnimatedOpacity(
              opacity: _hasText && !_isSending ? 1.0 : 0.4,
              duration: const Duration(milliseconds: 200),
              child: GestureDetector(
                onTap: _hasText && !_isSending ? _send : null,
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColor.orange500,
                  ),
                  child: _isSending
                      ? const Padding(
                          padding: EdgeInsets.all(10),
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColor.light50,
                          ),
                        )
                      : const Icon(
                          Icons.arrow_upward_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
