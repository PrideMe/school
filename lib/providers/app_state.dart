import 'package:flutter/material.dart';
import '../models/user_role.dart';

class AppState extends ChangeNotifier {
  // Navigation State
  int _currentNavIndex = 0;
  int get currentNavIndex => _currentNavIndex;

  void setNavIndex(int index) {
    _currentNavIndex = index;
    notifyListeners();
  }

  // User Role State
  UserRole _currentRole = UserRole.admin;
  UserRole get currentRole => _currentRole;

  bool _isLoggedIn = true;
  bool get isLoggedIn => _isLoggedIn;

  void switchRole(UserRole role) {
    _currentRole = role;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    notifyListeners();
  }

  void login(UserRole role) {
    _currentRole = role;
    _isLoggedIn = true;
    _currentNavIndex = 0;
    notifyListeners();
  }

  // Interactive Remote Classroom Focus State
  bool _isStudentFocused = false;
  bool get isStudentFocused => _isStudentFocused;

  String _focusedStudentName = '李小明';
  String get focusedStudentName => _focusedStudentName;

  bool _isRecording = false;
  bool get isRecording => _isRecording;

  void toggleStudentFocus([String name = '李小明']) {
    if (_isStudentFocused && _focusedStudentName == name) {
      _isStudentFocused = false;
    } else {
      _isStudentFocused = true;
      _focusedStudentName = name;
    }
    notifyListeners();
  }

  void toggleRecording() {
    _isRecording = !_isRecording;
    notifyListeners();
  }

  // Active Teaching Application Mode (Local / Interactive)
  String _activeTeachingMode = '智慧课堂';
  String get activeTeachingMode => _activeTeachingMode;

  void setTeachingMode(String mode) {
    _activeTeachingMode = mode;
    notifyListeners();
  }

  // Mock GPA Records List
  final List<StudentGpaRecord> _gpaRecords = [
    StudentGpaRecord(
      id: '1',
      name: '李华',
      studentId: '20260101',
      className: '高二示范1班',
      moralScore: 95.0,
      attendanceScore: 98.0,
      academicScore: 92.5,
    ),
    StudentGpaRecord(
      id: '2',
      name: '张婷婷',
      studentId: '20260102',
      className: '高二示范1班',
      moralScore: 90.0,
      attendanceScore: 95.0,
      academicScore: 96.0,
    ),
    StudentGpaRecord(
      id: '3',
      name: '陈王伟',
      studentId: '20260103',
      className: '高二示范2班',
      moralScore: 88.0,
      attendanceScore: 92.0,
      academicScore: 85.0,
    ),
    StudentGpaRecord(
      id: '4',
      name: '林美惠',
      studentId: '20260104',
      className: '高一双语班',
      moralScore: 96.0,
      attendanceScore: 100.0,
      academicScore: 94.0,
    ),
    StudentGpaRecord(
      id: '5',
      name: '刘浩宇',
      studentId: '20260105',
      className: '高三冲刺1班',
      moralScore: 85.0,
      attendanceScore: 90.0,
      academicScore: 89.0,
    ),
  ];

  List<StudentGpaRecord> get gpaRecords => List.unmodifiable(_gpaRecords);

  void updateStudentGpa(String id, double moral, double attendance, double academic) {
    final idx = _gpaRecords.indexWhere((r) => r.id == id);
    if (idx != -1) {
      final old = _gpaRecords[idx];
      _gpaRecords[idx] = StudentGpaRecord(
        id: old.id,
        name: old.name,
        studentId: old.studentId,
        className: old.className,
        moralScore: moral,
        attendanceScore: attendance,
        academicScore: academic,
      );
      notifyListeners();
    }
  }

  // System Stats
  int todayCoursesCount = 18;
  int activeLiveRooms = 6;
  int totalStudents = 1420;
  int totalTeachers = 98;
}
