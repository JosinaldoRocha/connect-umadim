import 'package:connect_umadim_app/app/core/style/app_colors.dart';
import 'package:connect_umadim_app/app/core/style/app_text.dart';
import 'package:connect_umadim_app/app/data/enums/funciton_type_enum.dart';
import 'package:connect_umadim_app/app/data/models/user_model.dart';
import 'package:connect_umadim_app/app/presentation/home/views/widgets/user_item_widget.dart';
import 'package:flutter/material.dart';

import '../../../../core/style/app_decoration.dart';

class UsersListWidget extends StatefulWidget {
  final List<UserModel> users;
  const UsersListWidget({super.key, required this.users});

  @override
  State<UsersListWidget> createState() => _UsersListWidgetState();
}

class _UsersListWidgetState extends State<UsersListWidget> {
  final _searchController = TextEditingController();
  final Map<String, bool> _expanded = {};
  String _selectedArea = 'Todos';
  String _searchQuery = '';

  // Preservado do original
  final List<FunctionType> _functionOrder = [
    FunctionType.leader,
    FunctionType.viceLeader,
    FunctionType.regent,
    FunctionType.secretary,
    FunctionType.doorman,
    FunctionType.receptionist,
    FunctionType.media,
    FunctionType.evangelist,
    FunctionType.events,
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<UserModel> get _filtered => widget.users.where((u) {
        final matchSearch = _searchQuery.isEmpty ||
            u.name.toLowerCase().contains(_searchQuery.toLowerCase());
        final matchArea = _selectedArea == 'Todos' || u.areaId == _selectedArea;
        return matchSearch && matchArea;
      }).toList();

  Map<String, List<UserModel>> _groupByCongregation(List<UserModel> users) {
    final Map<String, List<UserModel>> grouped = {};
    for (final u in users) {
      grouped.putIfAbsent(u.congregation, () => []).add(u);
    }
    for (final group in grouped.values) {
      group.sort((a, b) {
        int ia = _functionOrder.indexOf(a.localFunction.title);
        int ib = _functionOrder.indexOf(b.localFunction.title);
        if (ia == -1) ia = _functionOrder.length;
        if (ib == -1) ib = _functionOrder.length;
        if (ia != ib) return ia.compareTo(ib);
        return a.name.compareTo(b.name);
      });
    }
    return grouped;
  }

  List<String> get _areas {
    final areas = widget.users
        .map((u) => u.areaId)
        .where((a) => a.isNotEmpty)
        .toSet()
        .toList()
      ..sort();
    return ['Todos', ...areas];
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final filtered = _filtered;
    final grouped = _groupByCongregation(filtered);

    return Column(
      children: [
        _buildSearch(context, isDark),
        _buildAreaFilters(context, isDark),
        const SizedBox(height: 8),
        Expanded(
          child: filtered.isEmpty
              ? _buildEmpty(context)
              : ListView(
                  padding: const EdgeInsets.only(bottom: 24),
                  children: grouped.keys.map((congregation) {
                    final members = grouped[congregation]!;
                    final isExpanded = _expanded[congregation] ?? false;
                    return _CongregationSection(
                      congregation: congregation,
                      areaId: members.first.areaId,
                      members: members,
                      isExpanded: isExpanded,
                      isDark: isDark,
                      onToggle: () =>
                          setState(() => _expanded[congregation] = !isExpanded),
                    );
                  }).toList(),
                ),
        ),
      ],
    );
  }

  Widget _buildSearch(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 0),
      child: TextField(
        controller: _searchController,
        style: AppText.bodySmall(context).copyWith(fontSize: 13),
        onChanged: (v) => setState(() => _searchQuery = v),
        decoration: InputDecoration(
          hintText: 'Buscar membro...',
          hintStyle: AppText.bodySmall(context).copyWith(
            color: isDark
                ? AppColor.darkOnSurfaceMuted
                : AppColor.lightOnSurfaceMuted,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            size: 18,
            color: isDark
                ? AppColor.darkOnSurfaceMuted
                : AppColor.lightOnSurfaceMuted,
          ),
          suffixIcon: _searchQuery.isNotEmpty
              ? GestureDetector(
                  onTap: () {
                    _searchController.clear();
                    setState(() => _searchQuery = '');
                  },
                  child: Icon(Icons.close_rounded,
                      size: 16,
                      color: isDark
                          ? AppColor.darkOnSurfaceMuted
                          : AppColor.lightOnSurfaceMuted),
                )
              : null,
          filled: true,
          fillColor: isDark
              ? AppColor.darkSurfaceVariant
              : AppColor.lightSurfaceVariant,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          border: OutlineInputBorder(
            borderRadius: AppDecoration.radiusMd,
            borderSide: BorderSide(
                color: isDark ? AppColor.darkBorder : AppColor.lightBorder),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: AppDecoration.radiusMd,
            borderSide: BorderSide(
                color: isDark ? AppColor.darkBorder : AppColor.lightBorder),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: AppDecoration.radiusMd,
            borderSide: const BorderSide(color: AppColor.orange500),
          ),
        ),
      ),
    );
  }

  Widget _buildAreaFilters(BuildContext context, bool isDark) {
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(14, 8, 14, 0),
        children: _areas.asMap().entries.map((entry) {
          final i = entry.key;
          final area = entry.value;
          final isSelected = _selectedArea == area;
          return Padding(
            padding: EdgeInsets.only(right: i < _areas.length - 1 ? 8 : 0),
            child: GestureDetector(
              onTap: () => setState(() => _selectedArea = area),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColor.orange500.withOpacity(0.15)
                      : (isDark
                          ? AppColor.darkSurfaceVariant
                          : AppColor.lightSurfaceVariant),
                  borderRadius: AppDecoration.radiusFull,
                  border: Border.all(
                    color: isSelected
                        ? AppColor.orange500
                        : (isDark
                            ? AppColor.darkBorderStrong
                            : AppColor.lightBorderStrong),
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                child: Text(
                  area,
                  style: AppText.labelSmall(context).copyWith(
                    color: isSelected
                        ? AppColor.orange400
                        : (isDark
                            ? AppColor.darkOnSurfaceMuted
                            : AppColor.lightOnSurfaceMuted),
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildEmpty(BuildContext context) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🔍', style: TextStyle(fontSize: 36)),
            const SizedBox(height: 12),
            Text('Nenhum membro encontrado', style: AppText.bodySmall(context)),
          ],
        ),
      );
}

// ── Seção de congregação expansível ──────────────────────────

class _CongregationSection extends StatelessWidget {
  final String congregation;
  final String areaId;
  final List<UserModel> members;
  final bool isExpanded;
  final bool isDark;
  final VoidCallback onToggle;

  const _CongregationSection({
    required this.congregation,
    required this.areaId,
    required this.members,
    required this.isExpanded,
    required this.isDark,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Cabeçalho
        GestureDetector(
          onTap: onToggle,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 8),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(congregation, style: AppText.headlineSmall(context)),
                      const SizedBox(height: 2),
                      Text(
                        '${areaId.isNotEmpty ? '$areaId · ' : ''}${members.length} membro${members.length != 1 ? 's' : ''}',
                        style: AppText.labelSmall(context),
                      ),
                    ],
                  ),
                ),
                AnimatedRotation(
                  turns: isExpanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 20,
                    color: AppColor.amber400,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Divisor
        Container(
          height: 1,
          margin: const EdgeInsets.symmetric(horizontal: 14),
          color: isDark ? AppColor.darkBorder : AppColor.lightBorder,
        ),

        // Membros com animação
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 220),
          crossFadeState:
              isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          firstChild: const SizedBox.shrink(),
          secondChild: Column(
            children: members.map((u) => UserItemWidget(user: u)).toList(),
          ),
        ),
      ],
    );
  }
}
