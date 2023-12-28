
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import '../Provider/user_provider.dart';
import '../db/openDB.dart';
import '../myBottomNavigationBar.dart';
import '../utils/myUtils.dart';
import '../utils/my_dialog.dart';

class MyPage extends StatefulWidget {
  final DatabaseManager dbManager;

  const MyPage({super.key, required this.dbManager});

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  bool isButtonEnabled = true;
  int count = 0;
  final itemsText = ['帮助', '官方账号', '编辑密码', '分享给朋友'];

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    final currentUser = userProvider.currentUser!;
    final actionsList  = [
      showHelp,
      showOfficialAccount,
      (context) =>
          _showEditPasswordPage(context, currentUser.name, widget.dbManager),
      shareToFriend
    ];
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 5,
            ),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/SettingsPage');
                },
                child: const Icon(Icons.settings),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ClipOval(
                    child: SizedBox(
                      width: 50, // 修改为期望的值
                      height: 50, // 修改为期望的值
                      child: Image.asset('assets/avatar/default.jpg', fit: BoxFit.cover),
                    ),
                  ),
                  const SizedBox(width: 10,),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Hi, ${currentUser.name}"),
                      Text("今天是你记账的第$count天"),
                    ],
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: isButtonEnabled
                        ? () {
                            setState(() {
                              isButtonEnabled = false;
                              count++;
                            });
                          }
                        : null,
                    child: Text(isButtonEnabled ? '打卡' : '已打卡'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20,),
            const Text('常用功能',style: TextStyle(fontSize: 18),),
            const SizedBox(height: 10,),
            Wrap(
              spacing: 10, // 水平（行间）间距
              runSpacing: 10, // 垂直（列间）间距
              children: ["我的计划", "我的资产", "多账本", "预算设置", "标签", "账单报告", "实时汇率","关于app"]
                  .asMap()
                  .entries
                  .map((entry) {
                var text = entry.value;
                var index = entry.key;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: ElevatedButton(
                    onPressed: () {
                      switch (text) {
                        case "我的计划":
                          writeMyEvent(context,widget.dbManager);
                          break;
                        case "实时汇率":
                          Navigator.pushNamed(context, '/CurrentRate');
                          break;
                        case "关于app":
                          Navigator.pushNamed(context, '/AboutPage');
                          break;
                        default:
                          break;
                      }
                    },
                    child: Text(text),
                  ),
                );
              }).toList(),
            ),
            const Text('偏好',style: TextStyle(fontSize: 18),),
            Wrap(
              spacing: 10, // 水平间距
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('记账偏好'),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('个性化'),
                ),
              ],
            ),
            Column(
          children: List.generate(
            itemsText.length,
                (index) => ListTile(
              leading: const Icon(Icons.help),
              title: Text(itemsText[index]),
              onTap: () => actionsList[index](context),
            ),
          ),)
          ],
        ),
      ),
      bottomNavigationBar: MyBottomNavigationBar(dbManager: widget.dbManager),
    );
  }
}
void writeMyEvent(BuildContext context, DatabaseManager dbManager) {
  String eventWritten;
  DateTime eventWrittenTime;

  TextEditingController controller = TextEditingController();
  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text("写入你的计划"),
            content: SingleChildScrollView(
              child: TextField(
                controller: controller,
                minLines: 1,
                maxLines: 5,
                decoration: const InputDecoration(
                  hintText: '请在此输入你的计划',
                ),
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('确认'),
                onPressed: () {
                  eventWritten = controller.text;
                  Navigator.pop(context);
                  showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now().subtract(const Duration(days: 7)), // 一周前
                    lastDate: DateTime.now().add(const Duration(days: 7)), // 一周后
                  ).then((date) {
                    if (date != null) {
                      eventWrittenTime = date;
                      dbManager.addOneEventIn(constUsername, eventWrittenTime, eventWritten);
                    }
                  });
                },
              ),
            ],
          );
        },
      );
    },
  );
}
void _showEditPasswordPage(
    BuildContext context, String username, DatabaseManager dbManager) {
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('编辑密码'),
        content: Column(
          children: <Widget>[
            TextField(
              controller: oldPasswordController,
              decoration: const InputDecoration(hintText: "输入老的密码"),
            ),
            TextField(
              controller: newPasswordController,
              decoration: const InputDecoration(hintText: "输入新的密码"),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('确定'),
            onPressed: () async {
              final oldPassword = oldPasswordController.text;
              final newPassword = newPasswordController.text;

              var isOldPasswordCorrect =
                  await dbManager.verify(username, oldPassword);

              if (isOldPasswordCorrect) {
                await dbManager.changePassword(username, newPassword);
                Navigator.pop(context, true);
              } else {
                showErrorMessageDialog(context, "老密码输入错误");
              }
            },
          ),
        ],
      );
    },
  ).then((value) =>
      value == true ? showGoodMessageDialog(context, "密码已经修改") : null);
}
