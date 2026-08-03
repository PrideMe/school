import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../theme/app_colors.dart';
import '../theme/tech_widgets.dart';

class RemoteClassroomPage extends StatefulWidget {
  const RemoteClassroomPage({super.key});

  @override
  State<RemoteClassroomPage> createState() => _RemoteClassroomPageState();
}

class _RemoteClassroomPageState extends State<RemoteClassroomPage> {
  final List<String> _students = ['李小明', '王芳芳', '张伟', '陈亮亮', '赵子涵', '孙悦'];

  static const List<String> _localModes = [
    '数字课堂',
    '分组教学',
    '分层教学',
    '翻转课堂',
    'PBL教学',
  ];

  static const List<String> _interactiveModes = [
    '智慧课堂',
    '融合课堂',
    '三个课堂',
    '在线课堂',
    '网络研修',
    '听课评课',
    '集体磨课',
    '家校互动',
  ];

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Top Interactive Control Bar
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          '远程互动教学空间',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 12),
                        TechBadge(
                          label: appState.isStudentFocused
                              ? '聚焦中: ${appState.focusedStudentName} 站立发言'
                              : '名师视角全景监控',
                          color: appState.isStudentFocused
                              ? AppColors.accentGreen
                              : AppColors.primary,
                          icon: appState.isStudentFocused
                              ? Icons.center_focus_strong
                              : Icons.videocam,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      '多端音画实时同步传输 • AI 自动视频聚焦与课堂数据自动统计',
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                    ),
                  ],
                ),
                const Spacer(),

                // Recording Control Button
                TechButton(
                  label: appState.isRecording ? '结束录播' : '开启课程实时录播',
                  icon: appState.isRecording ? Icons.stop_circle : Icons.fiber_manual_record,
                  gradient: appState.isRecording
                      ? const LinearGradient(colors: [Colors.red, Colors.redAccent])
                      : AppColors.primaryGradient,
                  onPressed: () => appState.toggleRecording(),
                ),
                const SizedBox(width: 12),

                // View Course Report Button
                TechButton(
                  label: '生成/查看课堂评估报告',
                  icon: Icons.analytics,
                  isSecondary: true,
                  onPressed: () => appState.setNavIndex(3),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Teaching Mode Quick Select Ribbon
            TechCard(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              bgColor: AppColors.surface,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    const Text(
                      '互动教学应用:',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(width: 8),
                    ..._interactiveModes.map((mode) {
                      final isSelected = appState.activeTeachingMode == mode;
                      return Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: ChoiceChip(
                          label: Text(mode),
                          selected: isSelected,
                          onSelected: (_) => appState.setTeachingMode(mode),
                          selectedColor: AppColors.primary,
                          backgroundColor: AppColors.cardBg,
                          labelStyle: TextStyle(
                            color: isSelected ? AppColors.background : AppColors.textPrimary,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            fontSize: 12,
                          ),
                          side: BorderSide(
                            color: isSelected ? AppColors.primary : AppColors.cardBorder,
                          ),
                        ),
                      );
                    }),
                    const SizedBox(width: 16),
                    const Text(
                      '本地教学应用:',
                      style: TextStyle(
                        color: AppColors.secondary,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(width: 8),
                    ..._localModes.map((mode) {
                      final isSelected = appState.activeTeachingMode == mode;
                      return Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: ChoiceChip(
                          label: Text(mode),
                          selected: isSelected,
                          onSelected: (_) => appState.setTeachingMode(mode),
                          selectedColor: AppColors.secondary,
                          backgroundColor: AppColors.cardBg,
                          labelStyle: TextStyle(
                            color: isSelected ? AppColors.background : AppColors.textPrimary,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            fontSize: 12,
                          ),
                          side: BorderSide(
                            color: isSelected ? AppColors.secondary : AppColors.cardBorder,
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Video Wall Stage
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left/Main Video Feed (Master Teacher or Focused Student)
                  Expanded(
                    flex: 3,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: appState.isStudentFocused
                              ? AppColors.accentGreen
                              : AppColors.primary,
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: (appState.isStudentFocused
                                    ? AppColors.accentGreen
                                    : AppColors.primary)
                                .withOpacity(0.3),
                            blurRadius: 16,
                          )
                        ],
                      ),
                      child: Stack(
                        children: [
                          // Simulated Master Video Background Graphics
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  appState.isStudentFocused
                                      ? Icons.person_pin
                                      : Icons.cast_for_education,
                                  size: 80,
                                  color: (appState.isStudentFocused
                                          ? AppColors.accentGreen
                                          : AppColors.primary)
                                      .withOpacity(0.6),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  appState.isStudentFocused
                                      ? '【站立发言聚焦中】学生：${appState.focusedStudentName}'
                                      : '【名师主讲画面】张正平 特级教师 - 都市阳台东组团主教室',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  '实时分辨率: 4K 60FPS • 音视频抖动率 < 0.1% • 自动音量智能平抑',
                                  style: TextStyle(color: Colors.grey, fontSize: 12),
                                ),
                              ],
                            ),
                          ),

                          // Top Stream Overlay info
                          Positioned(
                            top: 16,
                            left: 16,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.7),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  PulseIndicator(
                                    color: appState.isStudentFocused
                                        ? AppColors.accentGreen
                                        : AppColors.accentRed,
                                    size: 10,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    appState.isStudentFocused ? '智能追焦镜头已启用' : '主讲画面 LIVE',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Speaker Focus Reset Floating Action
                          if (appState.isStudentFocused)
                            Positioned(
                              top: 16,
                              right: 16,
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.accentRed,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                icon: const Icon(Icons.close, color: Colors.white, size: 16),
                                label: const Text('重置切回名师全景', style: TextStyle(color: Colors.white)),
                                onPressed: () => appState.toggleStudentFocus(),
                              ),
                            ),

                          // Bottom Simulated Electronic Whiteboard Toolbar
                          Positioned(
                            bottom: 16,
                            left: 16,
                            right: 16,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              decoration: BoxDecoration(
                                color: AppColors.surface.withOpacity(0.85),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.cardBorder),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: const [
                                  _BoardToolIcon(Icons.edit, '电子画笔'),
                                  _BoardToolIcon(Icons.crop_square, '板书批注'),
                                  _BoardToolIcon(Icons.touch_app, '抢答点名'),
                                  _BoardToolIcon(Icons.poll, '随堂测验'),
                                  _BoardToolIcon(Icons.auto_graph, 'AI注意力打分'),
                                  _BoardToolIcon(Icons.share, '屏幕共享'),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Right Sidebar: Student Grid & Speaker Focus Controls
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        TechCard(
                          bgColor: AppColors.surface,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                '远端听课教室学生镜头 (支持点击聚焦)',
                                style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Icon(Icons.grid_view, color: AppColors.primary, size: 18),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Grid of student interactive windows
                        Expanded(
                          child: GridView.builder(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: 1.3,
                            ),
                            itemCount: _students.length,
                            itemBuilder: (context, index) {
                              final studentName = _students[index];
                              final isFocused =
                                  appState.isStudentFocused && appState.focusedStudentName == studentName;

                              return InkWell(
                                onTap: () => appState.toggleStudentFocus(studentName),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  decoration: BoxDecoration(
                                    color: AppColors.cardBg,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: isFocused ? AppColors.accentGreen : AppColors.cardBorder,
                                      width: isFocused ? 2 : 1,
                                    ),
                                    boxShadow: isFocused
                                        ? [
                                            BoxShadow(
                                              color: AppColors.accentGreen.withOpacity(0.4),
                                              blurRadius: 10,
                                            )
                                          ]
                                        : null,
                                  ),
                                  child: Stack(
                                    children: [
                                      Center(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            CircleAvatar(
                                              radius: 20,
                                              backgroundColor: isFocused
                                                  ? AppColors.accentGreen.withOpacity(0.2)
                                                  : AppColors.primary.withOpacity(0.15),
                                              child: Icon(
                                                Icons.person,
                                                color: isFocused
                                                    ? AppColors.accentGreen
                                                    : AppColors.primary,
                                              ),
                                            ),
                                            const SizedBox(height: 6),
                                            Text(
                                              studentName,
                                              style: TextStyle(
                                                color: isFocused
                                                    ? AppColors.accentGreen
                                                    : AppColors.textPrimary,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13,
                                              ),
                                            ),
                                            Text(
                                              index % 2 == 0 ? '举手请求发言' : '专注听课中',
                                              style: TextStyle(
                                                color: index % 2 == 0
                                                    ? AppColors.accentOrange
                                                    : AppColors.textMuted,
                                                fontSize: 10,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      // Focus Status Badge on thumbnail
                                      Positioned(
                                        top: 6,
                                        right: 6,
                                        child: isFocused
                                            ? const TechBadge(
                                                label: '聚焦中',
                                                color: AppColors.accentGreen,
                                              )
                                            : Container(
                                                padding: const EdgeInsets.symmetric(
                                                    horizontal: 6, vertical: 2),
                                                decoration: BoxDecoration(
                                                  color: Colors.black.withOpacity(0.5),
                                                  borderRadius: BorderRadius.circular(4),
                                                ),
                                                child: const Text(
                                                  '点击发言聚焦',
                                                  style: TextStyle(
                                                      color: AppColors.textMuted, fontSize: 9),
                                                ),
                                              ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BoardToolIcon extends StatelessWidget {
  final IconData icon;
  final String label;

  const _BoardToolIcon(this.icon, this.label);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: AppColors.primary, size: 20),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: AppColors.textPrimary, fontSize: 11),
        ),
      ],
    );
  }
}
