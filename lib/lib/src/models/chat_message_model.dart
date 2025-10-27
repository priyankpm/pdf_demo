import 'package:freezed_annotation/freezed_annotation.dart';

import '../enum/chat_message_type.dart';

part 'chat_message_model.freezed.dart';

@freezed
abstract class ChatMessageModel with _$ChatMessageModel {
  factory ChatMessageModel({
    required String text,
    required DateTime timestamp,
    required bool isUser,
    required ChatMessageType? messageType,
  }) = _ChatMessageModel;

  const ChatMessageModel._();

  /// ✅ Manual fromJson
  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      text: json['text'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      isUser: json['isUser'] as bool,
      messageType: ChatMessageType.values[json['messageType'] as int? ?? 0],
    );
  }

  /// ✅ Manual toJson
  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'timestamp': timestamp.toIso8601String(),
      'isUser': isUser,
      'messageType': messageType?.index ?? 0,
    };
  }
}
