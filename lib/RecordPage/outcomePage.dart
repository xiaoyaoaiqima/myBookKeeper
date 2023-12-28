import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Provider/account_provider.dart';
import '../db/TypeBean.dart';
import '../db/openDB.dart';

class OutcomePage extends StatefulWidget {
  final DatabaseManager dbManager;

  const OutcomePage({super.key, required this.dbManager});

  @override
  _OutcomePageState createState() => _OutcomePageState();
}

class _OutcomePageState extends State<OutcomePage> {
  List<TypeBean> outcomeTypeList = [];
  int? selectedButton;
  @override
  void initState() {
    super.initState();
    loadOutcomeTypeList();
  }

  Future<void> loadOutcomeTypeList() async {
    List<TypeBean> typeList = await widget.dbManager.getTypeList(0);
    setState(() {
      outcomeTypeList = typeList;
    });
  }

  @override
  Widget build(BuildContext context) {
    final accountProvider = Provider.of<AccountProvider>(context);
    return Scaffold(
      body: Center(
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,  // 指定每行四个元素
            crossAxisSpacing: 8.0, // 指定水平间距
            mainAxisSpacing: 8.0,  // 指定垂直间距
            childAspectRatio: MediaQuery.of(context).size.width / (MediaQuery.of(context).size.height / 4),  //  设置元素的宽高比
          ),
          itemCount: outcomeTypeList.length,
          itemBuilder: (context, index) {
            TypeBean type = outcomeTypeList[index];
            return Container(
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    selectedButton = index;
                  });
                  accountProvider.sImageId = type.sImageId;
                  accountProvider.typeName = type.typeName;
                  accountProvider.kind = type.kind;
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Image.asset(type.imageId,
                          color: selectedButton == index ? Theme.of(context).colorScheme.onPrimaryContainer: Theme.of(context).colorScheme.primaryContainer
                      ),
                    ),
                    Text(type.typeName),
                  ],
                ),
              ),

            );
          },
        )
      ),
    );
  }
}
