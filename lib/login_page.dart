import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mytest3/utils/LinePainter.dart';
import 'package:provider/provider.dart';
import 'customWidget/GradientButton.dart';
import 'Provider/user_provider.dart';
import 'db/openDB.dart';
import 'utils/my_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginPage extends StatefulWidget {
  final DatabaseManager dbManager;
  const LoginPage({super.key, required this.dbManager});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  bool isLoginMode = true;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void toggleMode() {
    setState(() {
      isLoginMode = !isLoginMode;
    });
  }
  login(BuildContext context) async {
    final username = _usernameController.text;
    final password = _passwordController.text;
    // 验证用户名和密码是否存在
    await widget.dbManager.verify(username, password).then((isVerified) async {
      if (isVerified) {
        return await widget.dbManager.getUser(username);
      } else {
        throw Exception("用户名或密码错误");
      }
    }).then((user) {
      Provider.of<UserProvider>(context, listen: false).setCurrentUser(user);
      if (kDebugMode) {
        print(user.toMap().toString());
      }
    }).then((_) {
      // 导航到下一个页面
      Navigator.pushReplacementNamed(context, '/AccountPage');
    }).catchError((error) async {
      // 登录失败，展示错误信息
      await widget.dbManager.ifNameExist(username).then((isNameExist) =>
          showLoginErrorDialog(context, isNameExist));
    });
  }

  void register(BuildContext context) async {
    final username = _usernameController.text;
    final password = _passwordController.text;
    if (username.isNotEmpty && password.isNotEmpty) {
      widget.dbManager.ifNameExist(username).then((isNameExist) {
        if (isNameExist) {
          // 用户名已存在，显示弹窗
          showUsernameExistDialog(context);
        } else {
          return widget.dbManager.insert(username, password);
        }
      }).then((_) async {
        // 注册成功，获取用户信息，并保存到 Provider 中
        return await widget.dbManager.getUser(username);
      }).then((user) {
        Provider.of<UserProvider>(context, listen: false).setCurrentUser(user);
        if (kDebugMode) {
          print(user.toMap().toString());
        }
      }).then((_) {
        // 导航Account
        Navigator.pushNamed(context, '/AccountPage');
      }).catchError((error) {
        // 处理获取用户信息或导航过程中出现的错误
        showErrorMessageDialog(context, error.toString());
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 250,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/loginEllipse.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Center(
                  child: Text(
                    AppLocalizations.of(context)!.login,
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    child: Text(
                      AppLocalizations.of(context)!.login,
                      style: TextStyle(
                        fontSize: isLoginMode ? 20 : 16,
                        fontWeight: isLoginMode ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        isLoginMode = true;
                      });
                    },
                  ),
                  SizedBox(width: 10), // 调整按钮之间的间距
                  CustomPaint(
                    painter: LinePainter(
                        Offset(0, -10),
                        Offset(0, 40)
                    ),
                    size: Size(2, 20),
                  ),
                  SizedBox(width: 10), // 调整按钮之间的间距
                  ElevatedButton(
                    child: Text(
                      AppLocalizations.of(context)!.register,
                      style: TextStyle(
                        fontSize: !isLoginMode ? 20 : 16,
                        fontWeight: !isLoginMode ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        isLoginMode = false;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 10),
              // Divider(height: 2),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 80),
                child: Column(
                  children: [
                    TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.username,
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.password,
                      ),
                    ),
                    SizedBox(height: 20),
                    GradientButton(
                      colors: const [Colors.orange, Colors.red],
                      height: 50.0,
                      child: Text(
                        isLoginMode ? AppLocalizations.of(context)!.login :
                        AppLocalizations.of(context)!.register,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      onPressed: isLoginMode
                          ? () => login(context)
                          : () => register(context),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
    );
  }
}