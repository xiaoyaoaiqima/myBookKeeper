import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mytest3/utils/my_dialog.dart';
import 'package:provider/provider.dart';
import 'Provider/user_provider.dart';
import 'db/AccountBean.dart';
import 'db/openDB.dart';
import 'myBottomNavigationBar.dart';


class AllRecordPage extends StatefulWidget {
  final DatabaseManager dbManager;
  const AllRecordPage({super.key, required this.dbManager});
  @override
  _AllRecordPage createState() => _AllRecordPage();
}

class _AllRecordPage extends State<AllRecordPage>{
  late int selectedYear;
  late int selectedMonth;

  @override
  void initState() {
    super.initState();
    selectedYear = DateTime.now().year;
    selectedMonth = DateTime.now().month;
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    final currentUser = userProvider.currentUser!;

    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 15,),
          FutureBuilder<List<double>>(
              future: widget.dbManager.getMonthMoney(currentUser.name,selectedYear,selectedMonth),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () => showCupertinoModalPopup(
                            context: context,
                            builder: (_) => _buildCupertinoDatePicker(context),
                          ),
                          child: Column(
                            children: <Widget>[
                              Text("$selectedYear", style: const TextStyle(fontSize: 14)),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text('$selectedMonth', style: const TextStyle(fontSize: 20)),
                                  const Icon(Icons.keyboard_arrow_down),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: <Widget>[
                            const Text('收入: ', style: TextStyle(fontSize: 14)),
                            Text('${snapshot.data?[1]}', style: const TextStyle(fontSize: 20)),  // currentMonthIn
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            const Text('支出: ', style: TextStyle(fontSize: 14)),
                            Text('${snapshot.data?[0]}', style: const TextStyle(fontSize: 20)),  // currentMonthOut
                          ],
                        ),
                      ],
                    ),
                  );
                }
              }
          ),
          Expanded(
            child: FutureBuilder<Map<int, List<AccountBean>>>(
              future: widget.dbManager.getOneMonthAccount(currentUser.name, selectedYear, selectedMonth),
              builder: (BuildContext context, AsyncSnapshot<Map<int, List<AccountBean>>> snapshot) {
                if (snapshot.hasData) {
                  var dataMap = snapshot.data;
                  // 我们将Map的键(日期)以升序进行排序
                  List<int> sortedDays = dataMap!.keys.toList()..sort();
                  return SingleChildScrollView(
                    child: ListView.builder(
                      itemCount: sortedDays.length,
                      itemBuilder: (context, index) {
                        int day = sortedDays[index];
                        List<AccountBean> dayAccounts = dataMap[day]!;
                        return ListTile(
                          title: Text('$selectedYear年$selectedMonth月$day日'),
                          subtitle: Column(
                            children: dayAccounts.map((account) => GestureDetector(
                              onLongPress: () => showDeleteItemDialog(context).then((value) =>
                              value ? widget.dbManager.deleteAccount(account.id) : null),
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    children: [
                                      Image.asset(account.sImageId),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            account.typeName,
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Theme.of(context).colorScheme.onSurface,
                                            ),
                                          ),
                                          Text(
                                            account.note,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Spacer(),
                                      Text(
                                        '￥${account.money}',
                                        style: TextStyle(
                                          color: (account.kind == 0)
                                              ? Colors.red
                                              : Colors.green,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )).toList(),
                          ),
                        );
                      },
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text('Sorry, an error occurred: ${snapshot.error}');
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            )
          )
        ],
      ),
      bottomNavigationBar: MyBottomNavigationBar(dbManager: widget.dbManager),
    );
  }

  Widget _buildCupertinoDatePicker(BuildContext context) {
    return Container(
      height: 200.0,
      color: Colors.white,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildPicker(2000, 2025, selectedYear, (value) {
            setState(() {
              selectedYear =  value + 2000;
            });
          }),
          _buildPicker(1, 12, selectedMonth, (value) {
            setState(() {
              selectedMonth = value + 1;
            });
          }),
        ],
      ),
    );
  }

  Widget _buildPicker(int start, int end, int selectedValue, ValueChanged<int> onSelectChanged) {
    return Expanded(
      child: CupertinoPicker(
        itemExtent: 32.0,
        scrollController: FixedExtentScrollController(initialItem: selectedValue - start),
        onSelectedItemChanged: onSelectChanged,
        children: List<Widget>.generate(
          end - start + 1,
              (index) => Text((index + start).toString()),
        ),
      ),
    );
  }
}

