import 'package:flutter/material.dart';

const Color color1 = Color(0xFFa4e3f7);
const Color color2 = Color(0xFF18587f);
const Color color3 = Color(0xFFeb6460);
const Color color4 = Color(0xFFf9d7b4);
const Color color5 = Color(0xFFf4ac71);
const Color color6 = Color(0xFFfdf5ec);
//fdf5ec
// const Color color6 = Color(0xFFFCF7F0);
// const Color color7 = Color(0xFF727272);

ThemeData generateTheme() {
  return ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.light(
      primary: color2,
      secondary: color4,
      // surface: color6,
    ),
    tabBarTheme: TabBarTheme(
      overlayColor: WidgetStateProperty.resolveWith<Color?>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.hovered)) {
            return color1.withValues(alpha: 0.3);
          }
          return null;
        },
      ),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(fontFamily: 'Rubik'),
      headlineMedium: TextStyle(fontFamily: 'Rubik'),
      headlineSmall: TextStyle(fontFamily: 'Rubik', fontSize: 20),
      bodyLarge: TextStyle(fontFamily: 'NotoSans', fontSize: 17),
      bodyMedium: TextStyle(fontFamily: 'NotoSans', fontSize: 15),
      bodySmall: TextStyle(fontFamily: 'NotoSans', fontSize: 12),
    ),
  );
}
