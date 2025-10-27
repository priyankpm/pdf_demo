import 'package:hive/hive.dart';

import '../../models/schedule_model.dart';
import '../../models/schedule_reminder_model.dart';

class ReminderStorage {
  static const _boxName = 'reminders';

  static Future<void> saveReminder(ReminderModel reminder) async {
    final box = await Hive.openBox(_boxName);
    final reminders = (box.get('reminders', defaultValue: []) as List).cast<Map>();

    // Check if reminder with same id exists
    final index = reminders.indexWhere((r) => r['ReminderID'] == reminder.id);

    if (index >= 0) {
      reminders[index] = reminder.toJson();
      print("🔄 Updated reminder with id: ${reminder.id}");
    } else {
      // Add new reminder
      reminders.add(reminder.toJson());
      print("➕ Added new reminder with id: ${reminder.id}");
    }

    await box.put('reminders', reminders);
  }

  // Add this new method to ReminderStorage class
  static Future<void> updateReminderIdInHive(String oldId, ReminderModel updatedReminder) async {
    final box = await Hive.openBox(_boxName);
    final reminders = (box.get('reminders', defaultValue: []) as List).cast<Map>();

    // Find the reminder with old ID and update it with new ID
    final index = reminders.indexWhere((r) => r['ReminderID'] == oldId);

    if (index >= 0) {
      reminders[index] = updatedReminder.toJson();
      print("🔄 Updated reminder ID from $oldId to ${updatedReminder.id}");
    }

    await box.put('reminders', reminders);
  }

  static Future<List<ReminderModel>> getReminders() async {
    final box = await Hive.openBox(_boxName);
    final reminders = box.get('reminders', defaultValue: []) as List;
    return reminders
        .map((e) => ReminderModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  static Future<List<ReminderModel>> getRemindersByType(ReminderType type) async {
    final allReminders = await getReminders();
    return allReminders.where((r) => r.reminderType == type.name).toList();
  }

  static Future<List<ReminderModel>> getUserReminders([String? userId]) async {
    final reminders = await getRemindersByType(ReminderType.user);
    // // if (userId != null) {
    //   return reminders.where((r) => r.userId == userId).toList();
    // // }
    return reminders;
  }

  static Future<List<ReminderModel>> getPetReminders([String? petId]) async {
    final reminders = await getRemindersByType(ReminderType.pet);
    // // if (petId != null) {
    //   return reminders.where((r) => r.petId == petId).toList();
    // // }
    return reminders;
  }

  static Future<void> deleteReminder(String reminderId) async {
    final box = await Hive.openBox(_boxName);
    final reminders = (box.get('reminders', defaultValue: []) as List).cast<Map>();

    reminders.removeWhere((r) => r['ReminderID'] == reminderId);
    await box.put('reminders', reminders);
    print("🗑️ Deleted reminder with id: $reminderId");
  }

  static Future<void> clearReminders() async {
    final box = await Hive.openBox(_boxName);
    await box.put('reminders', []);
  }

  static Future<void> overwriteReminders(List<ReminderModel> reminders) async {
    final box = await Hive.openBox(_boxName);
    await box.put('reminders', reminders.map((r) => r.toJson()).toList());
  }

  static Future<void> toggleReminderStatus(String reminderId, bool isEnabled) async {
    final reminders = await getReminders();
    final index = reminders.indexWhere((r) => r.id == reminderId);

    if (index >= 0) {
      final updated = reminders[index].copyWith();
      final updatedList = [...reminders];
      updatedList[index] = updated;
      await overwriteReminders(updatedList);
      print("${isEnabled ? '✅' : '⏸️'} Reminder status updated: $reminderId");
    }
  }
}