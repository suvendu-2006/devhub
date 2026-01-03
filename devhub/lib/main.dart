import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/theme/app_theme.dart';
import 'core/services/storage_service.dart';
import 'core/services/bookmark_service.dart';
import 'features/community/services/profile_service.dart';
import 'features/progress/services/progress_service.dart';
import 'shared/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize storage services
  await StorageService.init();
  final prefs = await SharedPreferences.getInstance();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProfileService(prefs)),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => ProgressService()),
        ChangeNotifierProvider(create: (_) => BookmarkService()),
      ],
      child: const DevHubApp(),
    ),
  );
}

class DevHubApp extends StatelessWidget {
  const DevHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'DevHub',
          debugShowCheckedModeBanner: false,
          theme: themeProvider.theme,
          // Improve scroll behavior for mobile
          scrollBehavior: const MaterialScrollBehavior().copyWith(
            dragDevices: {
              PointerDeviceKind.touch,
              PointerDeviceKind.mouse,
              PointerDeviceKind.trackpad,
            },
            physics: const BouncingScrollPhysics(),
          ),
          home: const SplashScreen(),
        );
      },
    );
  }
}
