import 'dart:developer';
import 'dart:io';
import 'dart:typed_data'; // For Uint8List, ByteData
import 'dart:ui' as ui; // For Image, ImageByteFormat

import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:whiskers_flutter_app/src/viewmodel/base_viewmodel.dart';

import '../../common_utility/common_utility.dart';
import '../../enum/memory_frame_type.dart';
import '../../models/memory_frame_model.dart';
import '../../provider.dart';
import '../../services/supabase_service.dart';
import 'memory_frame_storage.dart';

class MemoryWallViewModel extends BaseViewModel<List<MemoryFrameModel>> {
  MemoryWallViewModel(this.ref) : super([]);

  final Ref ref;
  final GlobalKey stackKey = GlobalKey();
  String userId = '';

  @override
  Future<void> init({String docId = ''}) async {
    final items = await MemoryFrameStorage.getFrames();
    final sharedPreferencesService = ref.read(sharedPreferencesServiceProvider);
    userId = await sharedPreferencesService.getUserId() ?? '';
    log('==items====$items');
    if (items.isEmpty) {
      state = [getSampleMemoryModel()];
    } else {
      final hasEmptyFrame = items.any((frame) => frame.imagePath.isEmpty);
      if (hasEmptyFrame) {
        state = items;
      } else {
        state = [...items, getSampleMemoryModel()];
      }
    }
  }

  @override
  void notifyChanges(List<MemoryFrameModel> model) {
    state = [...model];
  }

  // Future<void> addOrUpdateFrame(MemoryFrameModel frame) async {
  //   final frames = await MemoryFrameStorage.getFrames();
  //   final index = frames.indexWhere((f) => f.id == frame.id);
  //
  //   if (index != -1) {
  //     // Update existing frame
  //     frames[index] = frame;
  //     await MemoryFrameStorage.overwriteFrames(frames);
  //   } else {
  //     // Add new frame
  //     await MemoryFrameStorage.saveFrame(frame);
  //   }
  //
  //   // After adding or updating, check if we need to add a new empty frame
  //   final updatedFrames = await MemoryFrameStorage.getFrames();
  //   if (updatedFrames.every((f) => f.imagePath.isNotEmpty)) {
  //     final newFrame = getSampleMemoryModel(id: DateTime.now().millisecondsSinceEpoch.toString());
  //     log('==newFrame===${newFrame.toJson()}');
  //     await MemoryFrameStorage.saveFrame(newFrame);
  //     addMemoryRequestSupabase(newFrame);
  //   }
  //
  //   await init();
  // }
  //
  //
  // Future<void> deleteFrame(String id) async {
  //   final frames = await MemoryFrameStorage.getFrames();
  //   final updated = frames.where((f) => f.id != id).toList();
  //   // overwrite the box with updated list
  //   await MemoryFrameStorage.overwriteFrames(updated);
  //   await init();
  // }

  // Updated Memory Wall Controller with Supabase Sync

  Future<void> addOrUpdateFrame(
    MemoryFrameModel frame,
    BuildContext context,
  ) async {
    try {
      final frames = await MemoryFrameStorage.getFrames();
      final index = frames.indexWhere((f) => f.id == frame.id);

      if (index != -1) {
        await updateFrame(frame.id ?? '', frame, context);
      } else {
        await addFrame(frame, context);
      }

      // final updatedFrames = await MemoryFrameStorage.getFrames();
      // if (updatedFrames.every((f) => f.imagePath.isNotEmpty)) {
      //   final newFrame = getSampleMemoryModel(
      //     id: DateTime.now().millisecondsSinceEpoch.toString(),
      //   );
      //   await MemoryFrameStorage.saveFrame(newFrame);
      // }

      await init();
    } catch (e) {
      log('Error in addOrUpdateFrame: $e');
      // state = state.copyWith(errorMessage: 'Error processing frame: $e');
    }
  }

  Future<void> addFrame(MemoryFrameModel frame, BuildContext context) async {
    try {
      await MemoryFrameStorage.saveFrame(frame);
      final frameIdFromSupabase = await addFrameToSupabase(context, frame);

      if (frameIdFromSupabase != null) {
        final updatedFrame = frame.copyWith(id: frameIdFromSupabase);

        await MemoryFrameStorage.updateFrameIdInHive(
          frame.id ?? '',
          updatedFrame,
        );

        state = [...state, updatedFrame];

        log('Frame added successfully with ID: $frameIdFromSupabase');
      } else {
        log('Failed to sync frame with server');
      }
    } catch (e) {
      log('Error adding frame: $e');
    }
  }

  Future<String?> addFrameToSupabase(
    BuildContext context,
    MemoryFrameModel frame,
  ) async {
    try {
      final data = await SupabaseService().post(
        context,
        functionName: 'memories',
        body: frame.toApiJson(),
      );

      print('===data====add====$data');
      if (data != null && data is Map) {
        final frameId = data['data'][0]['MemoryID'] ?? data['MemoryID'];
        return frameId?.toString();
      }

      return null;
    } catch (e) {
      log('Error adding frame to Supabase: $e');
      return null;
    }
  }

