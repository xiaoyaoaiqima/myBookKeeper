
import 'package:flutter/material.dart';

import 'db/openDB.dart';


class MyBottomNavigationBar extends StatelessWidget {
  final DatabaseManager dbManager;

  const MyBottomNavigationBar({super.key, required this.dbManager});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      unselectedItemColor: Colors.grey,  // 非选中项目的颜色
      selectedItemColor: Colors.red,
      currentIndex: 2,
      onTap: (index) {
        if (index == 0) {
          Navigator.pushNamed(context, '/AccountPage');
        }
        else if(index == 1){
          Navigator.pushNamed(context, '/AllRecordPage');
        }
        else if(index == 2){
          Navigator.pushNamed(context, '/RecordPage');
        }
        else if(index == 3){
          Navigator.pushNamed(context, '/ChartPage');
        }
        else if(index == 4){
          Navigator.pushNamed(context, '/MyPage');
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: '主页',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.description),
          label: '全部记录',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.edit),
          label: '记一笔',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.pie_chart),
          label: '图表',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: '我的',
        ),
      ],
    );
  }
}