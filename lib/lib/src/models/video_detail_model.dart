import 'package:freezed_annotation/freezed_annotation.dart';

import '../enum/pet_activity_enum.dart';

part 'video_detail_model.freezed.dart';

@freezed
abstract class VideoDetailModel with _$VideoDetailModel {
  factory VideoDetailModel({
    required String? name,
    required String? videoPath,
  }) = _VideoDetailModel;
  const VideoDetailModel._();
}