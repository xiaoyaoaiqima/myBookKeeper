import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'appLanguage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppLanguage>(
      create: (_) => AppLanguage(),
      child: Consumer<AppLanguage>(builder: (context, model, child) {
        return MaterialApp(
          locale: model.appLocale,  // 将locale设置成你的model对象的appLocale
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const MyHomePage(title: 'Flutter Demo Home Page'),
        );
      }),
    );
  }
}
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
  bool _langSwitch = false;  // 初始设置为"en"和"zh"
  bool _zhSwitch = false;  // 初始设置为简体中文
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(AppLocalizations.of(context)!.personalizationSettings),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SwitchListTile(
              title: Text(AppLocalizations.of(context)!.changeLanguage),
              value: _langSwitch,
              onChanged: (bool value) {
                setState(() {
                  _langSwitch = value;
                  Provider.of<AppLanguage>(context, listen: false).changeLanguage(value ?
                  Locale('zh', _zhSwitch ? 'HK' : 'CN') : Locale('en'));
                });
              },
              secondary: const Icon(Icons.language),
            ),
            SwitchListTile(
              title: Text(AppLocalizations.of(context)!.changeSimplify),
              value: _zhSwitch,
              onChanged: _langSwitch ? (bool value) {
                setState(() {
                  _zhSwitch = value;
                  Provider.of<AppLanguage>(context, listen: false).changeLanguage(Locale('zh', value ? 'HK' : 'CN'));
                });
              } : null, // 如果当前选中的语言不是中文，则禁用此开关
              secondary: const Icon(Icons.language),
            ),
          ],
        ),
      ),
    );
  }
}
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
