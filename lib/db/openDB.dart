import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../Provider/user_provider.dart';
import 'AccountBean.dart';
import 'TypeBean.dart';

class DatabaseManager {
  late Database database;

  static final DatabaseManager _instance = DatabaseManager._internal();

  factory DatabaseManager() {
    return _instance;
  }

  DatabaseManager._internal();

  Future<void> initializeDatabase() async {
    try {
      var databasesPath = await getDatabasesPath();
      String path = join(databasesPath, 'tally.db');
      // 是否重写数据库
      // bool exists = await databaseExists(path);
      // if (exists) {await deleteDatabase(path);}

      database =
          await openDatabase(path, version: 1, onCreate: (db, version) async {
        // 账号密码验证
        await db.execute('''
          CREATE TABLE User(
          id INTEGER PRIMARY KEY,
          userName TEXT,
          userPassword TEXT,
          imageUrl TEXT
           )
        ''');
        await db.insert(
          'User',
          {
            'userName': '123',
            'userPassword': '123',
            'imageUrl': 'assets/default.png',
          },
        );
        // 创建 typetb 表
        await db.execute('''
        create table typetb(
        id integer primary key,
        typeName TEXT,
        imageId TEXT,
        sImageId TEXT,
        kind INTEGER
      )''');
        // 插入类型数据
        await insertType(db);
        // 创建 accounttb 表
        await db.execute('''
        create table accounttb(
        id integer primary key,
        userName TEXT,
        typeName TEXT,
        sImageId TEXT,
        note TEXT,
        money REAL,
        time TEXT,
        year INTEGER,
        month INTEGER,
        day INTEGER,
        kind INTEGER,
        FOREIGN KEY(typeName) REFERENCES typetb(typeName),
        FOREIGN KEY(userName) REFERENCES User(userName)
      )''');
      });
    } catch (e) {
      if (kDebugMode) {
        print('Failed to open database: $e');
      }
    }
  }

