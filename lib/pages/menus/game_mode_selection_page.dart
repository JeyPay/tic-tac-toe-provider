import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tic_tac_toe/controllers/game_controller.dart';
import 'package:tic_tac_toe/pages/game_grid/game_grid_page.dart';
import 'package:tic_tac_toe/pages/menus/first_player_choice_page.dart';
import 'package:tic_tac_toe/utils/extensions/extensions.dart';
import 'package:tic_tac_toe/utils/injector.dart';
import 'package:tic_tac_toe/utils/theme/app_padding.dart';
import 'package:tic_tac_toe/utils/theme/app_theme.dart';

class GameModeSelectionPage extends StatelessWidget {
  static const String path = '/game-mode-selection';

  const GameModeSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => _startGame(context, GameMode.humanVsHuman),
              child: Container(
                alignment: Alignment.center,
                color: AppTheme.of(context).primaryColor,
                child: Text(
                  "Human vs Human",
                  style: optionStyle,
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            color: AppTheme.of(context).foregroundColor,
            padding: AppPadding.medium.verticalInsets(),
            child: Text(
              "Game mode",
              style: TextStyle(fontSize: 16, color: AppTheme.of(context).primaryColor),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => _startGame(context, GameMode.humanVsAi),
              child: Container(
                alignment: Alignment.center,
                color: AppTheme.of(context).secondaryColor,
                child: Text(
                  "Human vs AI",
                  style: optionStyle,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  TextStyle get optionStyle => TextStyle(fontSize: 22, fontWeight: FontWeight.bold);

  void _startGame(BuildContext context, GameMode gameMode) {
    final IGameController gameController = Injector.get<IGameController>();

    gameController.setGameMode(gameMode);

    if (gameMode == GameMode.humanVsAi) {
      context.go(FirstPlayerChoicePage.path);
    } else {
      gameController.init();
      context.go(GameGridPage.path);
    }
  }
}
