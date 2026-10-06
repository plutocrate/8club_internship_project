import 'package:flutter/material.dart';

class AppGradients {
  AppGradients._();

  static const LinearGradient buttonEnabled = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF3E3E42),
      Color(0xFF1C1C20),
    ],
  );

  static const LinearGradient topHeaderLight = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF262628),
      Color(0xFF141416),
    ],
  );

  static const LinearGradient cardSheen = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF2C2C30),
      Color(0xFF141416),
    ],
  );

  static const LinearGradient micActiveSpotlight = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0x40FFFFFF),
      Color(0x08FFFFFF),
    ],
  );
}