  Future<void> updateFrame(
    String frameId,
    MemoryFrameModel updatedFrame,
    BuildContext context,
  ) async {
    try {
      final allFrames = await MemoryFrameStorage.getFrames();
      final frameIndex = allFrames.indexWhere((f) => f.id == frameId);

      log('==frameIndex====$frameIndex');

      if (frameIndex >= 0) {
        // 1. Update local Hive database
        allFrames[frameIndex] = updatedFrame;
        await MemoryFrameStorage.overwriteFrames(allFrames);

        // 2. Update Supabase
        await _updateFrameInSupabase(context, frameId, updatedFrame);

        // 3. Refresh state
        await init();

        log('Frame updated successfully: $frameId');
      } else {
        log('Frame not found: $frameId');
      }
    } catch (e) {
      log('Error updating frame: $e');
    }
  }

  Future<void> _updateFrameInSupabase(
    BuildContext context,
    String frameId,
    MemoryFrameModel frame,
  ) async {
    try {

      print('==frame.toApiJson()====${frame.toApiJson()}');
      final data = await SupabaseService().patch(
        context,
        functionName: 'memories/$frameId',
        body: frame.toApiJson(),
      );

      log('==data=====$data');
    } catch (e) {
      log('Error updating frame in Supabase: $e');
    }
  }

  Future<void> deleteFrame(String frameId, BuildContext context) async {
    try {
      // 1. Delete from local Hive storage
      await MemoryFrameStorage.deleteFrame(frameId);
      debugPrint('frameId==========>>>>>${frameId}');

      // 2. Update local state - state is List<MemoryFrameModel>
      state = state.where((f) => f.id != frameId).toList();

      // 3. Delete from Supabase
      await _deleteFrameInSupabase(context, frameId);

      log('🗑️ Frame deleted successfully: $frameId');
    } catch (e) {
      log('Error deleting frame: $e');
    }
  }

  Future<void> _deleteFrameInSupabase(
    BuildContext context,
    String frameId,
  ) async {
    try {
      final data = await SupabaseService().post(
        context,
        functionName: 'delete-memory',
        body: {"memory_id": frameId},
      );

      log('==data=====$data');
    } catch (e) {
      log('Error deleting frame in Supabase: $e');
    }
  }

  MemoryFrameModel getSampleMemoryModel({String id = 'id'}) {
    return MemoryFrameModel(
      id: id,
      imagePath: '',
      framePath: goldenPhotoFrame,
      title: "",
      memoryFrameType: MemoryFrameType.rectangle.name,
      createdAt: DateTime.now(),
      imageId: userId,
    );
  }

  Future<Uint8List?> captureStackImage() async {
    try {
      RenderRepaintBoundary boundary =
          stackKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );
      return byteData?.buffer.asUint8List();
    } catch (e) {
      print("Error capturing image: $e");
      return null;
    }
  }

  Future<void> shareCapturedImage(Uint8List imageBytes) async {
    // Save image temporarily
    final dir = await getTemporaryDirectory();
    final filePath = '${dir.path}/shared_image.png';
    final file = File(filePath);
    await file.writeAsBytes(imageBytes);

    final params = ShareParams(
      text: 'Check out this memory frame!',
      files: [XFile(filePath)],
    );

    final result = await SharePlus.instance.share(params);
    if (result.status == ShareResultStatus.success) {
      print('Shared successfully!');
    } else {
      print('Share was not completed.');
    }
  }
}

// 1. Overflow errors on the login screen
// 2. Working back button - done
// 3. Overflow issues in the speech bubble- done
// 4. Non-adherence to the Figma Design in the chat screen - done
// 5. Error in showing profile on the chat page (the cat is literally outside the profile circle, come on) - done
// 6. Fix the background on the food in the eat screen (it really isn't that difficult to show the image without a background) - done
// 7. Memory wall works nothing like the ticket describes, why are there only 2 static frames - done
// 8. Why are the frames not increasing as I add memories - done
// 9. Why is there no share button in the Memory edit screen - done
// 10. Why does the memory not expand once set - done
// 11. Where is the title field in the memory? - done
// 12. Why is the navigation bar incorrect? (This is a simple fix, why has it always been wrong?)
// 13. Why is the custom background mode cropping in 9:16 instead of 16:9 (I am willing to excuse this error but still why is something like this not tested)
// 14. In the count sheep game why is the sheep UI the same as the one that I'd rejected last time (I've personally made the design for that since gazal was busy just to illustrate what I needed) - done
// 15. Why does the count sheep game, once over, not collapse and change the image? (These are mentioned quite clearly in the ticket) - done
// 16. And where are the image upload screens that you told me you've finished? - done
// 17. Why is the video is the chat not scales as I'd explained on call?- done
// 18. Why is there a loader spinning when I explicitly told you to remove it - done
