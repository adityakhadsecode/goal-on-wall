import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'theme/theme_provider.dart';
import 'widgets/main_scaffold.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
    ),
  );
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  runApp(const GoalOnWallApp());
}

class GoalOnWallApp extends StatelessWidget {
  const GoalOnWallApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
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
