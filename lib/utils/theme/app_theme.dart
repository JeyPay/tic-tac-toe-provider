import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tic_tac_toe/utils/preferences.dart';
import 'package:tic_tac_toe/utils/theme/design_system.dart';

final appThemeProvider = NotifierProvider<AppTheme, AppThemeState>(AppTheme.new);

class AppThemeState {
  final ThemeMode mode;
  final ThemeData theme;
  final ThemeData darkTheme;

  AppThemeState({
    required this.mode,
    required this.theme,
    required this.darkTheme,
  });

  AppThemeState copyWith({
    ThemeMode? mode,
    ThemeData? theme,
    ThemeData? darkTheme,
  }) {
    return AppThemeState(
      mode: mode ?? this.mode,
      theme: theme ?? this.theme,
      darkTheme: darkTheme ?? this.darkTheme,
    );
  }
}

class AppTheme extends Notifier<AppThemeState> {
  bool startup = true;

  @override
  AppThemeState build() {
    final modeString = preferences.getThemeMode();
    final mode = _fromString(modeString);

    _applyOverlay(mode);

    return AppThemeState(
      mode: mode,
      theme: _theme,
      darkTheme: _darkTheme,
    );
  }

  /// Set theme mode directly
  void setMode(ThemeMode mode) {
    state = state.copyWith(mode: mode);

    _applyOverlay(mode);
    preferences.setThemeMode(mode.toString());
  }

  /// Set theme mode from string
  void setModeString(String value) {
    setMode(_fromString(value));
  }

  /// Toggle dark/light
  void switchMode() {
    if (state.mode == ThemeMode.dark) {
      setMode(ThemeMode.light);
    } else {
      setMode(ThemeMode.dark);
    }
  }

  ThemeMode _fromString(String m) {
    switch (m) {
      case "ThemeMode.light":
        return ThemeMode.light;
      case "ThemeMode.dark":
        return ThemeMode.dark;
      case "ThemeMode.system":
      default:
        return ThemeMode.system;
    }
  }

  void _applyOverlay(ThemeMode mode) {
    if (mode == ThemeMode.light) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    } else if (mode == ThemeMode.dark) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    } else {
      SystemChrome.restoreSystemUIOverlays();
    }
  }

  /// /// Helper method to access [DesignSystem].
  static DesignSystem of(BuildContext context) {
    return Theme.of(context).extension<DesignSystem>()!;
  }

  /// Helper method to access [StatusDesignSystem].
  static StatusDesignSystem status(BuildContext context) {
    return Theme.of(context).extension<StatusDesignSystem>()!;
  }

  /// Light theme
  ThemeData get theme => _theme;

  /// Dark theme
  ThemeData get darkTheme => _darkTheme;

  final ThemeData _theme = ThemeData(
    textTheme: const TextTheme(
      bodySmall: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white),
      bodyLarge: TextStyle(color: Colors.white),
    ),
    extensions: <ThemeExtension<dynamic>>[
      StatusDesignSystem(),
      const DesignSystem(
        primaryColor: Colors.indigo,
        secondaryColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
    ],
  );

  static const Color _darkForeground = Color.fromARGB(255, 210, 210, 210);

  final ThemeData _darkTheme = ThemeData(
    textTheme: const TextTheme(
      bodySmall: TextStyle(color: _darkForeground),
      bodyMedium: TextStyle(color: _darkForeground),
      bodyLarge: TextStyle(color: _darkForeground),
    ),
    extensions: <ThemeExtension<dynamic>>[
      StatusDesignSystem(),
      DesignSystem(
        primaryColor: Colors.indigo.shade900,
        secondaryColor: Colors.teal.shade900,
        foregroundColor: _darkForeground,
      ),
    ],
  );
}
