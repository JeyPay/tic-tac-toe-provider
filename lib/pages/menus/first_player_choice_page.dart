import 'package:flutter/material.dart';
import 'package:tic_tac_toe/controllers/game_controller.dart';
import 'package:tic_tac_toe/pages/game_grid/game_grid_page.dart';
import 'package:tic_tac_toe/utils/extensions/context_extension.dart';
import 'package:tic_tac_toe/utils/extensions/extensions.dart';
import 'package:tic_tac_toe/utils/theme/app_padding.dart';
import 'package:tic_tac_toe/utils/theme/app_theme.dart';
import 'package:tic_tac_toe/widgets/game_tick.dart';

class FirstPlayerChoicePage extends StatelessWidget {
  const FirstPlayerChoicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => _startGame(context, GameTickType.circle),
              child: Container(
                alignment: Alignment.center,
                color: AppTheme.of(context).primaryColor,
                child: Text(
                  "Circle",
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
              "Who starts ?",
              style: TextStyle(fontSize: 16, color: AppTheme.of(context).primaryColor),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => _startGame(context, GameTickType.cross),
              child: Container(
                alignment: Alignment.center,
                color: AppTheme.of(context).secondaryColor,
                child: Text(
                  "Cross",
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

  void _startGame(BuildContext context, GameTickType tickType) {
    gameController.setFirstPlayer(tickType);
    gameController.init();

    context.fadingTo(GameGridPage());
  }
}
