import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';
import '../models/user_role.dart';
import '../providers/app_state.dart';
import '../theme/app_colors.dart';
import '../theme/tech_widgets.dart';

class TechHeader extends StatelessWidget {
  const TechHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final currentRole = appState.currentRole;
    final isDesktop = !kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.macOS ||
            defaultTargetPlatform == TargetPlatform.windows ||
            defaultTargetPlatform == TargetPlatform.linux);

    return GestureDetector(
      onPanStart: (_) {
        if (isDesktop) windowManager.startDragging();
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
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left badges
              if (appState.isRecording) ...[
                const TechBadge(
                  label: 'REC',
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

              const SizedBox(width: 10),

              TechBadge(
                label: '模式: ${appState.activeTeachingMode}',
                color: AppColors.primary,
                icon: Icons.bolt,
              ),

              const SizedBox(width: 24),

              // System clock display
              StreamBuilder<DateTime>(
                stream: Stream.periodic(const Duration(seconds: 1), (_) => DateTime.now()),
                builder: (context, snapshot) {
                  final now = snapshot.data ?? DateTime.now();
                  final dateStr =
                      '${now.year}-${_twoDigits(now.month)}-${_twoDigits(now.day)}';
                  final timeStr =
                      '${_twoDigits(now.hour)}:${_twoDigits(now.minute)}:${_twoDigits(now.second)}';

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        timeStr,
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontFamily: 'monospace',
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        dateStr,
                        style: const TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(width: 16),
              const VerticalDivider(color: AppColors.cardBorder, indent: 16, endIndent: 16),
              const SizedBox(width: 12),

              // Role Quick Switcher Avatar Button
              PopupMenuButton<UserRole>(
                initialValue: currentRole,
                tooltip: '切换身份视角',
                onSelected: (role) => appState.switchRole(role),
                color: AppColors.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: AppColors.cardBorder),
                ),
                itemBuilder: (context) {
                  return UserRole.values.map((role) {
                    return PopupMenuItem<UserRole>(
                      value: role,
                      child: Row(
                        children: [
                          Icon(
                            role == currentRole
                                ? Icons.radio_button_checked
                                : Icons.radio_button_unchecked,
                            color: role == currentRole
                                ? AppColors.primary
                                : AppColors.textMuted,
                            size: 16,
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                role.title,
                                style: TextStyle(
                                  color: role == currentRole
                                      ? AppColors.primary
                                      : AppColors.textPrimary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                              Text(
                                role.description,
                                style: const TextStyle(
                                  color: AppColors.textMuted,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }).toList();
                },
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: AppColors.primary.withOpacity(0.2),
                      child: const Icon(
                        Icons.account_circle,
                        color: AppColors.primary,
                        size: 22,
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
                        Row(
                          children: const [
                            Text(
                              '点击切换',
                              style: TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 10,
                              ),
                            ),
                            Icon(Icons.arrow_drop_down, color: AppColors.primary, size: 14),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Custom Desktop Window Control Buttons (Minimize, Maximize, Close)
              if (isDesktop) ...[
                const SizedBox(width: 16),
                const VerticalDivider(color: AppColors.cardBorder, indent: 16, endIndent: 16),
                const SizedBox(width: 8),
                const CustomWindowCaptionButtons(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  static String _twoDigits(int n) => n.toString().padLeft(2, '0');
}

/// Custom Futuristic Window Control Buttons Bar (Minimize, Maximize, Close)
class CustomWindowCaptionButtons extends StatelessWidget {
  const CustomWindowCaptionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Minimize Button (-)
        _WindowBtn(
          icon: Icons.remove,
          tooltip: '最小化',
          onTap: () => windowManager.minimize(),
        ),
        const SizedBox(width: 6),

        // Maximize / Restore Button (□)
        _WindowBtn(
          icon: Icons.crop_square,
          tooltip: '最大化 / 还原',
          onTap: () async {
            if (await windowManager.isMaximized()) {
              windowManager.unmaximize();
            } else {
              windowManager.maximize();
            }
          },
        ),
        const SizedBox(width: 6),

        // Close Button (✕) with Cyber Red Glow
        _WindowBtn(
          icon: Icons.close,
          tooltip: '关闭应用',
          isClose: true,
          onTap: () => windowManager.close(),
        ),
      ],
    );
  }
}

class _WindowBtn extends StatefulWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;
  final bool isClose;

  const _WindowBtn({
    required this.icon,
    required this.tooltip,
    required this.onTap,
    this.isClose = false,
  });

  @override
  State<_WindowBtn> createState() => _WindowBtnState();
}

class _WindowBtnState extends State<_WindowBtn> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final activeColor = widget.isClose ? AppColors.accentRed : AppColors.primary;

    return InkWell(
      onTap: widget.onTap,
      onHover: (hover) => setState(() => _isHovered = hover),
      borderRadius: BorderRadius.circular(6),
      child: Tooltip(
        message: widget.tooltip,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: _isHovered ? activeColor.withOpacity(0.2) : AppColors.cardBg,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: _isHovered ? activeColor : AppColors.cardBorder,
              width: 1,
            ),
          ),
          child: Icon(
            widget.icon,
            size: 14,
            color: _isHovered ? activeColor : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
