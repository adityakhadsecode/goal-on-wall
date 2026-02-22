import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:workmanager/workmanager.dart';
import 'theme/theme_provider.dart';
import 'widgets/main_scaffold.dart';
import 'services/background_task.dart';
import 'providers/wallpaper_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
    ),
  );
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  // Register daily wallpaper refresh with WorkManager
  await Workmanager().initialize(callbackDispatcher, isInDebugMode: false);
  await Workmanager().registerPeriodicTask(
    'daily-wallpaper-refresh',
    refreshWallpaperTask,
    frequency: const Duration(hours: 24),
    constraints: Constraints(networkType: NetworkType.notRequired),
    existingWorkPolicy: ExistingPeriodicWorkPolicy.keep,
  );

  runApp(const GoalOnWallApp());
}

class GoalOnWallApp extends StatelessWidget {
  const GoalOnWallApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => WallpaperProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          final palette = themeProvider.palette;
          return MaterialApp(
            title: 'Goal on Wall',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              brightness: Brightness.dark,
              scaffoldBackgroundColor: palette.deepBackground,
              textTheme: GoogleFonts.outfitTextTheme(
                ThemeData.dark().textTheme,
              ),
              colorScheme: ColorScheme.dark(
                primary: palette.primaryLight,
                secondary: palette.accent,
                surface: palette.cardBackground,
              ),
              useMaterial3: true,
            ),
            home: const MainScaffold(),
          );
        },
      ),
    );
  }
}