  Future<void> insertType(Database db) async {
    String sql =
        "insert into typetb (typeName,imageId,sImageId,kind) values (?,?,?,?)";
    await db.rawInsert(sql,
        ["其他", "assets/mipmap/ic_qita.png", "assets/mipmap/ic_qita_fs.png", 0]);
    await db.rawInsert(sql, [
      "餐饮",
      "assets/mipmap/ic_canyin.png",
      "assets/mipmap/ic_canyin_fs.png",
      0
    ]);
    await db.rawInsert(sql, [
      "交通",
      "assets/mipmap/ic_jiaotong.png",
      "assets/mipmap/ic_jiaotong_fs.png",
      0
    ]);
    await db.rawInsert(sql, [
      "购物",
      "assets/mipmap/ic_gouwu.png",
      "assets/mipmap/ic_gouwu_fs.png",
      0
    ]);
    await db.rawInsert(sql, [
      "服饰",
      "assets/mipmap/ic_fushi.png",
      "assets/mipmap/ic_fushi_fs.png",
      0
    ]);
    await db.rawInsert(sql, [
      "日用品",
      "assets/mipmap/ic_riyongpin.png",
      "assets/mipmap/ic_riyongpin_fs.png",
      0
    ]);
    await db.rawInsert(sql,
        ["娱乐", "assets/mipmap/ic_yule.png", "assets/mipmap/ic_yule_fs.png", 0]);
    await db.rawInsert(sql, [
      "零食",
      "assets/mipmap/ic_lingshi.png",
      "assets/mipmap/ic_lingshi_fs.png",
      0
    ]);
    await db.rawInsert(sql, [
      "烟酒茶",
      "assets/mipmap/ic_yanjiu.png",
      "assets/mipmap/ic_yanjiu_fs.png",
      0
    ]);
    await db.rawInsert(sql, [
      "学习",
      "assets/mipmap/ic_xuexi.png",
      "assets/mipmap/ic_xuexi_fs.png",
      0
    ]);
    await db.rawInsert(sql, [
      "医疗",
      "assets/mipmap/ic_yiliao.png",
      "assets/mipmap/ic_yiliao_fs.png",
      0
    ]);
    await db.rawInsert(sql, [
      "住宅",
      "assets/mipmap/ic_zhufang.png",
      "assets/mipmap/ic_zhufang_fs.png",
      0
    ]);
    await db.rawInsert(sql, [
      "水电煤",
      "assets/mipmap/ic_shuidianfei.png",
      "assets/mipmap/ic_shuidianfei_fs.png",
      0
    ]);
    await db.rawInsert(sql, [
      "通讯",
      "assets/mipmap/ic_tongxun.png",
      "assets/mipmap/ic_tongxun_fs.png",
      0
    ]);
    await db.rawInsert(sql, [
      "人情",
      "assets/mipmap/ic_renqingwanglai.png",
      "assets/mipmap/ic_renqingwanglai_fs.png",
      0
    ]);

    await db.rawInsert(sql,
        ["其他", "assets/mipmap/in_qt.png", "assets/mipmap/in_qt_fs.png", 1]);
    await db.rawInsert(sql, [
      "薪资",
      "assets/mipmap/in_xinzi.png",
      "assets/mipmap/in_xinzi_fs.png",
      1
    ]);
    await db.rawInsert(sql, [
      "奖金",
      "assets/mipmap/in_jiangjin.png",
      "assets/mipmap/in_jiangjin_fs.png",
      1
    ]);
    await db.rawInsert(sql, [
      "借入",
      "assets/mipmap/in_jieru.png",
      "assets/mipmap/in_jieru_fs.png",
      1
    ]);
    await db.rawInsert(sql, [
      "收债",
      "assets/mipmap/in_shouzhai.png",
      "assets/mipmap/in_shouzhai_fs.png",
      1
    ]);
    await db.rawInsert(sql, [
      "利息收入",
      "assets/mipmap/in_lixifuji.png",
      "assets/mipmap/in_lixifuji_fs.png",
      1
    ]);
    await db.rawInsert(sql, [
      "投资回报",
      "assets/mipmap/in_touzi.png",
      "assets/mipmap/in_touzi_fs.png",
      1
    ]);
    await db.rawInsert(sql, [
      "二手交易",
      "assets/mipmap/in_ershoushebei.png",
      "assets/mipmap/in_ershoushebei_fs.png",
      1
    ]);
    await db.rawInsert(sql, [
      "意外所得",
      "assets/mipmap/in_yiwai.png",
      "assets/mipmap/in_yiwai_fs.png",
      1
    ]);
  }

  Future<List<TypeBean>> getTypeList(int kind) async {

    final List<Map<String, dynamic>> maps = await database.query(
      'typetb',
      where: 'kind = ?',
      whereArgs: [kind],
    );

    return List.generate(maps.length, (i) {
      return TypeBean.fromMap(maps[i]);
    });
  }

  Future<User> getUser(String userName) async {
    // 执行查询操作
    final results = await database.query(
      'User',
      where: 'userName = ?',
      whereArgs: [userName],
    );
    if (results.isNotEmpty) {
      return User.fromJson(results.first);
    } else {
      throw Exception('User not found');
    }
  }

  // 验证用户名和密码是否匹配
  Future<bool> verify(String name, String password) async {
    final result = await database.query(
      'User',
      columns: ['userPassword'],
      where: 'userName = ?',
      whereArgs: [name],
    );

    if (result.isNotEmpty) {
      final userPassword = result.first['userPassword'] as String?;
      return userPassword == password;
    }

    return false;
  }

// 插入用户名和密码
  Future<void> insert(String name, String password) async {
    await database.insert(
      'User',
      {
        'userName': name,
        'userPassword': password,
        'imageUrl': 'assets/cow.png',
      },
    );
  }
  Future<void> changePassword(String username, String newPassword) async {
    await database.update(
      'User',
      {'userPassword': newPassword},
      where: 'userName = ?',
      whereArgs: [username],
    );
  }
  // 检查用户名是否已存在
  Future<bool> ifNameExist(String name) async {
    final result = await database.query(
      'User',
      columns: ['userName'],
      where: 'userName = ?',
      whereArgs: [name],
    );
    return result.isNotEmpty;
  }

