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
          await openDatabase(path, version: 3,
              onCreate: (db, version) async {
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
      },
              onUpgrade: (db, oldVersion, newVersion) async {
              // 处理数据库升级的操作
              switch(oldVersion) {
                case 2:
                  await db.execute('''
                  CREATE TABLE calendarEvent (
                  id INTEGER PRIMARY KEY,
                  userName TEXT,
                  time TEXT,
                  event TEXT
               )
              ''');
              // 这里没有break语句，这样当新的版本号大于2时，所有的升级操作都会被执行
              }
            },
      );
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
  Future<bool> addOneEventIn(String userName, DateTime time, String event) async {
    try {
      await database.insert(
        'calendarEvent',
        {
          'userName': userName,
          'time': time.toIso8601String(),
          'event': event,
        },
      );
      return true;
    } catch (error) {
      print('Failed to add event: $error');
      return false;
    }
  }
  Future<Map<DateTime, List<String>>> readAllEventIn(String userName) async {
    // 从数据库查询所有的事件
    final List<Map<String, dynamic>> maps = await database.query('calendarEvent', where: 'userName = ?', whereArgs: [userName]);
    // 用于存储结果的映射
    var events = <DateTime, List<String>>{};
    for(var row in maps) {
      var event = row['event'];
      var time = DateTime.parse(row['time']);

      // 如果映射中已经有这个时间，就添加到它对应的列表中
      if(events.containsKey(time)) {
        events[time]?.add(event);
      } else {
        events[time] = [event];
      }
    }
    return events;
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

  Future<Map<int, MonthSortMoneyData>> getMonthSortMoney(String username, int year, int month, int kind) async {
    // 数据库查询逻辑
    final db = database;
    final List<Map<String, dynamic>> maps = await db.query(
      'accounttb',
      where: 'userName = ? AND year = ? AND month = ? AND kind = ?',
      whereArgs: [username, year, month, kind],
    );

    List<MonthSortMoneyData> dataList = List.generate(maps.length, (i) {
      return MonthSortMoneyData(
        money: maps[i]['money'],
        typeName: maps[i]['typeName'],
        sImageId: maps[i]['sImageId'],
      );
    });

    double totalMoney = dataList.fold(0.0, (sum, element) => sum + element.money);

    var countMap = dataList.fold(<String, MonthSortMoneyData>{}, (map, element) {
      if (map[element.typeName] == null) {
        double percent = (element.money / totalMoney);
        map[element.typeName] = element.copyWith(count: 1, percent: double.parse(percent.toStringAsFixed(2)));
      } else {
        double updatedMoney = map[element.typeName]!.money + element.money;
        double percent = updatedMoney / totalMoney;
        map[element.typeName] = map[element.typeName]!.copyWith(
          money: updatedMoney,
          count: map[element.typeName]!.count + 1,
          percent: double.parse(percent.toStringAsFixed(2)), // Calculate the percentage by dividing by the total money and limit to 2 decimal points
        );
      }
      return map;
    });
    // 将Map转成List并根据count进行排序
    List<MonthSortMoneyData> sortedList = countMap.values.toList()
      ..sort((a, b) => b.money.compareTo(a.money));

    // 将排序的排名作为键，MonthSortMoneyData对象作为值，以Map格式返回
    return { for (var i = 0; i < sortedList.length; ++i) i + 1: sortedList[i] };
  }
}
