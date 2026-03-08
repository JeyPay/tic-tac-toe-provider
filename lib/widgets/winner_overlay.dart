import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tic_tac_toe/controllers/game_controller.dart';
import 'package:tic_tac_toe/utils/theme/app_padding.dart';
import 'package:tic_tac_toe/utils/theme/app_theme.dart';

class WinnerOverlay {
  static Future trigger(BuildContext context, GameTickType tick) => showDialog(
    context: context,
    builder: (ctx) {
      return _WinnerWidget(
        size: MediaQuery.of(context).size,
        tick: tick,
        rootContext: context,
      );
    },
  );
}

class _WinnerWidget extends StatefulWidget {
  const _WinnerWidget({
    Key? key,
    required this.size,
    required this.tick,
    required this.rootContext,
  }) : super(key: key);

  final Size size;
  final GameTickType tick;
  final BuildContext rootContext;

  @override
  _WinnerWidgetState createState() => _WinnerWidgetState();
}

class _WinnerWidgetState extends State<_WinnerWidget> with SingleTickerProviderStateMixin {
  late AnimationController parent;
  late Animation<double> successAnimation;

  @override
  void initState() {
    super.initState();
    parent = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1200),
    );
    successAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: parent,
        curve: const Interval(0.0, 0.6, curve: Curves.ease),
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      parent.forward().then((value) async {
        if (mounted)
          setState(() {
            parent.reverse();
          });
        Future.delayed(parent.duration!).then((value) => mounted ? Navigator.pop(context) : null);
      });
    });
  }

  @override
  void dispose() {
    parent.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ScaleTransition(
      scale: Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: parent,
          curve: const Interval(0, 0.6, curve: Curves.elasticOut),
        ),
      ),
      child: Card(
        shape: const CircleBorder(),
        color: AppTheme.status(context).success,
        margin: EdgeInsets.symmetric(horizontal: widget.size.width / 4),
        child: Stack(
          alignment: Alignment.center,
          children: [
            FadeTransition(
              opacity: parent.status == AnimationStatus.reverse
                  ? const AlwaysStoppedAnimation(0)
                  : Tween(begin: 1.0, end: 0.0).animate(CurvedAnimation(parent: parent, curve: Curves.ease)),
              child: AnimatedBuilder(
                animation: successAnimation,
                builder: (context, child) {
                  return CustomPaint(
                    painter: _SprinklePainter(value: successAnimation.value),
                    child: SizedBox(
                      width: size.width / 2,
                      height: size.width / 2,
                    ),
                  );
                },
              ),
            ),
            Center(
              child: FadeTransition(
                opacity: parent.status == AnimationStatus.reverse ? const AlwaysStoppedAnimation(1) : successAnimation,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.tick == GameTickType.none)
                      Text("No winner", style: style)
                    else
                      Text("Winner", style: style),
                    if (widget.tick != GameTickType.none) SizedBox(height: AppPadding.medium),
                    switch (widget.tick) {
                      GameTickType.none => SizedBox.shrink(),
                      GameTickType.circle => Icon(
                        Icons.circle_outlined,
                        size: _iconSize,
                        color: AppTheme.of(widget.rootContext).foregroundColor,
                      ),
                      GameTickType.cross => Icon(
                        Icons.close,
                        size: _iconSize,
                        color: AppTheme.of(widget.rootContext).foregroundColor,
                      ),
                    },
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextStyle get style => TextStyle(fontSize: 19);

  static const double _iconSize = 48;
}

class _SprinklePainter extends CustomPainter {
  final double value;
  _SprinklePainter({required this.value});

  @override
  void paint(Canvas canvas, Size size) {
    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = size.width / 2.3 + value * 100;
    double radius2 = size.width / 1.9 + value * 100;

    Paint paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 4;

    for (var i = 0; i <= 360; i += 30) {
      double rad = i * 3.14 / 180;
      double x1 = center.dx + radius * cos(rad);
      double y1 = center.dy + radius * sin(rad);

      double x2 = center.dx + radius2 * cos(rad);
      double y2 = center.dy + radius2 * sin(rad);

      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
