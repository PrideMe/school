import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/tech_widgets.dart';

class TechSidebar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  const TechSidebar({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  static const List<_NavItem> _items = [
    _NavItem('首页驾驶舱', Icons.dashboard_outlined, Icons.dashboard),
    _NavItem('三个课堂', Icons.video_library_outlined, Icons.video_library),
    _NavItem('远程互动课堂', Icons.cast_for_education_outlined, Icons.cast_for_education),
    _NavItem('课堂评价报告', Icons.assessment_outlined, Icons.assessment),
    _NavItem('GPA 综合评估', Icons.grade_outlined, Icons.grade),
    _NavItem('托福雅思考练', Icons.translate_outlined, Icons.translate),
    _NavItem('教学资源中心', Icons.folder_special_outlined, Icons.folder_special),
    _NavItem('巡课与教学管理', Icons.monetization_on_outlined, Icons.security),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          right: BorderSide(color: AppColors.cardBorder, width: 1),
        ),
      ),
      child: Column(
        children: [
          // Logo & Brand Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AppColors.cardBorder, width: 1),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.4),
                        blurRadius: 10,
                      )
                    ],
                  ),
                  child: const Icon(
                    Icons.school,
                    color: AppColors.background,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        '智慧教育',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                        ),
                      ),
                      Text(
                        '远程互动教学系统',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Menu List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              itemCount: _items.length,
              itemBuilder: (context, index) {
                final item = _items[index];
                final isSelected = index == selectedIndex;

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: isSelected ? AppColors.primaryGradient : null,
                    color: isSelected ? null : Colors.transparent,
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.35),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            )
                          ]
                        : null,
                  ),
                  child: ListTile(
                    dense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                    leading: Icon(
                      isSelected ? item.selectedIcon : item.icon,
                      color: isSelected ? AppColors.background : AppColors.textSecondary,
                      size: 20,
                    ),
                    title: Text(
                      item.title,
                      style: TextStyle(
                        color: isSelected ? AppColors.background : AppColors.textPrimary,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    trailing: isSelected
                        ? const Icon(
                            Icons.chevron_right,
                            color: AppColors.background,
                            size: 18,
                          )
                        : null,
                    onTap: () => onDestinationSelected(index),
                  ),
                );
              },
            ),
          ),

          // Bottom Tech Status Footer
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: AppColors.cardBorder, width: 1),
              ),
            ),
            child: TechCard(
              padding: const EdgeInsets.all(12),
              bgColor: AppColors.cardBg,
              child: Column(
                children: [
                  Row(
                    children: const [
                      PulseIndicator(color: AppColors.accentGreen, size: 8),
                      SizedBox(width: 8),
                      Text(
                        '节点传输正常',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 11,
                        ),
                      ),
                      Spacer(),
                      TechBadge(label: 'V1.0', color: AppColors.primary),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        '延时: 12ms',
                        style: TextStyle(color: AppColors.textMuted, fontSize: 10),
                      ),
                      Text(
                        '帧率: 60FPS',
                        style: TextStyle(color: AppColors.textMuted, fontSize: 10),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem {
  final String title;
  final IconData icon;
  final IconData selectedIcon;

  const _NavItem(this.title, this.icon, this.selectedIcon);
}
