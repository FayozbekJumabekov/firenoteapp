import 'package:hive/hive.dart';

class HiveService {
  static const String hiveName = "hive_note";
  static Box box = Hive.box(hiveName);

  static Future<void> saveUserId(String userId) async {
    return await box.put('userId', userId);
  }

  static Future<String> loadUserId(String userId) async {
    String userId = box.get('userId');
    return userId;
  }

  static Future<void> remoUserId() async {
    return await box.delete('userId');
  }
}
