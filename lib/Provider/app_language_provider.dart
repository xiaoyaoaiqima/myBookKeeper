import 'package:flutter/material.dart';

class AppLanguageProvider extends ChangeNotifier {

  bool langSwitch = false;  // 初始设置为"en"和"zh"
  bool zhSwitch = false;  // 初始设置为简体中文

  Locale _appLocale = const Locale('en');

  Locale get appLocale => _appLocale;

  fetchLocale() async {
    _appLocale = const Locale("en");
    notifyListeners();
  }

  void changeLanguage(Locale type) {
    _appLocale = type;
    if (type == const Locale('zh', 'CN')) {
      langSwitch = true;
      zhSwitch = false;
    } else if (type == const Locale('zh', 'HK')) {
      langSwitch = true;
      zhSwitch = true;
    } else {
      langSwitch = false;
      zhSwitch = false;
    }
    notifyListeners();
  }
}