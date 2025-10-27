// class ScheduleModel {
//   final List<ReminderModel> yourReminder;
//   final List<ReminderModel> petReminder;
//   final int selectedTab;
//   final bool loading;
//   final String? errorMessage;
//   final String? petName;
//
//   ScheduleModel({
//     List<ReminderModel>? yourReminder,
//     List<ReminderModel>? petReminder,
//     this.selectedTab = 0,
//     this.loading = false,
//     this.errorMessage,
//     this.petName,
//   })  : yourReminder = yourReminder ?? _defaultYourTasks(),
//         petReminder = petReminder ?? _defaultJoeyTasks();
//
//   static List<ReminderModel> _defaultYourTasks() {
//     return [
//       ReminderModel(id: '1', title: "Wake Up", time: "09:00AM"),
//       ReminderModel(id: '2', title: "Sleep", time: "10:00PM"),
//       ReminderModel(id: '3', title: "Eat", time: "02:00PM"),
//       ReminderModel(id: '4', title: "Playtime", time: "06:00PM"),
//     ];
//   }
//
//   static List<ReminderModel> _defaultJoeyTasks() {
//     return [
//       ReminderModel(id: '5', title: "Feeding Time", time: "08:00AM"),
//       ReminderModel(id: '6', title: "Walk", time: "07:00PM"),
//       ReminderModel(id: '7', title: "Playtime", time: "05:00PM"),
//       ReminderModel(id: '8', title: "Bedtime", time: "09:00PM"),
//     ];
//   }
//
//   List<ReminderModel> get currentTasks =>
//       selectedTab == 0 ? yourReminder : petReminder;
//
//   ScheduleModel copyWith({
//     List<ReminderModel>? yourReminder,
//     List<ReminderModel>? petReminder,
//     int? selectedTab,
//     bool? loading,
//     String? errorMessage,
//     String? petName,
//   }) {
//     return ScheduleModel(
//       yourReminder: yourReminder ?? this.yourReminder,
//       petReminder: petReminder ?? this.petReminder,
//       selectedTab: selectedTab ?? this.selectedTab,
//       loading: loading ?? this.loading,
//       errorMessage: errorMessage,
//       petName: petName,
//     );
//   }
// }
//
// class ReminderModel {
//   final String id;
//   final String title;
//   final String time;
//
//   ReminderModel({
//     required this.id,
//     required this.title,
//     required this.time,
//   });
//
//   ReminderModel copyWith({
//     String? id,
//     String? title,
//     String? time,
//   }) {
//     return ReminderModel(
//       id: id ?? this.id,
//       title: title ?? this.title,
//       time: time ?? this.time,
//     );
//   }
//
//   Map<String, String> toMap() {
//     return {
//       'id': id,
//       'title': title,
//       'time': time,
//     };
//   }
// }

import 'package:whiskers_flutter_app/src/models/schedule_reminder_model.dart';

class ScheduleModel {
  final List<ReminderModel> yourReminder;
  final List<ReminderModel> petReminder;
  final int selectedTab;
  final bool loading;
  final String? errorMessage;
  final String? petName;
  final String? userId;
  final String? petId;

  ScheduleModel({
    List<ReminderModel>? yourReminder,
    List<ReminderModel>? petReminder,
    this.selectedTab = 0,
    this.loading = false,
    this.errorMessage,
    this.petName,
    this.userId,
    this.petId,
  })  : yourReminder = yourReminder ?? [],
        petReminder = petReminder ?? [];

  List<ReminderModel> get currentReminders =>
      selectedTab == 0 ? yourReminder : petReminder;

  ScheduleModel copyWith({
    List<ReminderModel>? yourReminder,
    List<ReminderModel>? petReminder,
    int? selectedTab,
    bool? loading,
    String? errorMessage,
    String? petName,
    String? userId,
    String? petId,
  }) {
    return ScheduleModel(
      yourReminder: yourReminder ?? this.yourReminder,
      petReminder: petReminder ?? this.petReminder,
      selectedTab: selectedTab ?? this.selectedTab,
      loading: loading ?? this.loading,
      errorMessage: errorMessage,
      petName: petName ?? this.petName,
      userId: userId ?? this.userId,
      petId: petId ?? this.petId,
    );
  }
}
