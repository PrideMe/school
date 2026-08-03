import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../theme/app_colors.dart';
import '../theme/tech_widgets.dart';

class ThreeClassroomsPage extends StatefulWidget {
  const ThreeClassroomsPage({super.key});

  @override
  State<ThreeClassroomsPage> createState() => _ThreeClassroomsPageState();
}

class _ThreeClassroomsPageState extends State<ThreeClassroomsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        '“三个课堂”智慧教学平台',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '包含专递课堂、名师课堂、名校课堂，促进教育均衡与优质资源共建共享',
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
                  label: '+ 排定开播新课堂',
                  icon: Icons.video_call,
                  onPressed: () => _showCreateClassroomDialog(context),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Tab Bar Switcher
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: TabBar(
                controller: _tabController,
                indicatorColor: AppColors.primary,
                indicatorWeight: 3,
                labelColor: AppColors.primary,
                unselectedLabelColor: AppColors.textSecondary,
                labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                tabs: const [
                  Tab(
                    icon: Icon(Icons.sync_alt),
                    text: '专递课堂 (城乡同步)',
                  ),
                  Tab(
                    icon: Icon(Icons.star),
                    text: '名师课堂 (示范辐射)',
                  ),
                  Tab(
                    icon: Icon(Icons.account_balance),
                    text: '名校课堂 (资源共享)',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Tab View Body
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildZhuandiClassroomTab(appState),
                  _buildMingshiClassroomTab(appState),
                  _buildMingxiaoClassroomTab(appState),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildZhuandiClassroomTab(AppState appState) {
    return ListView(
      children: [
        _buildInfoBanner(
          '专递课堂',
          '主要针对农村及边远地区开齐开足开好国家规定课程的需求，采用“一对多”实时互动教学，实现城乡学校同步授课。',
          Icons.sync_alt,
          AppColors.primary,
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.8,
          children: [
            _buildClassroomCard(
              title: '高二物理《电磁感应与远距离输电》',
              teacher: '主讲：张正平 (都市阳台东组团中心校区)',
              targetSchools: '连线学校：临沂第十中学、郯城乡村示范校区',
              status: '正在直播 (5G高清画质)',
              isLive: true,
              participants: '142 名学生集中听课',
            ),
            _buildClassroomCard(
              title: '初三英语《Listening & Oral Practice》',
              teacher: '主讲：Sarah Smith (外籍特聘名师)',
              targetSchools: '连线学校：沂南第一初级中学',
              status: '正在直播 (智能语音聚焦)',
              isLive: true,
              participants: '98 名学生互动中',
            ),
            _buildClassroomCard(
              title: '高一化学《元素周期律与实验探究》',
              teacher: '主讲：陈立新 (高级化学教师)',
              targetSchools: '连线学校：平邑二中示范班',
              status: '预约开播 (明日 09:00)',
              isLive: false,
              participants: '预定人数：120 人',
            ),
            _buildClassroomCard(
              title: '小学音乐《唱响未来》艺术专递',
              teacher: '主讲：李梦雪 (省艺术骨干教师)',
              targetSchools: '连线学校：高新区3所乡村小学',
              status: '课程已录制 (回放生成中)',
              isLive: false,
              participants: '录制时长：45分钟',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMingshiClassroomTab(AppState appState) {
    return ListView(
      children: [
        _buildInfoBanner(
          '名师课堂',
          '汇聚省市级特级名师、智慧教育领军人才，通过名师授课、在线研修、智慧教学设计指导，带动广大青年教师提升教学水平。',
          Icons.star,
          AppColors.secondary,
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.8,
          children: [
            _buildClassroomCard(
              title: '特级教师示范课《PBL项目式学习设计》',
              teacher: '主讲：刘建国 (全国优秀教师、省特级)',
              targetSchools: '研讨主题：智慧教育课堂教学设计与AI融合',
              status: '名师直播研讨中',
              isLive: true,
              participants: '听课评课教师：54 人',
            ),
            _buildClassroomCard(
              title: '数学解题思维剖析与智慧考情研判',
              teacher: '主讲：孙伟华 (国家级名师工作室领衔人)',
              targetSchools: '面向区域：全市高中数学教研组',
              status: '精彩回播中',
              isLive: false,
              participants: '累计观看：1,890 次',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMingxiaoClassroomTab(AppState appState) {
    return ListView(
      children: [
        _buildInfoBanner(
          '名校课堂',
          '依托都市阳台国际学校及清华附中、实验中学等名校优质数字教育资源，打破校际壁垒，实现优质课程网络化全覆盖。',
          Icons.account_balance,
          AppColors.accentGreen,
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.8,
          children: [
            _buildClassroomCard(
              title: '名校共享《人工智能与Python编程实战》',
              teacher: '联合授课：清华附中创客中心 team',
              targetSchools: '共享院校：都市阳台东组团示范校区',
              status: '名校资源共享中',
              isLive: true,
              participants: '共享班级：8 个',
            ),
            _buildClassroomCard(
              title: '国际化前沿讲坛《跨文化交流与拓宽国际视野》',
              teacher: '主讲：Dr. Alexander (国际教育学院院长)',
              targetSchools: '面向校区：全校师生及家长',
              status: '回放已沉淀',
              isLive: false,
              participants: '资源评级：5.0 ★★★★★',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoBanner(String title, String desc, IconData icon, Color color) {
    return TechCard(
      bgColor: color.withOpacity(0.08),
      borderColor: color.withOpacity(0.4),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: color.withOpacity(0.2), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: color,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  desc,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClassroomCard({
    required String title,
    required String teacher,
    required String targetSchools,
    required String status,
    required bool isLive,
    required String participants,
  }) {
    return TechCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TechBadge(
                label: status,
                color: isLive ? AppColors.accentRed : AppColors.primary,
                icon: isLive ? Icons.live_tv : Icons.event_note,
              ),
              Text(
                participants,
                style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
              ),
            ],
          ),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            teacher,
            style: const TextStyle(color: AppColors.primary, fontSize: 12),
          ),
          Text(
            targetSchools,
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 11),
          ),
          const Divider(color: AppColors.cardBorder, height: 1),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TechButton(
                label: isLive ? '进入实时互动直播' : '查看课程详情与教案',
                isSecondary: !isLive,
                height: 34,
                onPressed: () {
                  final appState = Provider.of<AppState>(context, listen: false);
                  appState.setNavIndex(2); // Jump to interactive classroom
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showCreateClassroomDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return TechDialog(
          title: '排定“三个课堂”新课程日程',
          icon: Icons.video_call,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              TextField(
                decoration: InputDecoration(
                  labelText: '课程名称',
                  labelStyle: TextStyle(color: AppColors.textSecondary),
                  prefixIcon: Icon(Icons.class_, color: AppColors.primary, size: 20),
                ),
              ),
              SizedBox(height: 12),
              TextField(
                decoration: InputDecoration(
                  labelText: '主讲名师',
                  labelStyle: TextStyle(color: AppColors.textSecondary),
                  prefixIcon: Icon(Icons.person, color: AppColors.primary, size: 20),
                ),
              ),
              SizedBox(height: 12),
              TextField(
                decoration: InputDecoration(
                  labelText: '同步连线教室 / 联培学校',
                  labelStyle: TextStyle(color: AppColors.textSecondary),
                  prefixIcon: Icon(Icons.school, color: AppColors.primary, size: 20),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('取消', style: TextStyle(color: AppColors.textMuted)),
            ),
            const SizedBox(width: 8),
            TechButton(
              label: '立即创建并广播',
              onPressed: () {
                Navigator.pop(context);
                showTechNoticeDialog(
                  context,
                  title: '新“三个课堂”日程已创建',
                  message: '成功排定新课程日程，已完成连线教室推流广播与全网课表同步！',
                  icon: Icons.video_call,
                );
              },
            ),
          ],
        );
      },
    );
  }
}
