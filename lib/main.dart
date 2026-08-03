import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';
import 'pages/login_page.dart';
import 'providers/app_state.dart';
import 'theme/app_theme.dart';
import 'widgets/main_layout.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Desktop window customization (Windows / macOS / Linux)
  if (!kIsWeb && (defaultTargetPlatform == TargetPlatform.macOS ||
      defaultTargetPlatform == TargetPlatform.windows ||
      defaultTargetPlatform == TargetPlatform.linux)) {
    await windowManager.ensureInitialized();

    WindowOptions windowOptions = const WindowOptions(
      size: Size(1360, 860),
      minimumSize: Size(1024, 700),
      center: true,
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.hidden,
    );

    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

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
