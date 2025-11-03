import 'package:flutter/material.dart';
import 'package:tic_tac_toe/controllers/game_controller.dart';
import 'package:tic_tac_toe/utils/theme/app_theme.dart';

enum GameTickType {
  none,
  circle,
  cross;

  bool? get asBool => switch (this) {
    none => null,
    circle => true,
    cross => false,
  };

  GameTickType get other => switch (this) {
    none => none,
    circle => cross,
    cross => circle,
  };
}

class GameTickWidget extends StatefulWidget {
  const GameTickWidget({
    super.key,
    required this.type,
  });

  final GameTickType type;

  @override
  State<GameTickWidget> createState() => _GameTickWidgetState();
}

class _GameTickWidgetState extends State<GameTickWidget> with SingleTickerProviderStateMixin {
  late final AnimationController controller = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
  late final CurvedAnimation animation = CurvedAnimation(parent: controller, curve: Curves.bounceOut);

  @override
  void initState() {
    super.initState();

    if (widget.type != GameTickType.none) controller.forward();
  }

  void didUpdateWidget(covariant GameTickWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.type != widget.type) {
      controller.forward(from: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.type == GameTickType.none) return Container(color: Colors.transparent);

    return ScaleTransition(
      scale: animation,
      child: Icon(
        icon,
        size: MediaQuery.sizeOf(context).width / (gameController.gridSize + 1),
        color: AppTheme.of(context).foregroundColor,
      ),
    );
  }

  IconData get icon => switch (widget.type) {
    GameTickType.none => Icons.question_mark,
    GameTickType.circle => Icons.circle_outlined,
    GameTickType.cross => Icons.close,
  };
}
