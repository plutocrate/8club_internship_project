import 'package:flutter/material.dart';

class AppGradients {
  AppGradients._();

  static const LinearGradient buttonEnabled = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF444446),
      Color(0xFF222224),
    ],
  );

  static const LinearGradient topHeaderLight = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF2A2A2C),
      Color(0xFF161618),
    ],
  );

  static const LinearGradient micActive = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF4A4A4C),
      Color(0xFF28282A),
    ],
  );
}
