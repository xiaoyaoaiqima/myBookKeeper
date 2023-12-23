import 'package:flutter/material.dart';


void showLoginErrorDialog(BuildContext context,bool isNameExist){
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("登录失败"),
        content: isNameExist ? Text("密码错误") : Text("用户名不存在，请先注册"),
        actions: [
          TextButton(
            child: Text("确定"),
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
          title: Text('确认'),
          content: Text('你确定要退出登录吗？'),
          actions: <Widget>[
            TextButton(
              child: Text('取消'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('确认'),
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
        title: Text("用户名已存在"),
        content: Text("请重新输入用户名"),
        actions: [
          TextButton(
            child: Text("确定"),
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
      title: Text("错误"),
      content: Text(message),
      actions: [
        TextButton(
          child: Text("确定"),
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
      title: Text("操作成功"),
      content: Text(message),
      actions: [
        TextButton(
          child: Text("确定"),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    ),
  );
}

Future<bool> showDeleteItemDialog(BuildContext context) async {
  return await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Delete Item'),
        content: Text('Are you sure you want to delete this item?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Delete'),
          ),
        ],
      );
    },
  ) ?? false;
}
