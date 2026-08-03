import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/tech_widgets.dart';

class ToeflIeltsPage extends StatefulWidget {
  const ToeflIeltsPage({super.key});

  @override
  State<ToeflIeltsPage> createState() => _ToeflIeltsPageState();
}

class _ToeflIeltsPageState extends State<ToeflIeltsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isAiEvaluating = false;
  String? _evaluationReport;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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
                      '托福 / 雅思智能化试题训练与全真模拟考试系统',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '收录历年真题（口语、听力、阅读、写作）• AI 智能语音与写作实时批改引擎',
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                    ),
                  ],
                ),
                const Spacer(),
                TechButton(
                  label: '开启全校模拟托福/雅思考试',
                  icon: Icons.assignment_outlined,
                  onPressed: () => _startMockExamDialog(context),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Tab Bar
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: TabBar(
                controller: _tabController,
                indicatorColor: AppColors.primary,
                labelColor: AppColors.primary,
                unselectedLabelColor: AppColors.textSecondary,
                labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                tabs: const [
                  Tab(icon: Icon(Icons.mic), text: '口语训练 (Speaking)'),
                  Tab(icon: Icon(Icons.headphones), text: '听力真题 (Listening)'),
                  Tab(icon: Icon(Icons.menu_book), text: '阅读理解 (Reading)'),
                  Tab(icon: Icon(Icons.edit_note), text: '写作批改 (Writing)'),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Main Tab View Area
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildSpeakingSection(),
                  _buildListeningSection(),
                  _buildReadingSection(),
                  _buildWritingSection(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpeakingSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left Prompt & Recorder Card
        Expanded(
          flex: 3,
          child: TechCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    TechBadge(label: 'TOEFL Speaking Task 2 真题精选', color: AppColors.primary),
                    Text('限时作答：45 秒', style: TextStyle(color: AppColors.accentOrange, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Question: Some people prefer to take courses online, while others prefer to attend classes in a traditional classroom setting. Which do you prefer and why?',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),

                // Simulated Voice Waveform Box
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.cardBorder),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.graphic_eq, size: 60, color: AppColors.primary),
                        const SizedBox(height: 12),
                        const Text(
                          '语音录制完成 • 时长 42 秒 (音频流已安全加密传输)',
                          style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                        ),
                        const SizedBox(height: 20),
                        TechButton(
                          label: _isAiEvaluating ? 'AI 智能分析演算中...' : '提交给 AI 考官进行多维批改',
                          icon: Icons.psychology,
                          onPressed: () {
                            setState(() {
                              _isAiEvaluating = true;
                              _evaluationReport = null;
                            });
                            Future.delayed(const Duration(seconds: 1), () {
                              if (mounted) {
                                setState(() {
                                  _isAiEvaluating = false;
                                  _evaluationReport = 'Evaluated';
                                });
                              }
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),

        // Right AI Analysis Result Panel
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
                      'AI 口语智能批改报告',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TechBadge(label: '托福口语 Band Score', color: AppColors.accentGreen),
                  ],
                ),
                const SizedBox(height: 16),

                if (_isAiEvaluating)
                  const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(color: AppColors.primary),
                    ),
                  )
                else
                  Expanded(
                    child: ListView(
                      children: [
                        if (_evaluationReport != null)
                          Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.accentGreen.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppColors.accentGreen),
                            ),
                            child: Row(
                              children: const [
                                Icon(Icons.check_circle, color: AppColors.accentGreen, size: 18),
                                SizedBox(width: 8),
                                Text('AI 引擎评估完成！系统已自动生成多维考情诊断。',
                                    style: TextStyle(color: AppColors.accentGreen, fontSize: 11, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        _buildAiScoreMetric('预估得分', '26 / 30 分', 'Good Level', AppColors.primary),
                        const Divider(color: AppColors.cardBorder, height: 20),
                        _buildAiScoreMetric('Pronunciation (发音清晰度)', '88%', '重音连读标准', AppColors.accentGreen),
                        _buildAiScoreMetric('Fluency (语速与停顿)', '92%', '无不必要停顿', AppColors.accentBlue),
                        _buildAiScoreMetric('Lexical Diversity (词汇丰富度)', '85%', '使用高阶词汇 6 个', AppColors.secondary),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.cardBorder),
                          ),
                          child: const Text(
                            '考官评语：论据表达清晰，逻辑连贯。建议在表达中增强连接词（Furthermore, On the other hand）的使用以获得更高得分。',
                            style: TextStyle(color: AppColors.textSecondary, fontSize: 11),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildListeningSection() {
    return TechCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('雅思听力真题 Test 4 - Section 3 (University Campus Conversation)',
                  style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold)),
              TechBadge(label: '音频播放中 • 1.0X', color: AppColors.primary),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(10)),
            child: Row(
              children: const [
                Icon(Icons.play_arrow, color: AppColors.primary, size: 36),
                SizedBox(width: 12),
                Expanded(
                  child: LinearProgressIndicator(value: 0.45, backgroundColor: AppColors.cardBorder, color: AppColors.primary),
                ),
                SizedBox(width: 12),
                Text('02:15 / 05:00', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text('1. What is the main purpose of the student\'s visit to the advisor?', style: TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const _ChoiceOption('A. To request an extension for the final essay project', true),
          const _ChoiceOption('B. To change her major field of study', false),
          const _ChoiceOption('C. To apply for a research assistant position', false),
        ],
      ),
    );
  }

  Widget _buildReadingSection() {
    return TechCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('TOEFL Reading Passage: The Evolution of Ancient Architecture', style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold)),
          SizedBox(height: 12),
          Text(
            'Architectural forms in ancient civilizations evolved as a direct response to climatic conditions, available building materials, and cultural values. In Mesopotamia, where stone was scarce, sun-dried mud bricks formed the primary structural material...',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13, height: 1.5),
          ),
          Spacer(),
          TechBadge(label: '智能生词标注与智能题目对答案已开启', color: AppColors.accentGreen),
        ],
      ),
    );
  }

  Widget _buildWritingSection() {
    return TechCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('雅思写作 Task 2 智能高分作文批改', style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold)),
              TechBadge(label: '语法错误: 0 个 | 词汇等级: C1', color: AppColors.accentGreen),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Student Essay Submission:\n"Technology has fundamentally altered the paradigm of modern education. By enabling synchronous distant learning, students in remote regions can now access premium academic resources..."',
            style: TextStyle(color: AppColors.textPrimary, fontSize: 13, fontStyle: FontStyle.italic),
          ),
          const Spacer(),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: const [
                TechBadge(label: 'Task Response: 8.5', color: AppColors.primary),
                SizedBox(width: 8),
                TechBadge(label: 'Coherence & Cohesion: 8.0', color: AppColors.secondary),
                SizedBox(width: 8),
                TechBadge(label: 'Lexical Resource: 8.5', color: AppColors.accentOrange),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAiScoreMetric(String title, String score, String tag, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
          Row(
            children: [
              Text(score, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(width: 6),
              TechBadge(label: tag, color: color),
            ],
          ),
        ],
      ),
    );
  }

  void _startMockExamDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return TechDialog(
          title: '启动全校/年级托福模拟考试',
          icon: Icons.quiz,
          content: const Text(
            '系统将自动发放全真考试试卷，并监控考生答题行为及实时智能批改。是否确认立即发布？',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('取消', style: TextStyle(color: AppColors.textMuted)),
            ),
            const SizedBox(width: 8),
            TechButton(
              label: '开始发布模拟考试',
              onPressed: () {
                Navigator.pop(context);
                showTechNoticeDialog(
                  context,
                  title: '模考任务发布成功',
                  message: '已成功发布全校托福/雅思全真模拟考试，并同步开启 AI 抓拍与智能考场监测！',
                  icon: Icons.quiz,
                );
              },
            ),
          ],
        );
      },
    );
  }
}

class _ChoiceOption extends StatelessWidget {
  final String text;
  final bool isSelected;

  const _ChoiceOption(this.text, this.isSelected);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary.withOpacity(0.15) : AppColors.cardBg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: isSelected ? AppColors.primary : AppColors.cardBorder),
      ),
      child: Row(
        children: [
          Icon(isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
              color: isSelected ? AppColors.primary : AppColors.textMuted, size: 18),
          const SizedBox(width: 10),
          Text(text, style: TextStyle(color: isSelected ? AppColors.primary : AppColors.textPrimary, fontSize: 13)),
        ],
      ),
    );
  }
}
