import 'package:flutter/material.dart';
import 'package:tic_tac_toe/controllers/game_controller.dart';
import 'package:tic_tac_toe/pages/menus/first_player_choice_page.dart';
import 'package:tic_tac_toe/utils/extensions/context_extension.dart';
import 'package:tic_tac_toe/utils/extensions/extensions.dart';
import 'package:tic_tac_toe/utils/theme/app_padding.dart';
import 'package:tic_tac_toe/utils/theme/app_theme.dart';

class GameSizePage extends StatelessWidget {
  const GameSizePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => _startGame(context, 3),
              child: Container(
                alignment: Alignment.center,
                color: AppTheme.of(context).primaryColor,
                child: Text(
                  "3x3",
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
              "Grid size",
              style: TextStyle(fontSize: 16, color: AppTheme.of(context).primaryColor),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => _startGame(context, 6),
              child: Container(
                alignment: Alignment.center,
                color: AppTheme.of(context).secondaryColor,
                child: Text(
                  "6x6",
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

  void _startGame(BuildContext context, int gridSize) {
    gameController.setGridSize(gridSize);

    context.fadingTo(FirstPlayerChoicePage());
  }
}