  Future<List<AccountBean>> getOneDayAccount(String username, int day) async {
    try {
      final now = DateTime.now();
      final year = now.year;
      final month = now.month;

      // correct usage of the database.query() function
      final results = await database.query(
          'accounttb',   // the name of the table
          columns: ['id','typeName', 'sImageId', 'note', 'money', 'time', 'year', 'month', 'day', 'kind'],   // the columns to select
          where: 'userName = ? AND year = ? AND month = ? AND day = ?',   // the WHERE clause
          whereArgs: [username, year, month, day]);   // arguments for the WHERE clause

      return results.map((json) => AccountBean.fromJson(json)).toList();
    } catch (e) {
      print('Query error: $e');
      throw Exception('Failed to load one day accounts');  // 抛出新异常
    }
  }

  Future<bool> addOneAccount(String username, AccountBean account) async {
    try {
      await database.rawInsert(
          'INSERT INTO accounttb (userName, typeName, sImageId, note, money, time, year, month, day, kind) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
          [
            username,
            account.typeName,
            account.sImageId,
            account.note,
            account.money,
            account.time,
            account.year,
            account.month,
            account.day,
            account.kind
          ]);
      // print('插入一条: $account');
      return true; // 没有错误，返回 true 表示成功插入
    } catch (e, s) {
      print('Insertion error: $e');
      print('Stack trace: $s'); // 打印异常的堆栈信息
      rethrow; // 重新抛出异常
    }
  }


  Future<Map<int, List<AccountBean>>> getOneMonthAccount(String username,int year,int month) async {

    final results = await database.rawQuery('''
    SELECT id, typeName, sImageId, note, money, time, year, month, day, kind FROM accounttb
    WHERE username = ? AND year = ? AND month = ?
  ''', [username, year, month]);

    // 使用日期作为键，值为对应日期的AccountBean列表的Map
    Map<int, List<AccountBean>> accountsMap = {};

    // 遍历查询结果，将数据按天进行分类
    for (var json in results) {
      AccountBean accountBean = AccountBean.fromJson(json);
      if (!accountsMap.containsKey(accountBean.day)) {
        accountsMap[accountBean.day] = [];
      }
      accountsMap[accountBean.day]!.add(accountBean);
    }

    return accountsMap;
  }

  Future<List<AccountBean>> getAllAccount(String username, int year,int month) async {
    // 构建查询字符串
    const query = '''
    SELECT id,typeName, sImageId, note, money, time, year, month, day, kind
    FROM accounttb
    WHERE userName = ? AND year = ? AND month = ?
  ''';

    // 执行数据库查询
    final results = await database.rawQuery(query, [username, year,month]);

    // 将查询结果转换为 AccountBean 对象列表
    return results.map((json) => AccountBean.fromJson(json)).toList();
  }

  Future<List<double>> getMonthMoney(String username, int year, int month) async {
    final result = await database.rawQuery('''
    SELECT 
      SUM(CASE WHEN kind = 0 THEN money ELSE 0 END) AS outMoney,
      SUM(CASE WHEN kind = 1 THEN money ELSE 0 END) AS inMoney
    FROM accounttb
    WHERE userName = ? AND year = ? AND month = ?
  ''', [username, year,month]);

    final outMoney = (result.first['outMoney'] as num? ?? 0).toDouble();
    final inMoney = (result.first['inMoney'] as num? ?? 0).toDouble();

    return [outMoney, inMoney];
  }
  Future<void> deleteAccount(int accountId) async {
    await database.delete(
      'accounttb',
      where: 'id = ?',
      whereArgs: [accountId],
    );
  }

  Future<List<AccountBean>> searchNote(String username, String note) async {
    final results = await database.rawQuery('''
    SELECT * 
    FROM accounttb
    WHERE userName = ? AND note LIKE ?
  ''', [username, '%$note%']);

    return results.map((json) => AccountBean.fromJson(json)).toList();
  }
}
