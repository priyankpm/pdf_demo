
import 'package:hive/hive.dart';

class HiveRepository {
  static const String _audioBoxName = 'audioBox';
  static const String _audioPathKey = 'audioPath';
  static const String _questionsBoxName = 'questionsBox';

  Future<void> saveAudioPath(String path) async {
    final box = await Hive.openBox(_audioBoxName);
    await box.put(_audioPathKey, path);
  }

  Future<String?> getAudioPath() async {
    final box = await Hive.openBox(_audioBoxName);
    return box.get(_audioPathKey);
  }

  Future<void> saveAnswer(String key, String answer) async {
    final box = await Hive.openBox(_questionsBoxName);
    await box.put(key, answer);
  }

  Future<String?> getAnswer(String key) async {
    final box = await Hive.openBox(_questionsBoxName);
    return box.get(key);
  }
}
