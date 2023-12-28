import 'package:flutter/material.dart';
import 'package:mytest3/MyPage/about_page.dart';
import 'package:mytest3/RecordPage/record_page.dart';
import 'package:mytest3/searchNotePage.dart';
import 'package:mytest3/splashScreen.dart';
import 'package:mytest3/Provider/user_provider.dart';
import 'package:provider/provider.dart';
import 'MyPage/my_page.dart';
import 'MyPage/settings_page.dart';
import 'Provider/app_language_provider.dart';
import 'account_page.dart';
import 'all_record_page.dart';
import 'ChartPage/chart_page.dart';
import 'db/openDB.dart';
import 'login_page.dart';
import './MyPage/currency_rate.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  late DatabaseManager dbManager;

  @override
  void initState() {
    super.initState();
    initDatabase();
  }

  Future<void> initDatabase() async {
    dbManager = DatabaseManager();
    await dbManager.initializeDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => AppLanguageProvider()),
      ],
      child: Consumer<AppLanguageProvider>(
        builder: (context, model, child) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Login App',
          locale: model.appLocale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const SplashScreen(key: ValueKey<String>("SplashScreen")),
          routes: {
            '/LoginPage': (context) => LoginPage(key: const ValueKey<String>("LoginPage"),dbManager: dbManager,),
            '/AccountPage': (context) => AccountPage(key: const ValueKey<String>("AccountPage"),dbManager: dbManager),
            '/SearchNotePage': (context) => SearchNotePage(key: const ValueKey<String>("SearchNotePage"),dbManager: dbManager),
            '/ChartPage': (context) => ChartPage(key: const ValueKey<String>("ChartPage"),dbManager: dbManager),
            '/AllRecordPage': (context) => AllRecordPage(key: const ValueKey<String>("AllRecordPage"),dbManager: dbManager),
            '/SettingsPage': (context) => const SettingsPage(key: ValueKey<String>("SettingsPage")),
            '/AboutPage': (context) => const AboutPage(key: ValueKey<String>("AboutPage")),
            '/MyPage': (context) => MyPage(key: const ValueKey<String>("MyPage"),dbManager: dbManager),
            '/CurrentRate': (context) => const CurrentRate(key: ValueKey<String>("CurrencyRate")),
            '/RecordPage': (context) => RecordPage(key: const ValueKey<String>("RecordPage"),dbManager: dbManager),
          },
        ),
      ),
    );
  }
}
