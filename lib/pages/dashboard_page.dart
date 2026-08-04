import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../theme/app_colors.dart';
import '../theme/tech_widgets.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Page Header Banner
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Flexible(
                            child: Text(
                              '智慧校园驾驶舱看板',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          TechBadge(
                            label: '视角: ${appState.currentRole.title}',
                            color: AppColors.primary,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        '实时监控三个课堂、远程互动授课、GPA档案与全校教学资源调度状态',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                TechButton(
                  label: '快捷发起互动课堂',
                  icon: Icons.add_to_queue,
                  onPressed: () => appState.setNavIndex(2),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Top Stat Cards Row
            Row(
              children: [
                _buildStatCard(
                  '今日课程总数',
                  '${appState.todayCoursesCount} 门',
                  '包含专递/名师/名校课堂',
                  Icons.auto_stories,
                  AppColors.primary,
                ),
                const SizedBox(width: 16),
                _buildStatCard(
                  '在线互动课堂',
                  '${appState.activeLiveRooms} 间',
                  '5G 高清音画同步中',
                  Icons.sensors,
                  AppColors.accentGreen,
                  hasPulse: true,
                ),
                const SizedBox(width: 16),
                _buildStatCard(
                  '互动生源基数',
                  '${appState.totalStudents} 人',
                  '覆盖都市阳台示范各班',
                  Icons.groups,
                  AppColors.secondary,
                ),
                const SizedBox(width: 16),
                _buildStatCard(
                  '智慧名师储备',
                  '${appState.totalTeachers} 人',
                  '特级/名师指导教师',
                  Icons.psychology,
                  AppColors.accentOrange,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Middle Main Visualization Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Real-time Class Stream Status Monitor
                Expanded(
                  flex: 3,
                  child: TechCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Expanded(
                              child: Text(
                                '实时课堂互动热度与参与度分布',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            TechBadge(label: '实时算法计算中', color: AppColors.primary),
                          ],
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 200,
                          child: CustomPaint(
                            size: Size.infinite,
                            painter: _ChartPainter(),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: const [
                              _LegendItem(label: '专递课堂参与度', color: AppColors.primary),
                              SizedBox(width: 12),
                              _LegendItem(label: '名师课堂互动率', color: AppColors.secondary),
                              SizedBox(width: 12),
                              _LegendItem(label: '名校资源播放数', color: AppColors.accentGreen),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Radar Analysis Card
                Expanded(
                  flex: 2,
                  child: TechCard(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Expanded(
                              child: Text(
                                '全校综合教学评估',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Icon(Icons.pie_chart, color: AppColors.primary, size: 18),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const TechRadarChart(
                          categories: ['德育评分', '考勤出勤', '学业 GPA', '互动频率', 'AI 批改分'],
                          values: [0.92, 0.96, 0.88, 0.85, 0.90],
                          color: AppColors.primary,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Bottom Active Classrooms Grid
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  '正在进行的三个课堂与互动实况',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '查看全部 18 间教室 >',
                  style: TextStyle(color: AppColors.primary, fontSize: 13),
                ),
              ],
            ),
            const SizedBox(height: 12),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 2.2,
              children: [
                _buildLiveRoomItem(
                  context,
                  '高二物理《量子力学基础》',
                  '主讲：张名师 (都市阳台东校区)',
                  '专递课堂 • 正在授课',
                  AppColors.primary,
                ),
                _buildLiveRoomItem(
                  context,
                  '托福口语真题精讲与智能评测',
                  '主讲：王雅思考官',
                  '英语训练 • 学生互动中',
                  AppColors.secondary,
                ),
                _buildLiveRoomItem(
                  context,
                  '名校联动《高等数学微积分》',
                  '共享院校：清华附中示范班',
                  '名校课堂 • 5G直播',
                  AppColors.accentGreen,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    String subtitle,
    IconData icon,
    Color color, {
    bool hasPulse = false,
  }) {
    return Expanded(
      child: TechCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Icon(icon, color: color, size: 20),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                if (hasPulse) ...[
                  PulseIndicator(color: color, size: 10),
                  const SizedBox(width: 8),
                ],
                Text(
                  value,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: color.withOpacity(0.5),
                        blurRadius: 8,
                      )
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLiveRoomItem(
    BuildContext context,
    String title,
    String teacher,
    String tag,
    Color color,
  ) {
    return TechCard(
      onTap: () {
        final appState = Provider.of<AppState>(context, listen: false);
        appState.setNavIndex(2); // Jump to remote classroom
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(child: TechBadge(label: tag, color: color)),
              const SizedBox(width: 4),
              const Icon(Icons.play_circle_fill, color: AppColors.primary, size: 16),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              Text(
                teacher,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final String label;
  final Color color;

  const _LegendItem({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 11),
        ),
      ],
    );
  }
}

class _ChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p1 = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    final p2 = Paint()
      ..color = AppColors.secondary
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final path1 = Path();
    final path2 = Path();

    final width = size.width;
    final height = size.height;

    path1.moveTo(0, height * 0.7);
    path1.quadraticBezierTo(width * 0.2, height * 0.2, width * 0.4, height * 0.5);
    path1.quadraticBezierTo(width * 0.6, height * 0.8, width * 0.8, height * 0.3);
    path1.lineTo(width, height * 0.4);

    path2.moveTo(0, height * 0.5);
    path2.quadraticBezierTo(width * 0.3, height * 0.8, width * 0.5, height * 0.3);
    path2.quadraticBezierTo(width * 0.7, height * 0.1, width * 0.9, height * 0.6);
    path2.lineTo(width, height * 0.5);

    canvas.drawPath(path1, p1);
    canvas.drawPath(path2, p2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
