// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:whiskers_flutter_app/src/models/schedule_model.dart';
//
// import '../../models/schedule_reminder_model.dart';
//
// class ScheduleViewModel extends StateNotifier<ScheduleModel> {
//   ScheduleViewModel(this.ref) : super(ScheduleModel());
//
//   final Ref ref;
//
//   void switchTab(int index) {
//     state = state.copyWith(selectedTab: index);
//   }
//
//   // Add a new task to current tab
//   void addTask(String title, String hour, String minute, bool isAM) {
//     final validation = _validateTimeInputs(title, hour, minute);
//     if (validation != null) {
//       state = state.copyWith(errorMessage: validation);
//       return;
//     }
//
//     final formattedTime = _formatTime(hour, minute, isAM);
//     final newTask = ReminderModel(
//       id: DateTime.now().millisecondsSinceEpoch.toString(),
//       title: title.trim(),
//       time: formattedTime,
//     );
//
//     if (state.selectedTab == 0) {
//       state = state.copyWith(
//         yourReminder: [...state.yourReminder, newTask],
//         errorMessage: null,
//       );
//     } else {
//       state = state.copyWith(
//         petReminder: [...state.petReminder, newTask],
//         errorMessage: null,
//       );
//     }
//   }
//
//   void updateTask(int index, String title, String hour, String minute, bool isAM) {
//     final validation = _validateTimeInputs(title, hour, minute);
//     if (validation != null) {
//       state = state.copyWith(errorMessage: validation);
//       return;
//     }
//
//     final formattedTime = _formatTime(hour, minute, isAM);
//
//     if (state.selectedTab == 0) {
//       final updatedTasks = List<ReminderModel>.from(state.yourReminder);
//       updatedTasks[index] = ReminderModel(
//         id: state.yourReminder[index].id,
//         title: title.trim(),
//         time: formattedTime,
//         userId: 'ss',
//         petId: 'ss'
//       );
//       state = state.copyWith(
//         yourReminder: updatedTasks,
//         errorMessage: null,
//       );
//     } else {
//       final updatedTasks = List<ReminderModel>.from(state.petReminder);
//       updatedTasks[index] = ReminderModel(
//         id: state.petReminder[index].id,
//         title: title.trim(),
//         time: formattedTime,
//       );
//       state = state.copyWith(
//         petReminder: updatedTasks,
//         errorMessage: null,
//       );
//     }
//   }
//
//   void deleteTask(int index) {
//     if (state.selectedTab == 0) {
//       final updatedTasks = List<ReminderModel>.from(state.yourReminder);
//       updatedTasks.removeAt(index);
//       state = state.copyWith(yourReminder: updatedTasks);
//     } else {
//       final updatedTasks = List<ReminderModel>.from(state.petReminder);
//       updatedTasks.removeAt(index);
//       state = state.copyWith(petReminder: updatedTasks);
//     }
//   }
//
//   String? validateHour(String value) {
//     if (value.isEmpty) return 'Hour required';
//     final hour = int.tryParse(value);
//     if (hour == null || hour < 1 || hour > 12) {
//       return 'Enter 1-12';
//     }
//     return null;
//   }
//
//   String? validateMinute(String value) {
//     if (value.isEmpty) return 'Minute required';
//     final minute = int.tryParse(value);
//     if (minute == null || minute < 0 || minute > 59) {
//       return 'Enter 0-59';
//     }
//     return null;
//   }
//
//   String? validateTitle(String value) {
//     if (value.trim().isEmpty) {
//       return 'Title required';
//     }
//     return null;
//   }
//
//   String? _validateTimeInputs(String title, String hour, String minute) {
//     final titleError = validateTitle(title);
//     if (titleError != null) return titleError;
//
//     final hourError = validateHour(hour);
//     if (hourError != null) return hourError;
//
//     final minuteError = validateMinute(minute);
//     if (minuteError != null) return minuteError;
//
//     return null;
//   }
//
//   String _formatTime(String hour, String minute, bool isAM) {
//     final paddedHour = hour.padLeft(2, '0');
//     final paddedMinute = minute.padLeft(2, '0');
//     return '$paddedHour:$paddedMinute${isAM ? "AM" : "PM"}';
//   }
//
//   void clearError() {
//     state = state.copyWith(errorMessage: null);
//   }
//
//   ReminderModel getTask(int index) {
//     return state.currentTasks[index];
//   }
//
//   Map<String, dynamic> parseTime(String time) {
//     final isAM = time.contains('AM');
//     final timePart = time.substring(0, time.length - 2);
//     final parts = timePart.split(':');
//     return {
//       'hour': parts[0],
//       'minute': parts[1],
//       'isAM': isAM,
//     };
//   }
// }


// Example usage in your StateNotifier/Riverpod provider
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:whiskers_flutter_app/src/services/supabase_service.dart';
import 'package:whiskers_flutter_app/src/viewmodel/schedule_screen/schedule_storage.dart';

import '../../models/schedule_model.dart';
import '../../models/schedule_reminder_model.dart';

class ScheduleNotifier extends StateNotifier<ScheduleModel> {
  ScheduleNotifier() : super(ScheduleModel()) {
    init();
  }

