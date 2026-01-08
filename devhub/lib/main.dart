import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/scheduler.dart';
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
  
  // Note: Flutter automatically uses the highest available refresh rate on supported devices
  
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

class DevHubApp extends StatefulWidget {
  const DevHubApp({super.key});

  @override
  State<DevHubApp> createState() => _DevHubAppState();
}

class _DevHubAppState extends State<DevHubApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Optimize for 120Hz - minimize time dilation
    timeDilation = 1.0;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'DevHub',
          debugShowCheckedModeBanner: false,
          theme: themeProvider.theme,
          // High performance scroll behavior for 120Hz
          scrollBehavior: const MaterialScrollBehavior().copyWith(
            dragDevices: {
              PointerDeviceKind.touch,
              PointerDeviceKind.mouse,
              PointerDeviceKind.trackpad,
            },
            // Use clamping for more responsive feel at 120Hz
            physics: const BouncingScrollPhysics(
              decelerationRate: ScrollDecelerationRate.fast,
            ),
          ),
          home: const SplashScreen(),
        );
      },
    );
  }
}
