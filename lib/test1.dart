import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DatePickerDemo(),
    );
  }
}

class DatePickerDemo extends StatefulWidget {
  @override
  _DatePickerDemoState createState() => _DatePickerDemoState();
}

class _DatePickerDemoState extends State<DatePickerDemo> {
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Date Picker Demo'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => showCupertinoModalPopup(
            context: context,
            builder: (_) => _buildCupertinoDatePicker(context),
          ),
          child: Text('选择日期'),
        ),
      ),
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
              selectedYear = value;
              print('选择的年份: $selectedYear');
            });
          }),
          _buildPicker(1, 12, selectedMonth, (value) {
            setState(() {
              selectedMonth = value;
              print('选择的月份: $selectedMonth');
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
        children: List<Widget>.generate(
          end - start + 1,
              (index) => Text((index + start).toString()),
        ),
        onSelectedItemChanged: onSelectChanged,
      ),
    );
  }
}