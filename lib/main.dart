import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tic_tac_toe/controllers/game_controller.dart';
import 'package:tic_tac_toe/controllers/game_intelligence_controller.dart';
import 'package:tic_tac_toe/pages/menus/main_menu_page.dart';
import 'package:tic_tac_toe/utils/injector.dart';
import 'package:tic_tac_toe/utils/preferences.dart';
import 'package:tic_tac_toe/utils/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await preferences.init();

  Injector.register<IGameController>(GameController());
  Injector.register<IGameIntelligenceController>(GameIntelligenceController(gridSize: GameController.gridSize));

  runApp(ProviderScope(child: AppRoot()));
}

class AppRoot extends ConsumerWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      theme: ref.watch(appThemeProvider).theme,
      darkTheme: ref.watch(appThemeProvider).darkTheme,
      themeMode: ref.watch(appThemeProvider).mode,
      home: MainMenuPage(),
    );
  }
}
