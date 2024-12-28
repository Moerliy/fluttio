import 'package:flutter/material.dart';
import 'package:catppuccin_flutter/catppuccin_flutter.dart';

class SettingsProvider extends ChangeNotifier {
  Flavor _themeFlavor = catppuccin.mocha;

  Flavor get themeFlavor => _themeFlavor;

  void setThemeFlavor(Flavor flavor) {
    _themeFlavor = flavor;
    notifyListeners();
  }
}
