import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context)!.about,
          style: textTheme.titleLarge,
        ),
        backgroundColor: const Color(0xFFF3F3F3),
        elevation: 0.0,
      ),
      backgroundColor: const Color(0xFFF3F3F3),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: <Widget>[
            infoSection(AppLocalizations.of(context)!.about_appinfo, context),
            infoSection(AppLocalizations.of(context)!.about_version, context),
            infoSection(AppLocalizations.of(context)!.about_1, context),
            titleSection(AppLocalizations.of(context)!.about_app, context),
            infoSection(AppLocalizations.of(context)!.about_balabala, context),
            titleSection(AppLocalizations.of(context)!.about_developer, context),
            infoSection(AppLocalizations.of(context)!.about_me, context),
            infoSection(AppLocalizations.of(context)!.about_loc, context),
            titleSection(AppLocalizations.of(context)!.about_email, context),
            infoSection(AppLocalizations.of(context)!.about_email2, context),
            titleSection(AppLocalizations.of(context)!.about_code, context),
            infoSection(AppLocalizations.of(context)!.about_codeinfo, context),
          ],
        ),
      ),
    );
  }

  Widget titleSection(String title, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Container(

        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.grey.shade200, // 设置背景色
          border: Border.all(
            color: Colors.deepPurple, // 你可以选择你想要的颜色
            width: 2.0, // 边框宽度
          ),
          borderRadius: BorderRadius.circular(8.0), // 边框圆角
        ),
        child: Text(
          title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );
  }

  Widget infoSection(String info, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Text(
        info,
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }
}