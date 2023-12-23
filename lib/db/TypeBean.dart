class TypeBean {
  final int id;
  final String typeName;
  final String imageId;
  final String sImageId;
  final int kind;

  TypeBean({required this.id, required this.typeName,
    required this.imageId, required this.sImageId, required this.kind});

  // 从 Map 获取数据
  TypeBean.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        typeName = map['typeName'],
        imageId = map['imageId'],
        sImageId = map['sImageId'],
        kind = map['kind'];
}