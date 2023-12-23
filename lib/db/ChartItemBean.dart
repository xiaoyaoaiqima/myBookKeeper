class ChartItemBean {
  int sImageId;
  String type;
  double ratio;  // 所占比例
  double totalMoney;  // 此项的总钱数

  ChartItemBean({required this.sImageId, required this.type,
    required this.ratio, required this.totalMoney});

  // 可能会需要一个从 json 到 ChartItemBean 的工厂方法
  factory ChartItemBean.fromJson(Map<String, dynamic> json) {
    return ChartItemBean(
      sImageId: json['sImageId'],
      type: json['type'],
      ratio: json['ratio'].toDouble(),
      totalMoney: json['totalMoney'].toDouble(),
    );
  }

  // 一个从 ChartItemBean 到 json 的方法可能会有用
  Map<String, dynamic> toJson() {
    return {
      'sImageId': this.sImageId,
      'type': this.type,
      'ratio': this.ratio,
      'totalMoney': this.totalMoney,
    };
  }
}