import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Provider/account_provider.dart';
import '../Provider/user_provider.dart';
import '../db/openDB.dart';
import '../utils/my_dialog.dart';

class CustomKeyboard extends StatefulWidget {
  final DatabaseManager dbManager;
  const CustomKeyboard({super.key, required this.dbManager});
  @override
  CustomKeyboardState createState() => CustomKeyboardState();
}

class CustomKeyboardState extends State<CustomKeyboard> {
  String inputValue = '0.00';
  String inputValueString = '';
  String noteValue = '';
  //
  late double tempInput;
  late double secondInput;

  bool beginIntput = false;

  bool isPlus = false;
  bool isSecondInput = false;
  bool isOperatorClicked = false;
  final TextEditingController noteController = TextEditingController();
  bool keyboard = false;//键盘的弹起、收回状态
  double _paddingValue = 0;
  late AccountProvider accountProvider;
  late User currentUser;
  // late final userProvider;

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    currentUser = userProvider.currentUser!;
    inputValueString = inputValue.toString();
    accountProvider = Provider.of<AccountProvider>(context);
    final deviceHeight = MediaQuery.of(context).size.height;
    accountProvider.note = ((noteController.text) == '') ? '暂无备注' : noteController.text;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        keyboard = MediaQuery.of(context).viewInsets.bottom > 0;
        if (keyboard) {
          _paddingValue = 25;
        } else {
          _paddingValue = 0;
        }
      });
    });
    return SizedBox(
        height: 350,
        child: Stack(
          children: <Widget>[
            Positioned(
              bottom: deviceHeight*0.365,
              width: MediaQuery.of(context).size.width, // 让Table铺满屏幕宽度
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200), // duration of animation
                margin: EdgeInsets.only(bottom: _paddingValue), // set bottom padding only when keyboard is visible
                child:  Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        const SizedBox(
                          width: 8,
                        ),
                        SizedBox(
                          height: 30, // 根据需要设置高度
                          width: 80, // 根据需要设置宽度
                          child: ElevatedButton(
                            onPressed: () {
                              // 在这里添加你的处理代码
                            },
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              // 设置图标和文字居中
                              children: <Widget>[
                                Text('账户', style: TextStyle(fontSize: 12)),
                                Flexible(
                                  child:
                                  Icon(Icons.account_circle, size: 16),
                                ),
                                // 设置文字大小
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        SizedBox(
                          height: 30, // 根据需要设置高度
                          width: 80, // 根据需要设置宽度
                          child: ElevatedButton(
                            onPressed: () {
                              showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2025),
                                builder: (BuildContext context, Widget? child) {
                                  return Theme(
                                    data: ThemeData.light(),
                                    child: child!,
                                  );
                                },
                              ).then((selectedDate) {
                                if (selectedDate != null) {
                                  showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now(),
                                  ).then((selectedTime) {
                                    if (selectedTime != null) {
                                      accountProvider.year = selectedDate.year;
                                      accountProvider.month = selectedDate.month;
                                      accountProvider.day = selectedDate.day;
                                      accountProvider.time = '${selectedTime.hour}:${selectedTime.minute}';
                                    }
                                  });
                                }
                              });
                            },
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              // 设置图标和文字居中
                              children: <Widget>[
                                Text('日期', style: TextStyle(fontSize: 14)),
                                Flexible(
                                  child:
                                  Icon(Icons.calendar_today, size: 20),
                                ), // 设置文字大小
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        SizedBox(
                          height: 30, // 根据需要设置高度
                          width: 80, // 根据需要设置宽度
                          child: ElevatedButton(
                            onPressed: () {
                              // 在这里添加你的处理代码
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              // 设置图标和文字居中
                              children: <Widget>[
                                Text('标签', style: TextStyle(fontSize: 14)),
                                Flexible(
                                  child:
                                  Icon(Icons.tag, size: 20), // 设置图标大小
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: noteController,
                            decoration: InputDecoration(
                              hintText: '请输入备注',
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30, // 根据需要设置高度
                          width: 80,
                          child: ElevatedButton(
                            onPressed: () {
                              // 按钮点击操作
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              // 居中对齐 横向
                              children: <Widget>[
                                Text('照片', style: TextStyle(fontSize: 14)),
                                //
                                Flexible(
                                  child: Icon(Icons.photo_album), // 设置图标大小
                                ),
                              ],
                            ),
                          ),
                        ),
                        Text("￥ $inputValueString"),
                        SizedBox(
                          width: 8,
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
                bottom:  -50,
                width: MediaQuery.of(context).size.width, // 让Table铺满屏幕宽度
                child: SizedBox(
                  height: 300,
                  child: Table(
                    border: TableBorder(
                      top: BorderSide(color: Colors.grey),
                      verticalInside: BorderSide(color: Colors.grey),
                      horizontalInside: BorderSide(color: Colors.grey),
                    ),
                    children: [
                      _buildKeyboardRow(['1', '2', '3', '删除']),
                      _buildKeyboardRow(['4', '5', '6', '+']),
                      _buildKeyboardRow(['7', '8', '9', '-']),
                      _buildKeyboardRow(['再记', '0', '.', '保存']),
                    ],
                  ),
                ))
          ],
        ));
  }

  TableRow _buildKeyboardRow(List<String> keys) {
    bool isDecimal = false;
    bool decimalAdded = false;
    return TableRow(
      children: keys.map((key) {
        if (key == "=" || key == "保存") {
          key = isOperatorClicked ? "=" : "保存";
        }
        return InkWell(
          onTap: () {
            if(!beginIntput){
              inputValue = '';
              beginIntput = true;
            }
            // 每个键盘按键的点击操作
            if (key == '+') {
              if (inputValue.isNotEmpty) {
                isPlus = true;
                tempInput = double.parse(inputValue);
                isOperatorClicked = true;
                inputValue = '';
                isSecondInput = true;
              }
            } else if (key == '-') {
              if (inputValue.isNotEmpty) {
                isPlus = false;
                tempInput = double.parse(inputValue);
                inputValue = '';
                isSecondInput = true;
                isOperatorClicked = true;
              }
            } else if (key == '.') {
              if (!isDecimal && !decimalAdded) {
                setState(() {
                  inputValue += '.';
                  isDecimal = true;
                  decimalAdded = true;
                });
              }
            }
             else if (key == '=') {
              if (isSecondInput) {
                double result = 0;
                secondInput = double.parse(inputValue);
                if (isPlus) {
                  result = tempInput + secondInput;
                } else {
                  result = tempInput - secondInput;
                }
                setState(() {
                  inputValue = result.toString();
                  isSecondInput = false;
                });
                isOperatorClicked = false;
              }
            } else if (key == '保存') {
               if(accountProvider.year == 0){
                 showErrorMessageDialog(context,"请先选择时间");
               }else{
                 accountProvider.money = double.parse(inputValue);
                 accountProvider.createCurrentAccountBean();
                 widget.dbManager.addOneAccount(currentUser.name, accountProvider.currentAccountBean);
                 accountProvider.resetValues();
                 inputValue = '';
                 noteController.text = '';
               }
            } else if (key == '删除') {
              if (inputValue.isNotEmpty) {
                setState(() {
                  inputValue = inputValue.substring(0, inputValue.length - 1);
                });
              }
            } else {
              setState(() {
                if (isDecimal) {
                  inputValue += key;
                  isDecimal = false;
                } else {
                  inputValue += key;
                }
              });
            }
          },
          child: Container(
            alignment: Alignment.center,
            child: Text(key, style: TextStyle(fontSize: 16)),
            padding: EdgeInsets.all(20.0),
          ),
        );
      }).toList(),
    );
  }
}
