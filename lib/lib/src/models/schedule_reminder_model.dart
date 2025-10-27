import 'package:freezed_annotation/freezed_annotation.dart';
part 'schedule_reminder_model.freezed.dart';

// Enum for reminder types
enum ReminderType { user, pet }

// Freezed Modela
@freezed
abstract class ReminderModel with _$ReminderModel {
  const factory ReminderModel({
    required String id,
    required String title,
    required String time,
    required String reminderType,
    DateTime? createdAt,
  }) = _ReminderModel;

  const ReminderModel._();

  factory ReminderModel.fromJson(Map<String, dynamic> json) {
    return ReminderModel(
      id: json['ReminderID'] as String,
      title: json['Title'] as String,
      time: json['RemindAt'] as String,
      reminderType: json['ReminderFor'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ReminderID':id,
      'Title': title,
      'RemindAt': time,
      'ReminderFor': reminderType,
    };
  }
}