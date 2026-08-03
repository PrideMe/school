import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user_role.dart';
import '../providers/app_state.dart';
import '../theme/app_colors.dart';
import '../theme/tech_widgets.dart';

class GpaEvaluationPage extends StatefulWidget {
  const GpaEvaluationPage({super.key});

  @override
  State<GpaEvaluationPage> createState() => _GpaEvaluationPageState();
}

class _GpaEvaluationPageState extends State<GpaEvaluationPage> {
  StudentGpaRecord? _selectedRecord;

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final records = appState.gpaRecords;
    _selectedRecord ??= records.first;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      '学生 GPA 综合评估档案系统',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '加权公式：GPA = 德育(30%) + 考勤(20%) + 学业(50%) • 支持多角色协同打分与加权自动算分',
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                    ),
                  ],
                ),
                const Spacer(),
                TechButton(
                  label: '+ 录入/更新加权评分',
                  icon: Icons.edit_note,
                  onPressed: () => _showEditScoreDialog(context, _selectedRecord!),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Top Weight Formula Indicator Card
            TechCard(
              bgColor: AppColors.surface,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: const [
                    _WeightChip('德育评估 (Moral)', '30%', AppColors.primary, Icons.workspace_premium),
                    SizedBox(width: 8),
                    Icon(Icons.add, color: AppColors.textMuted),
                    SizedBox(width: 8),
                    _WeightChip('考勤纪律 (Attendance)', '20%', AppColors.accentGreen, Icons.event_available),
                    SizedBox(width: 8),
                    Icon(Icons.add, color: AppColors.textMuted),
                    SizedBox(width: 8),
                    _WeightChip('学业成绩 (Academic)', '50%', AppColors.secondary, Icons.menu_book),
                    SizedBox(width: 8),
                    Icon(Icons.drag_handle, color: AppColors.textMuted),
                    SizedBox(width: 8),
                    _WeightChip('系统加权 GPA 档案', '100%', AppColors.accentOrange, Icons.stars),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Main Content Split View
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left Student Records Table
                  Expanded(
                    flex: 3,
                    child: TechCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                '学生 GPA 档案名册',
                                style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TechBadge(
                                label: '共 ${records.length} 名示范班学生',
                                color: AppColors.primary,
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: DataTable(
                                  headingRowColor: MaterialStateProperty.all(AppColors.surface),
                                  dataRowColor: MaterialStateProperty.resolveWith(
                                    (states) => AppColors.cardBg,
                                  ),
                                  columns: const [
                                    DataColumn(label: Text('学号/姓名', style: TextStyle(color: AppColors.primary))),
                                    DataColumn(label: Text('班级', style: TextStyle(color: AppColors.textSecondary))),
                                    DataColumn(label: Text('德育(30%)', style: TextStyle(color: AppColors.textSecondary))),
                                    DataColumn(label: Text('考勤(20%)', style: TextStyle(color: AppColors.textSecondary))),
                                    DataColumn(label: Text('学业(50%)', style: TextStyle(color: AppColors.textSecondary))),
                                    DataColumn(label: Text('加权 GPA', style: TextStyle(color: AppColors.accentOrange))),
                                    DataColumn(label: Text('评级档案', style: TextStyle(color: AppColors.accentGreen))),
                                  ],
                                  rows: records.map((record) {
                                    final isSelected = _selectedRecord?.id == record.id;
                                    return DataRow(
                                      selected: isSelected,
                                      onSelectChanged: (_) {
                                        setState(() => _selectedRecord = record);
                                      },
                                      cells: [
                                        DataCell(
                                          Row(
                                            children: [
                                              CircleAvatar(
                                                radius: 12,
                                                backgroundColor: AppColors.primary.withOpacity(0.2),
                                                child: const Icon(Icons.person, size: 14, color: AppColors.primary),
                                              ),
                                              const SizedBox(width: 8),
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(record.name, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
                                                  Text(record.studentId, style: const TextStyle(color: AppColors.textMuted, fontSize: 10)),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        DataCell(Text(record.className, style: const TextStyle(color: AppColors.textSecondary))),
                                        DataCell(Text('${record.moralScore} 分', style: const TextStyle(color: AppColors.textPrimary))),
                                        DataCell(Text('${record.attendanceScore} 分', style: const TextStyle(color: AppColors.textPrimary))),
                                        DataCell(Text('${record.academicScore} 分', style: const TextStyle(color: AppColors.textPrimary))),
                                        DataCell(
                                          Text(
                                            record.totalGpa.toStringAsFixed(2),
                                            style: const TextStyle(
                                              color: AppColors.accentOrange,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                        DataCell(TechBadge(label: record.level, color: AppColors.accentGreen)),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Right Selected Student Detailed Breakdown & Radar Card
                  Expanded(
                    flex: 2,
                    child: TechCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '【${_selectedRecord!.name}】GPA 档案明细',
                                style: const TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TechBadge(label: _selectedRecord!.studentId, color: AppColors.primary),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Calculation Process Display
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppColors.cardBorder),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  '加权计算公式明细:',
                                  style: TextStyle(color: AppColors.textSecondary, fontSize: 11),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  '(${_selectedRecord!.moralScore} × 0.3) + (${_selectedRecord!.attendanceScore} × 0.2) + (${_selectedRecord!.academicScore} × 0.5)',
                                  style: const TextStyle(
                                    color: AppColors.primary,
                                    fontFamily: 'monospace',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('自动计算加权分:', style: TextStyle(color: AppColors.textPrimary, fontSize: 12)),
                                    Text(
                                      '${_selectedRecord!.totalGpa.toStringAsFixed(2)} / 100.0',
                                      style: const TextStyle(
                                        color: AppColors.accentOrange,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Student Radar Chart
                          Center(
                            child: TechRadarChart(
                              categories: const ['德育30%', '考勤20%', '学业50%', '综合素养', '体育健康'],
                              values: [
                                _selectedRecord!.moralScore / 100.0,
                                _selectedRecord!.attendanceScore / 100.0,
                                _selectedRecord!.academicScore / 100.0,
                                0.92,
                                0.88,
                              ],
                              color: AppColors.accentOrange,
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

  void _showEditScoreDialog(BuildContext context, StudentGpaRecord record) {
    final appState = Provider.of<AppState>(context, listen: false);
    final moralCtrl = TextEditingController(text: record.moralScore.toString());
    final attendCtrl = TextEditingController(text: record.attendanceScore.toString());
    final acadCtrl = TextEditingController(text: record.academicScore.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('录入/评分：${record.name} (${record.className})', style: const TextStyle(color: AppColors.textPrimary)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '支持管理者、值班老师、学科老师、班主任多角色打分：',
                style: TextStyle(color: AppColors.textMuted, fontSize: 12),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: moralCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: '德育评分 (权重 30%)',
                  labelStyle: TextStyle(color: AppColors.textSecondary),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: attendCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: '考勤纪律 (权重 20%)',
                  labelStyle: TextStyle(color: AppColors.textSecondary),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: acadCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: '学业成绩 (权重 50%)',
                  labelStyle: TextStyle(color: AppColors.textSecondary),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('取消'),
            ),
            TechButton(
              label: '保存并重新计算 GPA',
              onPressed: () {
                final m = double.tryParse(moralCtrl.text) ?? record.moralScore;
                final at = double.tryParse(attendCtrl.text) ?? record.attendanceScore;
                final ac = double.tryParse(acadCtrl.text) ?? record.academicScore;

                appState.updateStudentGpa(record.id, m, at, ac);
                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('已重新计算【${record.name}】的加权GPA档案！')),
                );
              },
            ),
          ],
        );
      },
    );
  }
}

class _WeightChip extends StatelessWidget {
  final String title;
  final String weight;
  final Color color;
  final IconData icon;

  const _WeightChip(this.title, this.weight, this.color, this.icon);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title, style: const TextStyle(color: AppColors.textPrimary, fontSize: 12, fontWeight: FontWeight.bold)),
            Text('权重 $weight', style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w600)),
          ],
        ),
      ],
    );
  }
}