  Future<void> init() async {
    try {
      state = state.copyWith(loading: true, errorMessage: null);

      final userReminders = await ReminderStorage.getUserReminders();
      final petReminders = await ReminderStorage.getPetReminders();


      print('====userReminders======${userReminders.length}');
      state = state.copyWith(
        yourReminder: userReminders,
        petReminder: petReminders,
        loading: false,
      );
    } catch (e) {
      state = state.copyWith(
        loading: false,
        errorMessage: 'Error loading reminders: $e',
      );
    }
  }

  String _formatTime(String hour, String minute, bool isAM) {
    final int hour24 = isAM ? (int.parse(hour) % 12) : ((int.parse(hour) % 12) + 12);

    // Format hour and minute into 2-digit string
    final String formattedHour = hour24.toString().padLeft(2, '0');
    final String formattedMinute = minute.toString().padLeft(2, '0');

    // Always seconds as 00, timezone as +05:30
    return "$formattedHour:$formattedMinute:00+05:30";
  }

  String? _validateTimeInputs(String title, String hour, String minute) {
    if (title.isEmpty) {
      return 'Title cannot be empty';
    }
    if (hour.isEmpty || minute.isEmpty) {
      return 'Please enter time';
    }
    final hourInt = int.tryParse(hour);
    final minuteInt = int.tryParse(minute);

    if (hourInt == null || hourInt < 1 || hourInt > 12) {
      return 'Hour must be between 1-12';
    }
    if (minuteInt == null || minuteInt < 0 || minuteInt > 59) {
      return 'Minute must be between 0-59';
    }
    return null;
  }

  // Future<void> addReminder(
  //     String title,
  //     String hour,
  //     String minute,
  //     bool isAM,
  //     BuildContext context,
  //     ) async {
  //   try {
  //     final validation = _validateTimeInputs(title, hour, minute);
  //     if (validation != null) {
  //       state = state.copyWith(errorMessage: validation);
  //       return;
  //     }
  //
  //     final formattedTime = _formatTime(hour, minute, isAM);
  //     final reminderType = state.selectedTab == 0 ? ReminderType.user : ReminderType.pet;
  //
  //     print('==formattedTime====${formattedTime}');
  //     final newReminder = ReminderModel(
  //       id: DateTime.now().millisecondsSinceEpoch.toString(),
  //       title: title.trim(),
  //       time: formattedTime,
  //       reminderType: reminderType,
  //       createdAt: DateTime.now(),
  //       isEnabled: true,
  //     );
  //
  //
  //     log('===newReminder=====$newReminder');
  //
  //     await ReminderStorage.saveReminder(newReminder);
  //     addReminderToSupabase(context,newReminder);
  //     // Update local state
  //     if (state.selectedTab == 0) {
  //       state = state.copyWith(
  //         yourReminder: [...state.yourReminder, newReminder],
  //         errorMessage: null,
  //       );
  //     } else {
  //       state = state.copyWith(
  //         petReminder: [...state.petReminder, newReminder],
  //         errorMessage: null,
  //       );
  //     }
  //   } catch (e) {
  //     state = state.copyWith(errorMessage: 'Error adding reminder: $e');
  //   }
  // }
  //
  //
  // Future<void> addReminderToSupabase(BuildContext context, ReminderModel reminder) async {
  //   log('==reminder.toJson()====${reminder.toJson()}');
  //   final data = await SupabaseService().post(
  //     context,
  //     functionName: 'reminders',
  //     body: reminder.toJson()
  //   );
  //
  //   print('====data=====$data');
  // }
  //

