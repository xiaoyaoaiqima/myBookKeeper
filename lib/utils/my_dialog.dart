import 'package:flutter/material.dart';
import 'package:share/share.dart';


void showLoginErrorDialog(BuildContext context,bool isNameExist){
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("登录失败"),
        content: isNameExist ? const Text("密码错误") : const Text("用户名不存在，请先注册"),
        actions: [
          TextButton(
            child: const Text("确定"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
void showOutLoginDialog(BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('确认'),
          content: const Text('你确定要退出登录吗？'),
          actions: <Widget>[
            TextButton(
              child: const Text('取消'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('确认'),
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/LoginPage');
              },
            ),
          ],
        );
      }
  );
}
void showUsernameExistDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("用户名已存在"),
        content: const Text("请重新输入用户名"),
        actions: [
          TextButton(
            child: const Text("确定"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

void showErrorMessageDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: const Text("错误"),
      content: Text(message),
      actions: [
        TextButton(
          child: const Text("确定"),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    ),
  );
}
void showGoodMessageDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: const Text("操作成功"),
      content: Text(message),
      actions: [
        TextButton(
          child: const Text("确定"),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    ),
  );
}
void showHelp(BuildContext context) {
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

void showOfficialAccount(BuildContext context) {
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

void shareToFriend(BuildContext context) {
  Share.share('***Here goes your app link***');
}
Future<bool> showDeleteItemDialog(BuildContext context) async {
  return await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Delete Item'),
        content: const Text('Are you sure you want to delete this item?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      );
    },
  ) ?? false;
}
