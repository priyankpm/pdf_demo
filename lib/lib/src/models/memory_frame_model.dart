import 'package:freezed_annotation/freezed_annotation.dart';
part 'memory_frame_model.freezed.dart';

@freezed
abstract class MemoryFrameModel with _$MemoryFrameModel {
  const factory MemoryFrameModel({
    String? id,
    required String imagePath,
    String? imageId,
    required String framePath,
    required String title,
    String? memoryFrameType,
    DateTime? createdAt,
    int? shares,
    String? petId,
    String? userId,
    bool? IsFromApp,
  }) = _MemoryFrameModel;

  const MemoryFrameModel._();

  factory MemoryFrameModel.fromJson(Map<String, dynamic> json) {
    print('==json===${json}');
    return MemoryFrameModel(
      id: json['MemoryID'] as String?,
      title: (json['Caption'] ?? '') as String,
      imageId: json['ImageID'] as String?,
      shares: json['Shares'] as int? ?? 0,
      petId: json['PetID'] as String?,
      userId: json['UserID'] as String?,
      imagePath: json['ImagePath'] as String? ?? '',
      framePath: json['FramePath'] as String? ?? '',
      memoryFrameType: json['FrameType'] as String?,
      IsFromApp: json['IsFromApp'] as bool? ?? false,
      createdAt: json['AddedOn'] != null
          ? DateTime.tryParse(json['AddedOn'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'MemoryID': id,
      'ImagePath': imagePath,
      'ImageID': imageId,
      'FramePath': framePath,
      'Caption': title,
      'FrameType': memoryFrameType,
      'Shares': shares,
      'PetID': petId,
      'IsFromApp': IsFromApp
    };
  }

  Map<String, dynamic> toApiJson() {
    return {
      // 'MemoryID': id,
      'ImagePath': imagePath,
      'ImageID': imageId,
      'FramePath': framePath,
      'Caption': title,
      'FrameType': memoryFrameType,
      'Shares': shares,
      'PetID': petId,
      'IsFromApp': IsFromApp
    };
  }
}
