import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../theme/app_colors.dart';
import 'tech_header.dart';
import 'tech_sidebar.dart';

import '../pages/dashboard_page.dart';
import '../pages/three_classrooms_page.dart';
import '../pages/remote_classroom_page.dart';
import '../pages/classroom_evaluation_page.dart';
import '../pages/gpa_evaluation_page.dart';
import '../pages/toefl_ielts_page.dart';
import '../pages/teaching_resources_page.dart';
import '../pages/teaching_management_page.dart';

class MainLayout extends StatelessWidget {
  const MainLayout({super.key});

  static const List<Widget> _pages = [
    DashboardPage(),
    ThreeClassroomsPage(),
    RemoteClassroomPage(),
    ClassroomEvaluationPage(),
    GpaEvaluationPage(),
    ToeflIeltsPage(),
    TeachingResourcesPage(),
    TeachingManagementPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Row(
        children: [
          // Sidebar
          TechSidebar(
            selectedIndex: appState.currentNavIndex,
            onDestinationSelected: (index) => appState.setNavIndex(index),
          ),

          // Main Work Area
          Expanded(
            child: Column(
              children: [
                // Top Header
                const TechHeader(),

                // Page Content Area
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    transitionBuilder: (child, animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0.02, 0),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        ),
                      );
                    },
                    child: KeyedSubtree(
                      key: ValueKey<int>(appState.currentNavIndex),
                      child: _pages[appState.currentNavIndex.clamp(0, _pages.length - 1)],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
