import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:whiskers_flutter_app/src/enum/emotion_type.dart';

import '../enum/pet_activity_enum.dart';

part 'emotion_video_model.freezed.dart';

@freezed
abstract class EmotionVideoModel with _$EmotionVideoModel {
  factory EmotionVideoModel({
    required EmotionType? emotionType,
    required String? introVideo,
    required String? loopVideo,
    required String? outroVideo,
    required String? images,
  }) = _EmotionVideoModel;
  const EmotionVideoModel._();
}