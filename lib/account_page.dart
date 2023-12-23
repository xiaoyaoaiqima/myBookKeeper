import 'package:flutter/material.dart';
import 'package:mytest3/Provider/user_provider.dart';
import 'package:mytest3/utils/my_dialog.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'db/AccountBean.dart';
import 'db/openDB.dart';
import 'myBottomNavigationBar.dart';

class AccountPage extends StatefulWidget {
  final DatabaseManager dbManager;


  AccountPage({super.key, required this.dbManager});

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  List<AccountBean> accountList = [];
  List<AccountBean> accountListDay1 = [];
  List<AccountBean> accountListDay2 = [];
  List<AccountBean> accountListDay3 = [];
  double day1In = 0, day1Out = 0;
  double day2In = 0, day2Out = 0;
  double day3In = 0, day3Out = 0;
  bool ifHidden = true;

  double currentMonthIn = 0;
  double currentMonthOut = 0;
  double currentMonthBudget = 0;

  double todayOut = 0;
  double todayIn = 0;

  @override
  void initState() {
    super.initState();
    ifHidden = true;
  }
  Future<void> fetchAccounts(String username) async {
    final now = DateTime.now();
    accountListDay1 = await widget.dbManager.getOneDayAccount(username, now.day);
    accountListDay2 = await widget.dbManager.getOneDayAccount(username, now.day - 1);
    accountListDay3 = await widget.dbManager.getOneDayAccount(username, now.day - 2);
    List<double> monthMoney = await widget.dbManager.getMonthMoney(username,now.year,now.month);
    currentMonthIn =  monthMoney[1];
    currentMonthOut = monthMoney[0];
    currentMonthBudget = currentMonthIn - currentMonthOut;

    day1In = accountListDay1.where((element) => element.kind == 1).fold(0, (sum, element) => sum + element.money);
    day1Out = accountListDay1.where((element) => element.kind == 0).fold(0, (sum, element) => sum + element.money);
    day2In = accountListDay2.where((element) => element.kind == 1).fold(0, (sum, element) => sum + element.money);
    day2Out = accountListDay2.where((element) => element.kind == 0).fold(0, (sum, element) => sum + element.money);
    day3In = accountListDay3.where((element) => element.kind == 1).fold(0, (sum, element) => sum + element.money);
    day3Out = accountListDay3.where((element) => element.kind == 0).fold(0, (sum, element) => sum + element.money);

  }
  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    final currentUser = userProvider.currentUser!;
    final allAccounts = [accountListDay1, accountListDay2, accountListDay3];
    final allIncomes = [day1In, day2In, day3In];
    final allOutcomes = [day1Out, day2Out, day3Out];

    final int year = DateTime.now().year;
    final int month = DateTime.now().month;
    final int day = DateTime.now().day;


    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.symmetric(horizontal: 10),
            padding: EdgeInsets.only(top: 10),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "${currentUser.name} ${AppLocalizations.of(context)!.tally}",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.search,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/SearchNotePage');
                      },
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Text(AppLocalizations.of(context)!.month_out),
                            Text(ifHidden ? "****" : "￥ ${currentMonthOut}",
                                style: const TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.redAccent)),
                          ],
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  ifHidden = !ifHidden;
                                });
                              },
                              child: Image(
                                image: AssetImage(ifHidden
                                    ? 'assets/bigmipmap/ih_hide.png'
                                    : 'assets/bigmipmap/ih_show.png'),
                                height: 40,
                                width: 40,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        RichText(
                          text: TextSpan(
                            text: AppLocalizations.of(context)!.month_in,
                            style: TextStyle(color: Colors.black),
                            children: <TextSpan>[
                              TextSpan(
                                  text: ifHidden ? "***" : '￥ ${currentMonthIn}',
                                  style: TextStyle(
                                      color: Colors.greenAccent, fontSize: 18)),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: RichText(
                              text: TextSpan(
                                text: AppLocalizations.of(context)!.budget,
                                style: TextStyle(color: Colors.black),
                                children: [
                                  TextSpan(
                                      text: ifHidden ? "***" : '￥ ${currentMonthBudget}',
                                      style: TextStyle(color: Colors.black))
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Row(
                      children: [
                        Text(
                          "近三日账单",
                          style: TextStyle(fontSize: 22),
                        ),
                        Spacer(),
                        TextButton(onPressed: null, child: Text("按时间"))
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: FutureBuilder<void>(
                future: fetchAccounts(currentUser.name),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: allAccounts.length,
                      itemBuilder: (_, i) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("$year年$month月${day - i}日"),
                                  Text(
                                    "Income: \$${allIncomes[i]} Out: \$${allOutcomes[i]}",
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              ...allAccounts[i]
                                  .map(
                                    (account) => GestureDetector(
                                  onLongPress: () => showDeleteItemDialog(context).then((value) =>
                                  value ? widget.dbManager.deleteAccount(account.id) : null),
                                  child: Row(
                                    children: [
                                      Image.asset(account.sImageId),
                                      SizedBox(
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
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurfaceVariant,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Spacer(),
                                      Text(
                                        '\￥${account.money}',
                                        style: TextStyle(
                                          color: (account.kind == 0)
                                              ? Colors.red
                                              : Colors.green,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                                  .toList(),
                            ],
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ),
          const Text(
            "当前为三天内账单，更多请在底部账单内查看",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
      bottomNavigationBar: MyBottomNavigationBar(dbManager: widget.dbManager),
    );
  }

}
