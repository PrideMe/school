import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/tech_widgets.dart';

class ClassroomEvaluationPage extends StatelessWidget {
  const ClassroomEvaluationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Page Header
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'AI 课堂评估与数据报告中心',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '系统自动追踪多维互动过程，实时演算课程综合教学质量得分',
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                    ),
                  ],
                ),
                const Spacer(),
                TechButton(
                  label: '导出完整 PDF 评估档案',
                  icon: Icons.picture_as_pdf,
                  onPressed: () {
                    showTechNoticeDialog(
                      context,
                      title: 'PDF 档案导出成功',
                      message: '已成功生成并导出《高二物理远程互动课堂评估报告.pdf》至本地归档目录！',
                      icon: Icons.picture_as_pdf,
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Top Metrics Overview Row
            Row(
              children: [
                _buildEvalScoreCard('课程综合得分', '94.8', '优秀 (A+级)', AppColors.primary),
                const SizedBox(width: 16),
                _buildEvalScoreCard('学生平均参与度', '92.5%', '全班均分对比 +4.2%', AppColors.accentGreen),
                const SizedBox(width: 16),
                _buildEvalScoreCard('师生实时互动次数', '48 次', '涵盖举手/点名/抢答', AppColors.secondary),
                const SizedBox(width: 16),
                _buildEvalScoreCard('随堂测验正确率', '88.6%', '目标达成度优秀', AppColors.accentOrange),
              ],
            ),
            const SizedBox(height: 24),

            // Middle Detailed Analysis Area
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left Radar Chart Card
                  Expanded(
                    flex: 2,
                    child: TechCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                '课堂多维度评分雷达图',
                                style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TechBadge(label: 'AI 自动多维评价', color: AppColors.primary),
                            ],
                          ),
                          const SizedBox(height: 20),
                          const Center(
                            child: TechRadarChart(
                              categories: ['学生参与度', '互动频次', '教师授课表现', '教学目标达成', '课堂氛围', '技术传输流畅度'],
                              values: [0.93, 0.88, 0.96, 0.90, 0.92, 0.98],
                              color: AppColors.primary,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppColors.cardBorder),
                            ),
                            child: Row(
                              children: const [
                                Icon(Icons.psychology, color: AppColors.primary, size: 20),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    'AI 智能建议：本节课互动氛围热烈，建议在后半程适当增加分组讨论环节，进一步提升听课效率。',
                                    style: TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 11,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Right Detailed Score Breakdown List
                  Expanded(
                    flex: 3,
                    child: TechCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                '课程评价指标明细 (高二物理专递课堂)',
                                style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '主讲：张正平 特级教师',
                                style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Expanded(
                            child: ListView(
                              children: const [
                                _EvalProgressRow(
                                  title: '学生专注度与抬头率',
                                  score: '96分',
                                  percent: 0.96,
                                  color: AppColors.accentGreen,
                                ),
                                _EvalProgressRow(
                                  title: '站立发言与视频聚焦匹配率',
                                  score: '100分',
                                  percent: 1.0,
                                  color: AppColors.primary,
                                ),
                                _EvalProgressRow(
                                  title: '随堂测试答题完成度',
                                  score: '91分',
                                  percent: 0.91,
                                  color: AppColors.secondary,
                                ),
                                _EvalProgressRow(
                                  title: '教师板书与多媒体融合度',
                                  score: '94分',
                                  percent: 0.94,
                                  color: AppColors.accentBlue,
                                ),
                                _EvalProgressRow(
                                  title: '城乡远端互动延时平稳度',
                                  score: '98分',
                                  percent: 0.98,
                                  color: AppColors.accentCyan,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
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

  Widget _buildEvalScoreCard(String title, String value, String sub, Color color) {
    return Expanded(
      child: TechCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              sub,
              style: const TextStyle(color: AppColors.textMuted, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}

class _EvalProgressRow extends StatelessWidget {
  final String title;
  final String score;
  final double percent;
  final Color color;

  const _EvalProgressRow({
    required this.title,
    required this.score,
    required this.percent,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                score,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percent,
              minHeight: 8,
              backgroundColor: AppColors.cardBorder,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }
}
