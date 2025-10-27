import 'package:hive/hive.dart';

class HiveUtils {
  /// Open a box (creates if not exists)
  static Future<Box<T>> openBox<T>(String boxName) async {
    return await Hive.openBox<T>(boxName);
  }

  /// Save object
  static Future<void> save<T>(String boxName, String key, T value) async {
    final box = await openBox<T>(boxName);
    await box.put(key, value);
  }

  /// Get object
  static Future<T?> get<T>(String boxName, String key) async {
    final box = await openBox<T>(boxName);
    return box.get(key);
  }

  /// Get all values
  static Future<List<T>> getAll<T>(String boxName) async {
    final box = await openBox<T>(boxName);
    return box.values.toList();
  }

  /// Delete by key
  static Future<void> delete<T>(String boxName, String key) async {
    final box = await openBox<T>(boxName);
    await box.delete(key);
  }

  /// Clear entire box
  static Future<void> clear<T>(String boxName) async {
    final box = await openBox<T>(boxName);
    await box.clear();
  }
}
