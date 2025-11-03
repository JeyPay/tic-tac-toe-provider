import 'package:flutter/material.dart';

class StatusDesignSystem extends ThemeExtension<StatusDesignSystem> {
  StatusDesignSystem();

  final Color error = Colors.red;
  final Color success = Colors.green;
  final Color warning = Colors.orangeAccent;

  @override
  ThemeExtension<StatusDesignSystem> copyWith() {
    return StatusDesignSystem();
  }

  @override
  ThemeExtension<StatusDesignSystem> lerp(covariant ThemeExtension<StatusDesignSystem>? other, double t) {
    if (other is! StatusDesignSystem) {
      return this;
    }
    return StatusDesignSystem();
  }
}

@immutable
class DesignSystem extends ThemeExtension<DesignSystem> {
  const DesignSystem({
    required this.primaryColor,
    required this.secondaryColor,
    required this.foregroundColor,
  });

  final Color primaryColor;
  final Color secondaryColor;
  final Color foregroundColor;

  @override
  DesignSystem copyWith({
    Color? primaryColor,
    Color? secondaryColor,
    Color? foregroundColor,
  }) {
    return DesignSystem(
      primaryColor: primaryColor ?? this.primaryColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      foregroundColor: foregroundColor ?? this.foregroundColor,
    );
  }

  @override
  DesignSystem lerp(ThemeExtension<DesignSystem>? other, double t) {
    if (other is! DesignSystem) {
      return this;
    }
    return DesignSystem(
      primaryColor: Color.lerp(primaryColor, other.primaryColor, t)!,
      secondaryColor: Color.lerp(secondaryColor, other.secondaryColor, t)!,
      foregroundColor: Color.lerp(foregroundColor, other.foregroundColor, t)!,
    );
  }
}
