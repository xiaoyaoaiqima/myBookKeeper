import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../Provider/app_language_provider.dart';
import '../utils/my_dialog.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}
class _SettingsPageState extends State<SettingsPage> {

  @override
  Widget build(BuildContext context) {
    AppLanguageProvider appLanguageProvider = Provider.of<AppLanguageProvider>(context);
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
              value: appLanguageProvider.langSwitch,
              onChanged: (bool value) {
                setState(() {
                  appLanguageProvider.langSwitch = value;
                  Provider.of<AppLanguageProvider>(context, listen: false).changeLanguage(value ?
                  Locale('zh', appLanguageProvider.zhSwitch ? 'HK' : 'CN') : const Locale('en'));
                });
              },
              secondary: const Icon(Icons.language),
            ),
            SwitchListTile(
              title: Text(AppLocalizations.of(context)!.changeSimplify),
              value: appLanguageProvider.zhSwitch,
              onChanged: appLanguageProvider.langSwitch ? (bool value) {
                setState(() {
                  appLanguageProvider.zhSwitch = value;
                  Provider.of<AppLanguageProvider>(context, listen: false).changeLanguage(Locale('zh', value ? 'HK' : 'CN'));
                });
              } : null, // 如果当前选中的语言不是中文，则禁用此开关
              secondary: const Icon(Icons.language),
            ),

          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () {
            showOutLoginDialog(context);
          },
          child: Text('退出登录'),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.red,
            minimumSize: Size(double.infinity, 50),
          ),
        ),
      ),

    );
  }
}
