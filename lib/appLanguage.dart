import 'package:flutter/material.dart';

class AppLanguage extends ChangeNotifier {
  Locale _appLocale = Locale('en');

  Locale get appLocale => _appLocale ?? Locale("en");

  fetchLocale() async {
    _appLocale = Locale("en");
    notifyListeners();
  }

  void changeLanguage(Locale type) {
    _appLocale = type;
    notifyListeners();
  }
}