import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages/login_page.dart';
import 'providers/app_state.dart';
import 'theme/app_theme.dart';
import 'widgets/main_layout.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppState()),
      ],
      child: const SmartEducationApp(),
    ),
  );
}

class SmartEducationApp extends StatelessWidget {
  const SmartEducationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '智慧教育远程互动教学系统',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: Consumer<AppState>(
        builder: (context, appState, child) {
          if (!appState.isLoggedIn) {
            return const LoginPage();
          }
          return const MainLayout();
        },
      ),
    );
  }
}
