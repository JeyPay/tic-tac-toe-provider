import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/pages/menus/main_menu_page.dart';
import 'package:tic_tac_toe/utils/preferences.dart';
import 'package:tic_tac_toe/utils/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await preferences.init();

  runApp(AppRoot());
}

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppTheme(),
      builder: (context, child) {
        return Consumer<AppTheme>(
          builder: (context, theme, child) {
            return MaterialApp(
              theme: theme.theme,
              darkTheme: theme.darkTheme,
              themeMode: theme.mode,
              home: MainMenuPage(),
            );
          },
        );
      },
    );
  }
}
