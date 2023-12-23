class BarChartItemBean {
  int year;
  int month;
  int day;
  double sumMoney;

  BarChartItemBean({required this.year, required this.month,
    required this.day, required this.sumMoney});

  // 你可能会需要一个从 json 到 BarChartItemBean 的工厂方法
  factory BarChartItemBean.fromJson(Map<String, dynamic> json) {
    return BarChartItemBean(
      year: json['year'],
      month: json['month'],
      day: json['day'],
      sumMoney: json['sumMoney'].toDouble(),
    );
  }

  // 而且一个从 BarChartItemBean 到 json 的方法也会有用
  Map<String, dynamic> toJson() {
    return {
      'year': this.year,
      'month': this.month,
      'day': this.day,
      'sumMoney': this.sumMoney,
    };
  }
}