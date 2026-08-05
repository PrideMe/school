import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/user_role.dart';
import '../providers/app_state.dart';
import '../theme/app_colors.dart';
import '../theme/tech_widgets.dart';

class TechHeader extends StatelessWidget {
  const TechHeader({super.key});

  static const _windowChannel = MethodChannel('window_control');

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final currentRole = appState.currentRole;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onPanStart: (_) {
        _windowChannel.invokeMethod('dragWindow');
      },
      child: Container(
        height: 64,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(
            bottom: BorderSide(color: AppColors.cardBorder, width: 1),
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: constraints.maxWidth),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Left badges
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (appState.isRecording) ...[
                          const TechBadge(
                            label: 'REC 录播中',
                            color: AppColors.accentRed,
                            icon: Icons.fiber_manual_record,
                          ),
                          const SizedBox(width: 8),
                        ],

                        const TechBadge(
                          label: '5G 高清音画',
                          color: AppColors.accentGreen,
                          icon: Icons.wifi_tethering,
                        ),
                        const SizedBox(width: 8),

                        const TechBadge(
                          label: '极速 2ms 延迟',
                          color: AppColors.primary,
                          icon: Icons.speed,
                        ),
                      ],
                    ),

                    // Right info, role switcher, and window control buttons
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Current Date & Time display
                        StreamBuilder<DateTime>(
                          stream: Stream.periodic(
                            const Duration(seconds: 1),
                            (_) => DateTime.now(),
                          ),
                          builder: (context, snapshot) {
                            final now = snapshot.data ?? DateTime.now();
                            final dateStr =
                                '${now.year}-${_twoDigits(now.month)}-${_twoDigits(now.day)}';
                            final timeStr =
                                '${_twoDigits(now.hour)}:${_twoDigits(now.minute)}:${_twoDigits(now.second)}';

                            return Row(
                              children: [
                                const Icon(Icons.access_time,
                                    color: AppColors.textSecondary, size: 14),
                                const SizedBox(width: 4),
                                Text(
                                  '$dateStr $timeStr',
                                  style: const TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 12,
                                    fontFamily: 'monospace',
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                        const SizedBox(width: 16),

                        // User Info & Role Switcher Dropdown Button
                        PopupMenuButton<UserRole>(
                          offset: const Offset(0, 48),
                          color: AppColors.surface,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: const BorderSide(color: AppColors.cardBorder),
                          ),
                          onSelected: (role) => appState.switchRole(role),
                          itemBuilder: (context) {
                            return UserRole.values.map((role) {
                              final isSelected = role == currentRole;
                              return PopupMenuItem<UserRole>(
                                value: role,
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.person_outline,
                                      color: isSelected
                                          ? AppColors.primary
                                          : AppColors.textSecondary,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      role.title,
                                      style: TextStyle(
                                        color: isSelected
                                            ? AppColors.primary
                                            : AppColors.textPrimary,
                                        fontWeight: isSelected
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                      ),
                                    ),
                                    if (isSelected) ...[
                                      const Spacer(),
                                      const Icon(Icons.check,
                                          color: AppColors.primary, size: 16),
                                    ]
                                  ],
                                ),
                              );
                            }).toList();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.cardBg,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: AppColors.cardBorder),
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 14,
                                  backgroundColor:
                                      AppColors.primary.withOpacity(0.2),
                                  child: const Icon(
                                    Icons.person_outline,
                                    size: 14,
                                    color: AppColors.primary,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      currentRole.title,
                                      style: const TextStyle(
                                        color: AppColors.textPrimary,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Row(
                                      children: [
                                        Text(
                                          '点击切换',
                                          style: TextStyle(
                                            color: AppColors.textMuted,
                                            fontSize: 10,
                                          ),
                                        ),
                                        Icon(Icons.arrow_drop_down,
                                            color: AppColors.primary, size: 14),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),

                        // Windows-style Window Controls Group
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.cardBg,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: AppColors.cardBorder),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _buildWindowButton(
                                icon: Icons.remove,
                                tooltip: '最小化',
                                onTap: () =>
                                    _windowChannel.invokeMethod('minimize'),
                              ),
                              const SizedBox(width: 4),
                              _buildWindowButton(
                                icon: Icons.crop_square,
                                tooltip: '最大化 / 还原',
                                onTap: () =>
                                    _windowChannel.invokeMethod('maximize'),
                              ),
                              const SizedBox(width: 4),
                              _buildWindowButton(
                                icon: Icons.close,
                                tooltip: '关闭应用',
                                isClose: true,
                                onTap: () =>
                                    _windowChannel.invokeMethod('close'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildWindowButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onTap,
    bool isClose = false,
  }) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        child: Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: isClose
                ? AppColors.accentRed.withOpacity(0.15)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Icon(
            icon,
            size: 13,
            color: isClose ? AppColors.accentRed : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  static String _twoDigits(int n) => n.toString().padLeft(2, '0');
}
