import 'package:catppuccin_flutter/catppuccin_flutter.dart';
import 'package:flutter/material.dart';

ThemeData catppuccinTheme(Flavor flavor) {
  Color primaryColor = flavor.mauve;
  Color secondaryColor = flavor.pink;
  return ThemeData(
      useMaterial3: true,
      appBarTheme: AppBarTheme(
          elevation: 0,
          titleTextStyle: TextStyle(
              color: flavor.text, fontSize: 20, fontWeight: FontWeight.bold),
          backgroundColor: flavor.crust,
          foregroundColor: flavor.mantle),
      colorScheme: ColorScheme(
        background: flavor.base,
        brightness: Brightness.light,
        error: flavor.surface2,
        onBackground: flavor.text,
        onError: flavor.red,
        onPrimary: primaryColor,
        onSecondary: secondaryColor,
        onSurface: flavor.text,
        primary: flavor.crust,
        secondary: flavor.mantle,
        surface: flavor.surface0,
      ),
      textTheme: const TextTheme().apply(
        bodyColor: flavor.text,
        displayColor: primaryColor,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        elevation: 0,
      ));
}

Map<String, Color> getColorMap(Flavor flavor) {
  Map<String, Color> colorMap = {
    "rosewater": flavor.rosewater,
    "flamingo": flavor.flamingo,
    "pink": flavor.pink,
    "mauve": flavor.mauve,
    "red": flavor.red,
    "maroon": flavor.maroon,
    "peach": flavor.peach,
    "yellow": flavor.yellow,
    "green": flavor.green,
    "teal": flavor.teal,
    "sky": flavor.sky,
    "sapphire": flavor.sapphire,
    "blue": flavor.blue,
    "lavender": flavor.lavender,
    "text": flavor.text,
    "subtext1": flavor.subtext1,
    "subtext0": flavor.subtext0,
    "overlay2": flavor.overlay2,
    "overlay1": flavor.overlay1,
    "overlay0": flavor.overlay0,
    "surface2": flavor.surface2,
    "surface1": flavor.surface1,
    "surface0": flavor.surface0,
    "crust": flavor.crust,
    "mantle": flavor.mantle,
    "base": flavor.base,
  };
  return colorMap;
}
