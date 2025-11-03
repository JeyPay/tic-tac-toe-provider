import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {
  ///
  /// Navigate to a new route by fading-in.
  ///
  Future<T?> fadingTo<T>(Widget child) => Navigator.push(
    this,
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionDuration: Duration(milliseconds: 200),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    ),
  );

  ///
  /// Pop all routes until the very first route of the navigator.
  ///
  void popAll() => Navigator.popUntil(this, (route) => route.isFirst);
}
