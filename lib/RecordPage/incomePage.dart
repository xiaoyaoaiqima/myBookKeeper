import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Provider/account_provider.dart';
import '../db/TypeBean.dart';
import '../db/openDB.dart';


class IncomePage extends StatefulWidget {
  final DatabaseManager dbManager;
  IncomePage({super.key, required this.dbManager});
  @override
  _IncomePageState createState() => _IncomePageState();
}

class _IncomePageState extends State<IncomePage> {
  List<TypeBean> incomeTypeList = [];
  int? selectedButton;
  @override
  void initState() {
    super.initState();
    loadIncomeTypeList();
  }

  Future<void> loadIncomeTypeList() async {
    List<TypeBean> typeList = await widget.dbManager.getTypeList(1);
    setState(() {
      incomeTypeList = typeList;
    });
  }

  @override
  Widget build(BuildContext context) {
    final accountProvider = Provider.of<AccountProvider>(context);
    return Scaffold(
      body:Center(
          child:GridView.count(
            crossAxisCount: 3,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
            childAspectRatio: MediaQuery.of(context).size.width / (MediaQuery.of(context).size.height / 4),
            children: incomeTypeList.asMap().entries.map((entry) {
              int index = entry.key;
              var type = entry.value;
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
                      Text(type.typeName, style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
              );
            }).toList(),
          )
      ),
    );
  }
}
