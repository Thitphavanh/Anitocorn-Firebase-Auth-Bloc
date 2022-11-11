import 'package:flutter/cupertino.dart';

class MyTheme {
  const MyTheme();

  static Color gradientStart = const Color(0xFFEFF7F6);
  static Color gradientEnd = const Color(0xFFEFF7F6);
  static Color blackColor = const Color(0xFF000000);

  static LinearGradient gradient = LinearGradient(
    colors: [gradientStart, gradientEnd],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: const [0.0, 1.0],
  );
}
