import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/tech_widgets.dart';

class TeachingManagementPage extends StatefulWidget {
  const TeachingManagementPage({super.key});

  @override
  State<TeachingManagementPage> createState() => _TeachingManagementPageState();
}

class _TeachingManagementPageState extends State<TeachingManagementPage> {
  int _selectedTab = 0; // 0: 巡课督导 4分屏, 1: 在线监考, 2: 作业与反馈统计

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
                      '教学管理与巡课督导中心',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '实现课堂实录、巡课督导、在线监考、作业管理与教学全流程数据统计',
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                    ),
                  ],
                ),
                const Spacer(),
                SegmentedButton<int>(
                  segments: const [
                    ButtonSegment(value: 0, label: Text('4分屏巡课督导'), icon: Icon(Icons.grid_view)),
                    ButtonSegment(value: 1, label: Text('在线监考中心'), icon: Icon(Icons.security)),
                    ButtonSegment(value: 2, label: Text('作业与反馈管理'), icon: Icon(Icons.assignment)),
                  ],
                  selected: {_selectedTab},
                  onSelectionChanged: (val) => setState(() => _selectedTab = val.first),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Tab View Body
            Expanded(
              child: _selectedTab == 0
                  ? _buildPatrolGrid()
                  : _selectedTab == 1
                      ? _buildProctoringView()
                      : _buildHomeworkManagementView(),
            ),
          ],
        ),
      ),
    );
  }

  // 4-split video patrol stream view for inspectors
  Widget _buildPatrolGrid() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text('实时巡课监控画面 (全校 6 间互动教室连线中)', style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold)),
            TechBadge(label: '督导员视角: 实时抓拍与巡查评价已就绪', color: AppColors.primary),
          ],
        ),
        const SizedBox(height: 12),
        Expanded(
          child: GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.5,
            children: [
              _buildPatrolTile('巡课1画面：高二物理专递课堂', '张正平 特级教师', '抬头率: 98% • 纪律: 优'),
              _buildPatrolTile('巡课2画面：托福口语全真模拟教室', '王雅思考官', '互动频次: 高 • 纪律: 优'),
              _buildPatrolTile('巡课3画面：名校联动微积分示范班', '清华附中共享主讲', '音画延时: 11ms'),
              _buildPatrolTile('巡课4画面：高一化学实验互动室', '陈立新 老师', '设备运转正常'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPatrolTile(String room, String teacher, String status) {
    return TechCard(
      bgColor: Colors.black,
      borderColor: AppColors.primary.withOpacity(0.4),
      child: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.videocam, size: 48, color: AppColors.primary),
                const SizedBox(height: 8),
                Text(room, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 4),
                Text(teacher, style: const TextStyle(color: Colors.grey, fontSize: 11)),
              ],
            ),
          ),
          Positioned(
            top: 10,
            left: 10,
            child: TechBadge(label: 'LIVE 巡查中', color: AppColors.accentRed, icon: Icons.fiber_manual_record),
          ),
          Positioned(
            bottom: 10,
            right: 10,
            child: TechButton(
              label: '发起督导评估听评课',
              height: 28,
              isSecondary: true,
              onPressed: () {
                showTechNoticeDialog(
                  context,
                  title: '发起督导听评课评估',
                  message: '已实时调取《$room》的督导评课打分卡，包含 6 维度教学评价指标与语音抓拍！',
                  icon: Icons.rate_review,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProctoringView() {
    return TechCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('校级托福/雅思模拟考试 - AI 在线监考大屏', style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold)),
              TechBadge(label: 'AI 异常防作弊算法运行中', color: AppColors.accentGreen),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: GridView.count(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: List.generate(6, (index) {
                final studentName = '考生 ${202601 + index}';
                return Container(
                  decoration: BoxDecoration(
                    color: AppColors.cardBg,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.cardBorder),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.face, size: 36, color: AppColors.primary),
                      const SizedBox(height: 6),
                      Text(studentName, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 12)),
                      const SizedBox(height: 4),
                      const TechBadge(label: '人脸识别匹配 100%', color: AppColors.accentGreen),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHomeworkManagementView() {
    return TechCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('作业管理与日常数据统计', style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold)),
              TechBadge(label: '本周批改完成率 98.4%', color: AppColors.primary),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              children: const [
                _HomeworkRow('高二物理第14周课后作业', '应交 142 人', '已交 140 人', '批改进度 100%'),
                _HomeworkRow('托福口语Task 3 录音作业', '应交 98 人', '已交 98 人', 'AI 批改完成 100%'),
                _HomeworkRow('名校微积分拓展专项练习', '应交 50 人', '已交 48 人', '批改进度 96%'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeworkRow extends StatelessWidget {
  final String title;
  final String s1;
  final String s2;
  final String s3;

  const _HomeworkRow(this.title, this.s1, this.s2, this.s3);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 13)),
          Row(
            children: [
              Text(s1, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
              const SizedBox(width: 12),
              Text(s2, style: const TextStyle(color: AppColors.primary, fontSize: 11)),
              const SizedBox(width: 12),
              TechBadge(label: s3, color: AppColors.accentGreen),
            ],
          ),
        ],
      ),
    );
  }
}
