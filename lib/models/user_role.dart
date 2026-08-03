enum UserRole {
  admin('系统管理员', 'Admin', '全权管理校园、用户配置与监控'),
  teacher('特级教师', 'Teacher', '创建远程课程、智能互动与评估'),
  student('示范班学生', 'Student', '参与三课堂互动、GPA查看与英语训练'),
  inspector('巡课督导员', 'Inspector', '多路画图实时巡课与教学评价');

  final String title;
  final String code;
  final String description;

  const UserRole(this.title, this.code, this.description);
}

class StudentGpaRecord {
  final String id;
  final String name;
  final String studentId;
  final String className;
  final double moralScore; // 德育 30%
  final double attendanceScore; // 考勤 20%
  final double academicScore; // 学业 50%

  StudentGpaRecord({
    required this.id,
    required this.name,
    required this.studentId,
    required this.className,
    required this.moralScore,
    required this.attendanceScore,
    required this.academicScore,
  });

  double get totalGpa {
    return (moralScore * 0.3) + (attendanceScore * 0.2) + (academicScore * 0.5);
  }

  String get level {
    final score = totalGpa;
    if (score >= 90) return '优秀 (A+)';
    if (score >= 80) return '良好 (A)';
    if (score >= 70) return '中等 (B)';
    return '合格 (C)';
  }
}
