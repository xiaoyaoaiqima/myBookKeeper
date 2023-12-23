import 'package:flutter/material.dart';

import '../db/AccountBean.dart';

class AccountProvider extends ChangeNotifier {
  late AccountBean currentAccountBean;
  int id = 0;
  String typeName = '其他';
  String sImageId = 'assets/mipmap/ic_qita_fs.png';
  String note = '暂无备注';
  double money = 0.0;
  String time = '';
  int year = 0;
  int month = 0;
  int day = 0;
  int kind = 0;

  void setCurrentUser(AccountBean accountBean) {
    currentAccountBean = accountBean;
    notifyListeners();
  }

  void resetValues() {
    typeName = '其他';
    sImageId = 'assets/mipmap/ic_qita.png';
    note = '暂无备注';
    money = 0.0;
    time = '';
    year = 0;
    month = 0;
    day = 0;
    kind = 0;
    notifyListeners();
  }
  void createCurrentAccountBean() {
    currentAccountBean = AccountBean(
      id:id,
      typeName: typeName,
      sImageId: sImageId,
      note: note,
      money: money,
      time: time,
      year: year,
      month: month,
      day: day,
      kind: kind,
    );
    notifyListeners();
  }
}

