class AccountBean {
  int id;
  String typeName;
  String sImageId;
  String note;
  double money;
  String time;
  int year;
  int month;
  int day;
  int kind;

  AccountBean({
    required this.id,
    required this.typeName,
    required this.sImageId,
    required this.note,
    required this.money,
    required this.time,
    required this.year,
    required this.month,
    required this.day,
    required this.kind,
  });
  @override
  String toString() {
    return 'AccountBean: $typeName,$sImageId,$note,$money,$time,$year年$month月$day日，$kind';  // 返回你想要的格式
  }
  // 为了方便使用，可以添加一个 fromJson 方法
  factory AccountBean.fromJson(Map<String, dynamic> json) => AccountBean(
    id: json['id'],
    typeName: json['typeName'],
    sImageId: json['sImageId'],
    note: json['note'],
    money: json['money'].toDouble(),
    time: json['time'],
    year: json['year'],
    month: json['month'],
    day: json['day'],
    kind: json['kind'],
  );

  // 和一个 toJson 方法
  Map<String, dynamic> toMap() => {
    'id': id,
    'typeName': typeName,
    'sImageId': sImageId,
    'note': note,
    'money': money,
    'time': time,
    'year': year,
    'month': month,
    'day': day,
    'kind': kind,
  };
}