import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

import '../Provider/user_provider.dart';
import '../db/openDB.dart';
import '../myBottomNavigationBar.dart';
import '../utils/my_dialog.dart';

class MyPage extends StatefulWidget {
  late final DatabaseManager dbManager;

  MyPage({super.key, required this.dbManager});

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
    final itemsActions = [
      _showHelp,
      _showOfficialAccount,
          (context) => _showEditPasswordPage(context, currentUser.name,widget.dbManager),
      _shareToFriend
    ];
    return Scaffold(
      body:SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 5,),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/SettingsPage');
                },
                child: Icon(Icons.settings),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CircleAvatar(
                    child:
                    ClipOval(child: Image.asset('assets/avatar/default.jpg')),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Hi, ${currentUser.name}"),
                      Text("今天是你记账的第$count天"),
                    ],
                  ),
                  ElevatedButton(
                    child: Text(isButtonEnabled ? '打卡' : '已打卡'),
                    onPressed: isButtonEnabled
                        ? () {
                      setState(() {
                        isButtonEnabled = false;
                        count++;
                      });
                    }
                        : null,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text('常用功能'),
            SizedBox(
              height: 10,
            ),
            Wrap(
              spacing: 10, // 水平（行间）间距
              runSpacing: 10, // 垂直（列间）间距
              children: ["收支分类", "我的资产", "多账本", "预算设置", "标签", "账单报告", "实时汇率"]
                  .asMap()
                  .entries
                  .map((entry) {
                var text = entry.value;
                var index = entry.key;
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: ElevatedButton(
                    onPressed: () {
                      switch (text) {
                        case "收支分类":
                        // 执行"收支分类"的函数
                          print("点击了 收支分类");
                          break;
                        case "我的资产":
                        // 执行"我的资产"的函数
                          print("点击了 我的资产");
                          break;
                      //... 可添加其他case语句
                        default:
                        // 执行默认的函数
                          print("你点击了：$text 按钮，索引是：$index");
                      }
                    },
                    child: Text(text),
                  ),
                );
              }).toList(),
            ),
            Text('偏好'),
            Wrap(
              spacing: 10, // 水平间距
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: Text('记账偏好'),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Text('个性化'),
                ),
              ],
            ),
            Column(
              children: List.generate(
                itemsText.length,
                    (index) => ListTile(
                  leading: Icon(Icons.help),
                  title: Text(itemsText[index]),
                  onTap: () {
                    var selectedAction = itemsActions[index];
                    selectedAction(context);
                  },
                ),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: MyBottomNavigationBar(dbManager: widget.dbManager),
    );
  }

}

void _showEditPasswordPage(BuildContext context, String username,DatabaseManager dbManager) {
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('编辑密码'),
        content: Column(
          children: <Widget>[
            TextField(
              controller: oldPasswordController,
              decoration: InputDecoration(hintText: "输入老的密码"),
            ),
            TextField(
              controller: newPasswordController,
              decoration: InputDecoration(hintText: "输入新的密码"),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: Text('确定'),
            onPressed: () async {
              final oldPassword = oldPasswordController.text;
              final newPassword = newPasswordController.text;

              var isOldPasswordCorrect = await dbManager.verify(username,oldPassword);

              if (isOldPasswordCorrect) {
                await dbManager.changePassword(username,newPassword);
                Navigator.pop(context, true);
              } else {
                showErrorMessageDialog(context,"老密码输入错误");
              }
            },
          ),
        ],
      );
    },
  ).then((value) => value == true ? showGoodMessageDialog(context,"密码已经修改"): null);
}
void _showHelp(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("使用帮助"),
        content: const SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text("1. 主界面：主界面是你的行动中心。在这里，你会看到所有的账目列表，按照输入的时间从新到旧排序。你也可以使用搜索功能查找特定的账目。"),
              Text("2. 添加新的账目：要添加新的账目，只需点击底部栏的 '+记一笔' 。之后在弹出的页面中录入相关的信息，如金额、类别、日期和备注，然后点击键盘上的保存按钮。"),
              Text("3. 查看账目详情：点击底部栏的账本标志，会进入详细账目记录，你可以选择年份和月份来查看相应的账目信息。"),
              Text("4. 删除账目：任何一条账目都可以修改，只需要长按账目记录，会出现删除弹窗，点击 '删除' 按钮，即可删除"),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: const Text('知道了'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

void _showOfficialAccount(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("官方账号"),
        content: const SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text("1. 联系方式：19858312003//15268184055"),
              Text("2. 邮箱：1428293926@qq.com//wuzhenlin20030612@gmail.com"),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: const Text('知道了'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

void _shareToFriend(BuildContext context) {
  Share.share('***Here goes your app link***');
}