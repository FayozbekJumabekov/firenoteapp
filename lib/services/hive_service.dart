import 'package:hive/hive.dart';

class HiveService {
  static const String hiveName = "hive_note";
  static Box box = Hive.box(hiveName);

  //
  // static Future<void> storeMode(bool isLight) async {
  //   await box.put("isLight", isLight);
  // }
  //
  // static bool loadMode() {
  //   return box.get("isLight", defaultValue: true);
  // }

  static Future<void> saveUserId(StorageKeys key,String userId) async {
    return await box.put(_getKey(key), userId);
  }

  static Future<String> loadUserId(StorageKeys key) async {
    String userId = box.get(_getKey(key));
    return userId;
  }

  static Future<void> remoUserId(StorageKeys key) async {
    return await box.delete(_getKey(key));
  }

  static String _getKey(StorageKeys key) {
    switch(key) {
      case StorageKeys.UID: return "userId";
    }
  }
}
enum StorageKeys {
  UID,
}