  Future<void> addReminder(
      String title,
      String hour,
      String minute,
      bool isAM,
      BuildContext context,
      ) async {
    try {
      final validation = _validateTimeInputs(title, hour, minute);
      if (validation != null) {
        state = state.copyWith(errorMessage: validation);
        return;
      }

      final formattedTime = _formatTime(hour, minute, isAM);
      final reminderType = state.selectedTab == 0 ? ReminderType.user : ReminderType.pet;

      final newReminder = ReminderModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title.trim(),
        time: formattedTime,
        reminderType: reminderType.name,
        createdAt: DateTime.now(),
      );

      await ReminderStorage.saveReminder(newReminder);

      // Add to Supabase and get the reminder ID
      final reminderIdFromSupabase = await addReminderToSupabase(context, newReminder);

      if (reminderIdFromSupabase != null) {
        final updatedReminder = newReminder.copyWith(
          id: reminderIdFromSupabase,
        );

        // Update local state
        if (state.selectedTab == 0) {
          state = state.copyWith(
            yourReminder: [...state.yourReminder, updatedReminder],
            errorMessage: null,
          );
        } else {
          state = state.copyWith(
            petReminder: [...state.petReminder, updatedReminder],
            errorMessage: null,
          );
        }

        // Update Hive with the new ID
        await ReminderStorage.updateReminderIdInHive(newReminder.id, updatedReminder);

      } else {
        state = state.copyWith(errorMessage: 'Failed to sync reminder with server');
      }
    } catch (e) {
      state = state.copyWith(errorMessage: 'Error adding reminder: $e');
    }
  }

  Future<String?> addReminderToSupabase(BuildContext context, ReminderModel reminder) async {
    try {
      final data = await SupabaseService().post(
          context,
          functionName: 'reminders',
          body: reminder.toJson()
      );

      if (data != null && data is Map) {
        final reminderId = data['data']['ReminderID'] ?? data['ReminderID']; // Adjust based on your API response
        return reminderId?.toString();
      }

      return null;
    } catch (e) {
      log('Error adding reminder to Supabase: $e');
      return null;
    }
  }


  Future<void> updateReminder(
      String reminderId,
      String title,
      String hour,
      String minute,
      bool isAM,
      BuildContext context,
      ) async {
    try {
      final validation = _validateTimeInputs(title, hour, minute);
      log('==validation====$validation');
      print('==validation====$validation');
      if (validation != null) {
        state = state.copyWith(errorMessage: validation);
        return;
      }

      final formattedTime = _formatTime(hour, minute, isAM);
      final allReminders = await ReminderStorage.getReminders();
      final reminderIndex = allReminders.indexWhere((r) {
        print('===r.id == reminderId=====${r.id}=====$reminderId');
        return r.id == reminderId;
      });

      print('===reminderIndex====${reminderIndex}');
      if (reminderIndex >= 0) {
        final updated = allReminders[reminderIndex].copyWith(
          title: title.trim(),
          time: formattedTime,
        );

        // 1. Update local Hive database
        allReminders[reminderIndex] = updated;
        await ReminderStorage.overwriteReminders(allReminders);

        // 2. Update Supabase
        await _updateReminderInSupabase(context, reminderId, updated);

        await init();
      }
    } catch (e) {
      print('===state===e====$e');
      state = state.copyWith(errorMessage: 'Error updating reminder: $e');
    }
  }

  Future<void> _updateReminderInSupabase(
      BuildContext context,
      String reminderId,
      ReminderModel reminder) async {
    try {
      final data = await SupabaseService().patch(
        context,
        functionName: 'reminders/$reminderId',
        body: reminder.toJson(),
      );

      log('==data=====$data');
    } catch (e) {
      log('Error updating reminder in Supabase: $e');
      state = state.copyWith(
        errorMessage: 'Synced locally but failed to update server: $e',
      );
    }
  }

  Future<void> deleteReminder(String reminderId, BuildContext context) async {
    try {
      await ReminderStorage.deleteReminder(reminderId);

      final updatedYour = state.yourReminder
          .where((r) => r.id != reminderId)
          .toList();
      final updatedPet = state.petReminder
          .where((r) => r.id != reminderId)
          .toList();

      state = state.copyWith(
        yourReminder: updatedYour,
        petReminder: updatedPet,
        errorMessage: null,
      );
      await _deleteReminderInSupabase(context, reminderId);
    } catch (e) {
      state = state.copyWith(errorMessage: 'Error deleting reminder: $e');
    }
  }

  Future<void> _deleteReminderInSupabase(
      BuildContext context,
      String reminderId,) async {
    try {
      final data = await SupabaseService().delete(
        context,
        functionName: 'reminders/$reminderId',
      );

      log('==data=====$data');
    } catch (e) {
      log('Error updating reminder in Supabase: $e');
      state = state.copyWith(
        errorMessage: 'Synced locally but failed to update server: $e',
      );
    }
  }

  Future<void> toggleReminder(String reminderId, bool isEnabled) async {
    try {
      await ReminderStorage.toggleReminderStatus(reminderId, isEnabled);
      await init();
    } catch (e) {
      state = state.copyWith(errorMessage: 'Error toggling reminder: $e');
    }
  }

  void switchTab(int tabIndex) {
    state = state.copyWith(selectedTab: tabIndex, errorMessage: null);
  }

  Future<void> clearAllReminders() async {
    try {
      await ReminderStorage.clearReminders();
      state = state.copyWith(
        yourReminder: [],
        petReminder: [],
        errorMessage: null,
      );
    } catch (e) {
      state = state.copyWith(errorMessage: 'Error clearing reminders: $e');
    }
  }

  Map<String, dynamic> parseTime(String timeString) {
    // Expected format: "HH:mm" (24-hour format)
    // Example: "14:30" or "09:15"
    if (timeString.isEmpty) {
      return {'hour': 0, 'minute': 0, 'isAM': true};
    }

    try {

      final parts = timeString.split(':');
      print('=parts.length==${parts.length}');
      if (parts.length != 2) {
        return {'hour': 0, 'minute': 0, 'isAM': true};
      }

      int hour24 = int.parse(parts[0].trim());
      int minute = int.parse(parts[1].split(' ').first.trim());

      // Convert 24-hour to 12-hour format
      bool isAM = hour24 < 12;
      int hour12 = hour24 % 12;
      if (hour12 == 0) {
        hour12 = 12;
      }

      return {
        'hour': hour12,
        'minute': minute,
        'isAM': isAM,
      };
    } catch (e) {
      print('==e====$e');
      return {'hour': 0, 'minute': 0, 'isAM': true};
    }
  }

}