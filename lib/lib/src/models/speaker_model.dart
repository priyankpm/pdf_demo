import 'package:freezed_annotation/freezed_annotation.dart';

part 'speaker_model.freezed.dart';

@freezed
abstract class SpeakerModel with _$SpeakerModel {
  factory SpeakerModel({
    required bool? showMuteIcon,
  }) = _SpeakerModel;
  const SpeakerModel._();
}