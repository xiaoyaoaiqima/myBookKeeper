import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Provider/account_provider.dart';
import '../db/openDB.dart';
import 'customKeyBoard.dart';
import 'incomePage.dart';
import 'outcomePage.dart';

class RecordPage extends StatefulWidget {
  late final DatabaseManager dbManager;

  RecordPage({super.key, required this.dbManager});

  @override
  _RecordPageState createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("记一笔吧"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const <Widget>[
            Tab(text: '支出'),
            Tab(text: '收入'),
          ],
        ),
      ),
      body: ChangeNotifierProvider(
        create: (context) => AccountProvider(),
        child: Column(
          children: <Widget>[
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: <Widget>[
                  OutcomePage(key:const ValueKey("OutcomePage"),dbManager: widget.dbManager,), // 支出页面
                  IncomePage(key:const ValueKey("IncomePage"),dbManager: widget.dbManager,), // 收入页面
                ],
              ),
            ),
            CustomKeyboard(key:const ValueKey("CustomKeyboard"),dbManager: widget.dbManager,),
          ],
        ),
      ),
    );
  }
}






