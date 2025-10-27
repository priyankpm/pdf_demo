// import 'dart:async';
// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:whiskers_flutter_app/src/models/memory_frame_model.dart';
// import 'package:whiskers_flutter_app/src/provider.dart';
// import 'package:whiskers_flutter_app/src/styles/resources.dart';
// import 'package:whiskers_flutter_app/src/styles/utils/app_styles.dart';
//
// import '../../../common_utility/common_utility.dart';
// import '../../../viewmodel/video/memory_wall_viewmodel.dart';
//
// class MemoryEditScreen extends ConsumerStatefulWidget {
//   const MemoryEditScreen({super.key, required this.memoryFrameModel});
//
//   final MemoryFrameModel memoryFrameModel;
//
//   @override
//   MemoryEditScreenState createState() => MemoryEditScreenState();
// }
//
// class MemoryEditScreenState extends ConsumerState<MemoryEditScreen> {
//   late final Resources _res;
//   late final TextEditingController nameController;
//   final TextEditingController descriptionController = TextEditingController();
//   final GlobalKey<FormState> nameGlobalKey = GlobalKey<FormState>();
//   final GlobalKey<FormState> descriptionGlobalKey = GlobalKey<FormState>();
//   final ScrollController scrollController = ScrollController();
//   late MemoryFrameModel memoryFrameModel;
//   late final MemoryWallViewModel memoryWallViewModel;
//
//   // Track original title to detect changes
//   late String originalTitle;
//   bool _isTitleChanged = false;
//   bool showFrameView = true;
//
//   @override
//   void initState() {
//     super.initState();
//     memoryFrameModel = widget.memoryFrameModel;
//     memoryWallViewModel = ref.read(memoryFrameProvider.notifier);
//     _res = ref.read(resourceProvider);
//
//     originalTitle = memoryFrameModel.title;
//     nameController = TextEditingController(text: memoryFrameModel.title);
//     descriptionController.text = memoryFrameModel.description;
//
//     // Listen to title changes
//     nameController.addListener(_checkTitleChange);
//   }
//
//   void _checkTitleChange() {
//     setState(() {
//       _isTitleChanged = nameController.text.trim() != originalTitle.trim();
//     });
//   }
//
//   @override
//   void dispose() {
//     nameController.removeListener(_checkTitleChange);
//     nameController.dispose();
//     descriptionController.dispose();
//     scrollController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         ref.read(navigationServiceProvider).goBack(result: false);
//         return false;
//       },
//       child: MaterialApp(
//         theme: ThemeData(primarySwatch: Colors.blue),
//         home: Scaffold(
//           resizeToAvoidBottomInset: false,
//           bottomNavigationBar: SafeArea(
//             child: Padding(
//               padding: EdgeInsets.only(left: 22, right: 22),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   IconButton(
//                     onPressed: () async {
//                       final bytes = await memoryWallViewModel
//                           .captureStackImage();
//                       if (bytes != null) {
//                         await memoryWallViewModel.shareCapturedImage(bytes);
//                       }
//                     },
//                     icon: Container(
//                       height: 55,
//                       width: 55,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: Colors.white.withValues(alpha: 0.2),
//                       ),
//                       child: Center(
//                         child: SvgPicture.asset(shareIcon, height: 25),
//                       ),
//                     ),
//                   ),
//                   IconButton(
//                     onPressed: () {},
//                     icon: Container(
//                       height: 55,
//                       width: 55,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: Colors.white.withValues(alpha: 0.2),
//                       ),
//                       child: Center(
//                         child: SvgPicture.asset(deleteIcon, height: 25),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           appBar: AppBar(
//             centerTitle: true,
//             backgroundColor: Colors.black,
//             title: TextField(
//               cursorColor: _res.themes.lightOrange40,
//               controller: nameController,
//               keyboardType: TextInputType.name,
//               style: const TextStyle(color: Colors.white, fontSize: 16),
//               textAlign: TextAlign.center,
//               decoration: InputDecoration(
//                 hintText: originalTitle.isEmpty ? "Add Title" : originalTitle,
//                 fillColor: Colors.white,
//                 hintStyle: TextStyle(color: Colors.white),
//                 enabledBorder: InputBorder.none,
//                 focusedBorder: InputBorder.none,
//               ),
//             ),
//             toolbarHeight: 72,
//             leading: GestureDetector(
//               onTap: () {
//                 ref.read(navigationServiceProvider).goBack(result: false);
//               },
//               child: Padding(
//                 padding: const EdgeInsets.only(left: 12.0),
//                 child: Center(
//                   child: Container(
//                     width: 35,
//                     height: 35,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       border: Border.all(color: Colors.white, width: 2),
//                     ),
//                     child: SizedBox(
//                       width: 12,
//                       height: 12,
//                       child: Center(
//                         child: SvgPicture.asset(
//                           crossIconSvg,
//                           fit: BoxFit.contain,
//                           width: 12,
//                           height: 12,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             actions: [
//               // Only show Save button if title is changed
//               if (_isTitleChanged)
//                 GestureDetector(
//                   onTap: () async {
//                     final MemoryFrameModel localMFM = memoryFrameModel.copyWith(
//                       description: descriptionController.text.trim(),
//                       title: nameController.text.trim(),
//                     );
//                     await ref
//                         .read(memoryFrameProvider.notifier)
//                         .addOrUpdateFrame(localMFM);
//
//                     // Update the original title after successful save
//                     setState(() {
//                       originalTitle = nameController.text.trim();
//                       _isTitleChanged = false;
//                       memoryFrameModel = localMFM;
//                     });
//
//                     ref.read(navigationServiceProvider).goBack(result: true);
//                   },
//                   child: Padding(
//                     padding: const EdgeInsets.only(right: 14),
//                     child: Text(
//                       "Save",
//                       style: AppTextStyle().commonTextStyle(
//                         textColor: Colors.white,
//                         fontSize: 15,
//                       ),
//                     ),
//                   ),
//                 )
//               else
//                 SizedBox(width: 35),
//             ],
//           ),
//           backgroundColor: Colors.black,
//           body: _buildMobileView(),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildMobileView() {
//     return Stack(
//       children: [
//         Center(
//           child: RepaintBoundary(
//             key: memoryWallViewModel.stackKey,
//             child: showFrameView ? _buildFramedImage() : _buildNormalImage(),
//           ),
//         ),
//         CustomSwappingButtons(
//           showLeftButton: !showFrameView,
//           showRightButton: showFrameView,
//           leftCallback: () {
//             setState(() {
//               showFrameView = true;
//             });
//           },
//           rightCallback: () {
//             setState(() {
//               showFrameView = false;
//             });
//           },
//         ),
//       ],
//     );
//   }
//
//   Widget _buildFramedImage() {
//     return FutureBuilder<ImageInfo>(
//       future: _getImageInfo(memoryFrameModel.framePath),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) {
//           return Container(
//             color: Colors.black,
//             child: Center(child: CircularProgressIndicator()),
//           );
//         }
//
//         final imageInfo = snapshot.data!;
//         final frameWidth = imageInfo.image.width.toDouble();
//         final frameHeight = imageInfo.image.height.toDouble();
//         final aspectRatio = frameWidth / frameHeight;
//
//         return LayoutBuilder(
//           builder: (context, constraints) {
//             final width = constraints.maxWidth;
//
//             final padding = _getFramePadding(
//               memoryFrameModel.framePath,
//               width,
//               aspectRatio,
//             );
//
//             return SizedBox(
//               width: width,
//               child: AspectRatio(
//                 aspectRatio: aspectRatio,
//                 child: Stack(
//                   fit: StackFit.expand,
//                   children: <Widget>[
//                     Padding(
//                       padding: padding,
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(8),
//                         child: Image.file(
//                           File(memoryFrameModel.imagePath),
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                     ),
//                     Image.asset(memoryFrameModel.framePath, fit: BoxFit.fill),
//                   ],
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
//
//   Widget _buildNormalImage() {
//     return SizedBox(
//       width: double.infinity,
//       height: double.infinity,
//       child: Image.file(
//         File(memoryFrameModel.imagePath),
//         fit: BoxFit.fitWidth,
//         width: double.infinity,
//       ),
//     );
//   }
//
//   EdgeInsets _getFramePadding(
//     String framePath,
//     double width,
//     double aspectRatio,
//   ) {
//     if (framePath.contains('goldenPhotoFrame_1')) {
//       final horizontal = width * 0.085;
//       final vertical = horizontal / aspectRatio;
//       return EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical);
//     } else if (framePath.contains('goldenPhotoFrame')) {
//       final horizontal = width * 0.08;
//       final vertical = horizontal / aspectRatio;
//       return EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical);
//     } else if (framePath.contains('landscapeFrame_1')) {
//       final horizontal = width * 0.075;
//       final vertical = horizontal / aspectRatio;
//       return EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical);
//     } else if (framePath.contains('landscapeFrame')) {
//       final horizontal = width * 0.095;
//       final vertical = horizontal / aspectRatio;
//       return EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical);
//     } else if (framePath.contains('portraitFrame_1')) {
//       final horizontal = width * 0.08;
//       final vertical = horizontal / aspectRatio;
//       return EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical);
//     } else if (framePath.contains('portraitFrame')) {
//       final horizontal = width * 0.07;
//       final vertical = horizontal / aspectRatio;
//       return EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical);
//     }
//
//     final horizontal = width * 0.08;
//     final vertical = horizontal / aspectRatio;
//     return EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical);
//   }
//
//   Future<ImageInfo> _getImageInfo(String assetPath) async {
//     final AssetImage assetImage = AssetImage(assetPath);
//     final Completer<ImageInfo> completer = Completer();
//
//     assetImage
//         .resolve(ImageConfiguration())
//         .addListener(
//           ImageStreamListener((info, _) {
//             if (!completer.isCompleted) {
//               completer.complete(info);
//             }
//           }),
//         );
//
//     return completer.future;
//   }
// }
//
// class CustomSwappingButtons extends StatelessWidget {
//   const CustomSwappingButtons({
//     required this.leftCallback,
//     required this.rightCallback,
//     this.showLeftButton = true,
//     this.showRightButton = true,
//     super.key,
//   });
//
//   final VoidCallback leftCallback;
//   final VoidCallback rightCallback;
//   final bool showLeftButton;
//   final bool showRightButton;
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: <Widget>[
//         if (showLeftButton)
//           Align(
//             alignment: Alignment.centerLeft,
//             child: GestureDetector(
//               onTap: leftCallback,
//               child: Container(
//                 width: 30,
//                 height: 63,
//                 decoration: BoxDecoration(
//                   color: Colors.white54,
//                   borderRadius: BorderRadius.only(
//                     topRight: Radius.circular(9),
//                     bottomRight: Radius.circular(9),
//                   ),
//                   border: Border.all(color: Colors.black, width: 1.0),
//                 ),
//                 child: Center(
//                   child: SvgPicture.asset(
//                     leftArrowSvg,
//                     width: 15,
//                     height: 15,
//                     fit: BoxFit.contain,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         if (showRightButton)
//           Align(
//             alignment: Alignment.centerRight,
//             child: GestureDetector(
//               onTap: rightCallback,
//               child: Container(
//                 width: 30,
//                 height: 63,
//                 decoration: BoxDecoration(
//                   color: Colors.white54,
//                   borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(9),
//                     bottomLeft: Radius.circular(9),
//                   ),
//                   border: Border.all(color: Colors.black, width: 1.0),
//                 ),
//                 child: Center(
//                   child: SvgPicture.asset(
//                     rightArrowSvg,
//                     width: 15,
//                     height: 15,
//                     fit: BoxFit.contain,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//       ],
//     );
//   }
// }


import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:whiskers_flutter_app/src/models/memory_frame_model.dart';
import 'package:whiskers_flutter_app/src/provider.dart';
import 'package:whiskers_flutter_app/src/styles/resources.dart';
import 'package:whiskers_flutter_app/src/styles/utils/app_styles.dart';

import '../../../common_utility/common_utility.dart';
import '../../../viewmodel/video/memory_wall_viewmodel.dart';

class MemoryEditScreen extends ConsumerStatefulWidget {
  const MemoryEditScreen({super.key, required this.memoryFrameModel});

  final MemoryFrameModel memoryFrameModel;

  @override
  MemoryEditScreenState createState() => MemoryEditScreenState();
}

class MemoryEditScreenState extends ConsumerState<MemoryEditScreen>
    with WidgetsBindingObserver {
  late final Resources _res;
  late final TextEditingController nameController;
  final GlobalKey<FormState> nameGlobalKey = GlobalKey<FormState>();
  final GlobalKey<FormState> descriptionGlobalKey = GlobalKey<FormState>();
  final ScrollController scrollController = ScrollController();
  late MemoryFrameModel memoryFrameModel;
  late final MemoryWallViewModel memoryWallViewModel;

  // New variables for floating text field
  final FocusNode _floatingFocusNode = FocusNode();
  bool _isKeyboardVisible = false;
  bool _showFloatingTextField = false;

  // Track original title to detect changes
  late String originalTitle;
  bool _isTitleChanged = false;
  bool showFrameView = true;

  @override
  void initState() {
    super.initState();
    memoryFrameModel = widget.memoryFrameModel;
    memoryWallViewModel = ref.read(memoryFrameProvider.notifier);
    _res = ref.read(resourceProvider);

    originalTitle = memoryFrameModel.title;
    nameController = TextEditingController(text: memoryFrameModel.title);

    nameController.addListener(_checkTitleChange);
    WidgetsBinding.instance.addObserver(this);

    _floatingFocusNode.addListener(() {
      if (!_floatingFocusNode.hasFocus) {
        setState(() => _showFloatingTextField = false);
      }
    });
  }

  void _checkTitleChange() {
    setState(() {
      _isTitleChanged = nameController.text.trim() != originalTitle.trim();
    });
  }

  @override
  void dispose() {
    nameController.removeListener(_checkTitleChange);
    nameController.dispose();
    scrollController.dispose();
    _floatingFocusNode.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final bottomInset = WidgetsBinding.instance.window.viewInsets.bottom;
    final newValue = bottomInset > 0.0;
    if (newValue != _isKeyboardVisible) {
      setState(() => _isKeyboardVisible = newValue);
    }
  }

  void _onEditDescriptionTap() {
    setState(() => _showFloatingTextField = true);
    Future.delayed(const Duration(milliseconds: 100), () {
      FocusScope.of(context).requestFocus(_floatingFocusNode);
    });
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return WillPopScope(
      onWillPop: () async {
        ref.read(navigationServiceProvider).goBack(result: false);
        return false;
      },
      child: MaterialApp(
        theme: ThemeData(primarySwatch: Colors.blue),
        home: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.black,
          appBar: _buildAppBar(),
          body: Stack(
            children: [
              _buildMobileView(),
            ],
          ),
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Share Button
                  IconButton(
                    onPressed: () async {
                      final bytes =
                      await memoryWallViewModel.captureStackImage();
                      if (bytes != null) {
                        await memoryWallViewModel.shareCapturedImage(bytes);
                      }
                    },
                    icon: Container(
                      height: 55,
                      width: 55,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.2),
                      ),
                      child: Center(
                        child: SvgPicture.asset(shareIcon, height: 25),
                      ),
                    ),
                  ),

                  // Delete Button
                  IconButton(
                    onPressed: _showDeleteConfirmationDialog,
                    icon: Container(
                      height: 55,
                      width: 55,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.2),
                      ),
                      child: Center(
                        child: SvgPicture.asset(deleteIcon, height: 25),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      centerTitle: true,
      backgroundColor: Colors.black,
      title: TextField(
        cursorColor: _res.themes.lightOrange40,
        controller: nameController,
        keyboardType: TextInputType.name,
        style: const TextStyle(color: Colors.white, fontSize: 16),
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          hintText: originalTitle.isEmpty ? "Add Title" : originalTitle,
          hintStyle: const TextStyle(color: Colors.white),
          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
        ),
      ),
      toolbarHeight: 72,
      leading: GestureDetector(
        onTap: () {
          ref.read(navigationServiceProvider).goBack(result: false);
        },
        child: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: Center(
            child: Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Center(
                child: SvgPicture.asset(
                  crossIconSvg,
                  fit: BoxFit.contain,
                  width: 12,
                  height: 12,
                ),
              ),
            ),
          ),
        ),
      ),
      actions: [
        if (_isTitleChanged)
          GestureDetector(
            onTap: () async {
              final MemoryFrameModel localMFM = memoryFrameModel.copyWith(
                title: nameController.text.trim(),
                petId: 'b3513ad2-9352-4237-9dee-9ca80ede5f00',
              );

              print('==localMFM===${localMFM}');

              await ref
                  .read(memoryFrameProvider.notifier)
                  .addOrUpdateFrame(localMFM, context);

              setState(() {
                originalTitle = nameController.text.trim();
                _isTitleChanged = false;
                memoryFrameModel = localMFM;
              });

              ref.read(navigationServiceProvider).goBack(result: true);
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 14),
              child: Text(
                "Save",
                style: AppTextStyle().commonTextStyle(
                  textColor: Colors.white,
                  fontSize: 15,
                ),
              ),
            ),
          )
        else
          const SizedBox(width: 35),
      ],
    );
  }

  Widget _buildMobileView() {
    return Stack(
      children: [
        Center(
          child: RepaintBoundary(
            key: memoryWallViewModel.stackKey,
            child: showFrameView ? _buildFramedImage() : _buildNormalImage(),
          ),
        ),
        CustomSwappingButtons(
          showLeftButton: !showFrameView,
          showRightButton: showFrameView,
          leftCallback: () {
            setState(() {
              showFrameView = true;
            });
          },
          rightCallback: () {
            setState(() {
              showFrameView = false;
            });
          },
        ),
      ],
    );
  }

  Widget _buildFramedImage() {
    return FutureBuilder<ImageInfo>(
      future: _getImageInfo(memoryFrameModel.framePath ?? ''),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container(
            color: Colors.black,
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        final imageInfo = snapshot.data!;
        final frameWidth = imageInfo.image.width.toDouble();
        final frameHeight = imageInfo.image.height.toDouble();
        final aspectRatio = frameWidth / frameHeight;

        return LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final padding =
            _getFramePadding(memoryFrameModel.framePath ?? '', width, aspectRatio);

            return SizedBox(
              width: width,
              child: AspectRatio(
                aspectRatio: aspectRatio,
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    Padding(
                      padding: padding,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          File(memoryFrameModel.imagePath ?? ''),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Image.asset(memoryFrameModel.framePath, fit: BoxFit.fill),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildNormalImage() {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Image.file(
        File(memoryFrameModel.imagePath),
        fit: BoxFit.fitWidth,
        width: double.infinity,
      ),
    );
  }

  EdgeInsets _getFramePadding(String framePath, double width, double aspectRatio) {
    final horizontal = width * 0.08;
    final vertical = horizontal / aspectRatio;
    return EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical);
  }

  Future<ImageInfo> _getImageInfo(String assetPath) async {
    final AssetImage assetImage = AssetImage(assetPath);
    final Completer<ImageInfo> completer = Completer();

    assetImage.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((info, _) {
        if (!completer.isCompleted) {
          completer.complete(info);
        }
      }),
    );

    return completer.future;
  }

  Future<void> _showDeleteConfirmationDialog() async {
    if (!mounted) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _res.themes.paleGrey,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Delete Memory",
              style: AppTextStyle().commonTextStyle(
                fontSize: 18,
                appFontStyle: AppFontStyle.bold,
                textColor: _res.themes.blackPure,
              ),
            ),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.05),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close,
                  size: 18,
                  color: Color(0xFF666666),
                ),
              ),
            ),
          ],
        ),
        contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
        content: Text(
          "Are you sure you want to delete this memory? This action cannot be undone.",
          style: AppTextStyle().commonTextStyle(
            textColor: _res.themes.black120,
          ),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
        actions: [
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: const Color(0xFFE5E5E5),
                        width: 1.5,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "Cancel",
                        style: AppTextStyle().commonTextStyle(
                          textColor: _res.themes.blackPure,
                          appFontStyle: AppFontStyle.medium,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    await ref
                        .read(memoryFrameProvider.notifier)
                        .deleteFrame(memoryFrameModel.id ?? '', context);
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 45,
                    decoration: BoxDecoration(
                      gradient: _res.themes.buttonGradient,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFD7A86E).withOpacity(0.3),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        "Delete",
                        style: AppTextStyle().commonTextStyle(
                          textColor: _res.themes.blackPure,
                          appFontStyle: AppFontStyle.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

}

class CustomSwappingButtons extends StatelessWidget {
  const CustomSwappingButtons({
    required this.leftCallback,
    required this.rightCallback,
    this.showLeftButton = true,
    this.showRightButton = true,
    super.key,
  });

  final VoidCallback leftCallback;
  final VoidCallback rightCallback;
  final bool showLeftButton;
  final bool showRightButton;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        if (showLeftButton)
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: leftCallback,
              child: Container(
                width: 30,
                height: 63,
                decoration: BoxDecoration(
                  color: Colors.white54,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(9),
                    bottomRight: Radius.circular(9),
                  ),
                  border: Border.all(color: Colors.black, width: 1.0),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    leftArrowSvg,
                    width: 15,
                    height: 15,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
        if (showRightButton)
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: rightCallback,
              child: Container(
                width: 30,
                height: 63,
                decoration: BoxDecoration(
                  color: Colors.white54,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(9),
                    bottomLeft: Radius.circular(9),
                  ),
                  border: Border.all(color: Colors.black, width: 1.0),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    rightArrowSvg,
                    width: 15,
                    height: 15,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

