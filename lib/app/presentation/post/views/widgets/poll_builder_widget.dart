import 'package:connect_umadim_app/app/core/style/app_colors.dart';
import 'package:connect_umadim_app/app/core/style/app_text.dart';
import 'package:flutter/material.dart';

import '../../../../core/style/app_decoration.dart';

class PollBuilderWidget extends StatefulWidget {
  final List<String> options;
  final DateTime? pollEndsAt;
  final void Function(List<String>) onOptionsChanged;
  final void Function(DateTime?) onExpiryChanged;

  const PollBuilderWidget({
    super.key,
    required this.options,
    required this.pollEndsAt,
    required this.onOptionsChanged,
    required this.onExpiryChanged,
  });

  @override
  State<PollBuilderWidget> createState() => _PollBuilderWidgetState();
}

class _PollBuilderWidgetState extends State<PollBuilderWidget> {
  late List<TextEditingController> _controllers;
  int _selectedExpiry = 2; // índice do dropdown (7 dias por padrão)

  final List<_ExpiryOption> _expiryOptions = const [
    _ExpiryOption('1 dia', Duration(days: 1)),
    _ExpiryOption('3 dias', Duration(days: 3)),
    _ExpiryOption('7 dias', Duration(days: 7)),
    _ExpiryOption('Sem prazo', null),
  ];

  @override
  void initState() {
    super.initState();
    _controllers =
        widget.options.map((o) => TextEditingController(text: o)).toList();
    _notifyExpiry(_selectedExpiry);
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _notifyOptions() {
    widget.onOptionsChanged(_controllers.map((c) => c.text).toList());
  }

  void _notifyExpiry(int index) {
    final opt = _expiryOptions[index];
    if (opt.duration == null) {
      widget.onExpiryChanged(null);
    } else {
      widget.onExpiryChanged(DateTime.now().add(opt.duration!));
    }
  }

  void _addOption() {
    if (_controllers.length >= 5) return;
    setState(() => _controllers.add(TextEditingController()));
    _notifyOptions();
  }

  void _removeOption(int index) {
    if (_controllers.length <= 2) return;
    _controllers[index].dispose();
    setState(() => _controllers.removeAt(index));
    _notifyOptions();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'OPÇÕES DA ENQUETE',
          style: AppText.labelSmall(context).copyWith(letterSpacing: 0.1),
        ),
        const SizedBox(height: 10),

        // Opções
        ...List.generate(_controllers.length, (i) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                // Número da opção
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDark
                        ? AppColor.darkSurfaceVariant
                        : AppColor.lightSurfaceVariant,
                    border: Border.all(
                      color: isDark
                          ? AppColor.darkBorderStrong
                          : AppColor.lightBorderStrong,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '${i + 1}',
                      style: AppText.labelSmall(context).copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // Input
                Expanded(
                  child: TextField(
                    controller: _controllers[i],
                    maxLength: 80,
                    buildCounter: (_,
                            {required currentLength,
                            maxLength,
                            required isFocused}) =>
                        null,
                    style: AppText.bodySmall(context).copyWith(fontSize: 13),
                    decoration: InputDecoration(
                      hintText: 'Opção ${i + 1}',
                      hintStyle: AppText.bodySmall(context).copyWith(
                        color: isDark
                            ? AppColor.darkOnSurfaceMuted
                            : AppColor.lightOnSurfaceMuted,
                      ),
                      filled: true,
                      fillColor: isDark
                          ? AppColor.darkSurfaceVariant
                          : AppColor.lightSurfaceVariant,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: AppDecoration.radiusMd,
                        borderSide: BorderSide(
                          color: isDark
                              ? AppColor.darkBorder
                              : AppColor.lightBorder,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: AppDecoration.radiusMd,
                        borderSide: BorderSide(
                          color: isDark
                              ? AppColor.darkBorder
                              : AppColor.lightBorder,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: AppDecoration.radiusMd,
                        borderSide: const BorderSide(color: AppColor.amber400),
                      ),
                    ),
                    onChanged: (_) => _notifyOptions(),
                  ),
                ),

                // Botão remover (desabilitado nas 2 primeiras)
                const SizedBox(width: 6),
                GestureDetector(
                  onTap: i >= 2 ? () => _removeOption(i) : null,
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColor.darkSurfaceVariant
                          : AppColor.lightSurfaceVariant,
                      borderRadius: AppDecoration.radiusMd,
                    ),
                    child: Icon(
                      Icons.close_rounded,
                      size: 14,
                      color: i >= 2
                          ? (isDark
                              ? AppColor.darkOnSurface
                              : AppColor.lightOnSurface)
                          : (isDark
                              ? AppColor.darkOnSurfaceMuted.withOpacity(0.3)
                              : AppColor.lightOnSurfaceMuted.withOpacity(0.3)),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),

        // Botão adicionar opção
        if (_controllers.length < 5)
          GestureDetector(
            onTap: _addOption,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                borderRadius: AppDecoration.radiusMd,
                border: Border.all(
                  color: AppColor.amber500.withOpacity(0.3),
                  style: BorderStyle.solid,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.add_rounded,
                      size: 16, color: AppColor.amber400),
                  const SizedBox(width: 5),
                  Text(
                    'Adicionar opção',
                    style: AppText.labelMedium(context)
                        .copyWith(color: AppColor.amber400),
                  ),
                ],
              ),
            ),
          ),

        // Seletor de expiração
        _buildExpirySelector(context, isDark),
      ],
    );
  }

  Widget _buildExpirySelector(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color:
            isDark ? AppColor.darkSurfaceVariant : AppColor.lightSurfaceVariant,
        borderRadius: AppDecoration.radiusMd,
        border: Border.all(
          color: isDark ? AppColor.darkBorder : AppColor.lightBorder,
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.timer_outlined, size: 16, color: AppColor.amber400),
          const SizedBox(width: 8),
          Text('Encerra em', style: AppText.labelMedium(context)),
          const Spacer(),
          DropdownButton<int>(
            value: _selectedExpiry,
            underline: const SizedBox.shrink(),
            isDense: true,
            dropdownColor:
                isDark ? AppColor.darkSurface : AppColor.lightSurface,
            style: AppText.labelMedium(context).copyWith(
              color: AppColor.amber400,
              fontWeight: FontWeight.w600,
            ),
            items: _expiryOptions.asMap().entries.map((entry) {
              return DropdownMenuItem<int>(
                value: entry.key,
                child: Text(entry.value.label),
              );
            }).toList(),
            onChanged: (index) {
              if (index == null) return;
              setState(() => _selectedExpiry = index);
              _notifyExpiry(index);
            },
          ),
        ],
      ),
    );
  }
}

class _ExpiryOption {
  final String label;
  final Duration? duration;
  const _ExpiryOption(this.label, this.duration);
}
