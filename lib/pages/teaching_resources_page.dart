import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/tech_widgets.dart';

class TeachingResourcesPage extends StatefulWidget {
  const TeachingResourcesPage({super.key});

  @override
  State<TeachingResourcesPage> createState() => _TeachingResourcesPageState();
}

class _TeachingResourcesPageState extends State<TeachingResourcesPage> {
  String _selectedCategory = '全部资源';
  final _searchController = TextEditingController();

  static const List<String> _categories = [
    '全部资源',
    '优质课例',
    '录制微课',
    '校本资源',
    '教学资料',
    '课后服务',
    '数字资源建设',
  ];

  static const List<_ResourceItem> _allResources = [
    _ResourceItem(
      title: '高二物理《电磁感应与电磁波》特级名师示范课',
      category: '优质课例',
      author: '张正平 特级教师',
      size: '1.2 GB',
      format: '4K MP4',
      downloads: 1420,
    ),
    _ResourceItem(
      title: '托福口语 Task 1-4 满分技巧微课专题',
      category: '录制微课',
      author: '英语教研组',
      size: '350 MB',
      format: '1080P MP4',
      downloads: 980,
    ),
    _ResourceItem(
      title: '都市阳台校本教材《人工智能与智慧校园实践》',
      category: '校本资源',
      author: '校本课程开发组',
      size: '45 MB',
      format: 'PDF / PPTX',
      downloads: 2300,
    ),
    _ResourceItem(
      title: '高考数学一轮复习导学案与精准题库',
      category: '教学资料',
      author: '高三数学备课组',
      size: '80 MB',
      format: 'DOCX / PDF',
      downloads: 3100,
    ),
    _ResourceItem(
      title: '课后服务《机器人编程与无人机控制》方案',
      category: '课后服务',
      author: '创客中心',
      size: '120 MB',
      format: 'ZIP',
      downloads: 750,
    ),
    _ResourceItem(
      title: '名校联动《微积分应用案例集》数字建设资源',
      category: '数字资源建设',
      author: '清华附中共享库',
      size: '600 MB',
      format: 'H5 / MP4',
      downloads: 1890,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = _allResources.where((res) {
      final matchCat = _selectedCategory == '全部资源' || res.category == _selectedCategory;
      final matchSearch = res.title.contains(_searchController.text) || res.author.contains(_searchController.text);
      return matchCat && matchSearch;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Bar
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      '智慧教学资源中心与数字建设计划',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '包含优质课例、录制微课、校本资源、教学资料、课后服务等数字资产',
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                    ),
                  ],
                ),
                const Spacer(),
                TechButton(
                  label: '+ 上传/建设计划资源',
                  icon: Icons.cloud_upload,
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('打开资源上传与归档面板')),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Search and Category Bar
            TechCard(
              bgColor: AppColors.surface,
              child: Row(
                children: [
                  // Search box
                  Expanded(
                    flex: 2,
                    child: TextField(
                      controller: _searchController,
                      onChanged: (_) => setState(() {}),
                      style: const TextStyle(color: AppColors.textPrimary),
                      decoration: InputDecoration(
                        hintText: '搜索优质课例、微课或校本资料...',
                        hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 13),
                        prefixIcon: const Icon(Icons.search, color: AppColors.primary),
                        filled: true,
                        fillColor: AppColors.cardBg,
                        isDense: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: AppColors.cardBorder),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Category Chips
                  Expanded(
                    flex: 4,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: _categories.map((cat) {
                          final isSelected = _selectedCategory == cat;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ChoiceChip(
                              label: Text(cat),
                              selected: isSelected,
                              onSelected: (_) => setState(() => _selectedCategory = cat),
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
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Resources Grid
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.8,
                ),
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  final res = filtered[index];
                  return TechCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TechBadge(label: res.category, color: AppColors.primary),
                            Text(
                              '格式: ${res.format}',
                              style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
                            ),
                          ],
                        ),
                        Text(
                          res.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(res.author, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
                            Text('大小: ${res.size}', style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
                          ],
                        ),
                        const Divider(color: AppColors.cardBorder, height: 1),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('被引/下载: ${res.downloads}次', style: const TextStyle(color: AppColors.accentOrange, fontSize: 11)),
                            TechButton(
                              label: '在线预览 / 下载',
                              height: 30,
                              isSecondary: true,
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('已成功加载《${res.title}》资源库！')),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResourceItem {
  final String title;
  final String category;
  final String author;
  final String size;
  final String format;
  final int downloads;

  const _ResourceItem({
    required this.title,
    required this.category,
    required this.author,
    required this.size,
    required this.format,
    required this.downloads,
  });
}
