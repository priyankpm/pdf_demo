import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:whiskers_flutter_app/src/models/memory_frame_model.dart';
import 'package:whiskers_flutter_app/src/provider.dart';
import 'package:whiskers_flutter_app/src/styles/resources.dart';

import '../../../common_utility/common_utility.dart';
import '../../../common_utility/image_utils.dart';
import '../../../enum/memory_frame_type.dart';
import '../../../services/SharedPreferencesService.dart';

const String squareFrame = 'assets/memory/goldenPhotoFrame.png';
const String squareFrame_1 = 'assets/memory/goldenPhotoFrame_1.png';

const String landscapeFrame = 'assets/memory/landscapeFrame.png';
const String landscapeFrame_1 = 'assets/memory/landscapeFrame_1.png';

const String portraitFrame = 'assets/memory/portraitFrame.png';
const String portraitFrame_1 = 'assets/memory/portraitFrame_1.png';

enum AspectRatioCategory { square, landscape, portrait }

class FrameConfig {
  final String framePath;
  final MemoryFrameType frameType;
  final AspectRatioCategory category;

  FrameConfig(this.framePath, this.frameType, this.category);
}

class FrameSelector {
  static AspectRatioCategory getAspectRatioCategory(double aspectRatio) {
    if (aspectRatio >= 0.95 && aspectRatio <= 1.05) {
      return AspectRatioCategory.square;
    } else if (aspectRatio > 1.05) {
      return AspectRatioCategory.landscape;
    } else {
      return AspectRatioCategory.portrait;
    }
  }

  static FrameConfig selectFrameByCount(
      double aspectRatio,
      int countForThisAspectRatio,
      ) {
    final category = getAspectRatioCategory(aspectRatio);

    final useAlternate = countForThisAspectRatio % 2 == 1;

    if (category == AspectRatioCategory.square) {
      return FrameConfig(
        useAlternate ? squareFrame_1 : squareFrame,
        MemoryFrameType.square,
        category,
      );
    } else if (category == AspectRatioCategory.landscape) {
      return FrameConfig(
        useAlternate ? landscapeFrame_1 : landscapeFrame,
        MemoryFrameType.rectangle,
        category,
      );
    } else {
      return FrameConfig(
        useAlternate ? portraitFrame_1 : portraitFrame,
        MemoryFrameType.rectangle,
        category,
      );
    }
  }

  static int countFramesWithSameAspectRatio(
      List<MemoryFrameModel> allFrames,
      AspectRatioCategory category,
      ) {
    int count = 0;
    for (var frame in allFrames) {
      if (frame.imagePath.isEmpty) continue;

      if (category == AspectRatioCategory.square) {
        if (frame.framePath.contains('goldenPhotoFrame')) {
          count++;
        }
      } else if (category == AspectRatioCategory.landscape) {
        if (frame.framePath.contains('landscapeFrame')) {
          count++;
        }
      } else if (category == AspectRatioCategory.portrait) {
        if (frame.framePath.contains('portraitFrame')) {
          count++;
        }
      }
    }
    return count;
  }
}

class MemoryWallScreen extends ConsumerStatefulWidget {
  const MemoryWallScreen({super.key});

  @override
  MemoryWallScreenState createState() => MemoryWallScreenState();
}

class MemoryWallScreenState extends ConsumerState<MemoryWallScreen> {
  final ScrollController scrollController = ScrollController();
  late final Resources res;
  bool isGridLoaded = false;

  @override
  void initState() {
    super.initState();
    res = ref.read(resourceProvider);
    ref.read(memoryFrameProvider.notifier).init();
    _loadGridWithDelay();
  }

  Future<void> _loadGridWithDelay() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    if (mounted) {
      setState(() {
        isGridLoaded = true;
      });
    }
  }

  Widget build(BuildContext context) {
    final memoryFrameModel = ref.watch(memoryFrameProvider);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(memoryWallBg),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.all(26.0).copyWith(top: 40),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return StaggeredGridView(
                  memoryFrames: memoryFrameModel,
                  maxWidth: constraints.maxWidth,
                );
              },
            ),
          ),
          if (!isGridLoaded)
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                image: DecorationImage(
                  image: AssetImage(memoryWallBg),
                  fit: BoxFit.cover,
                ),
              ),
              height: MediaQuery.of(context).size.height - 100,
              child: Center(
                child: CircularProgressIndicator(
                  color: Color(0XFFB15600),
                  strokeWidth: 3,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class StaggeredGridView extends StatelessWidget {
  const StaggeredGridView({
    super.key,
    required this.memoryFrames,
    required this.maxWidth,
  });

  final List<MemoryFrameModel> memoryFrames;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    const int columnCount = 2;
    const double spacing = 20.0;
    final double columnWidth =
        (maxWidth - (spacing * (columnCount - 1))) / columnCount;

    List<List<MapEntry<int, MemoryFrameModel>>> columns = List.generate(
      columnCount,
          (_) => [],
    );
    List<double> columnHeights = List.filled(columnCount, 0.0);

    for (var i = 0; i < memoryFrames.length; i++) {
      var frame = memoryFrames[i];

      int shortestColumnIndex = 0;
      double minHeight = columnHeights[0];

      for (int j = 1; j < columnCount; j++) {
        if (columnHeights[j] < minHeight) {
          minHeight = columnHeights[j];
          shortestColumnIndex = j;
        }
      }

      columns[shortestColumnIndex].add(MapEntry(i, frame));

      columnHeights[shortestColumnIndex] +=
          columnWidth * 1.2 + 8 + 40 + spacing;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(columnCount, (columnIndex) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              left: columnIndex > 0 ? spacing / 2 : 0,
              right: columnIndex < columnCount - 1 ? spacing / 2 : 0,
            ),
            child: Column(
              children: columns[columnIndex].map((entry) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: FrameScreenWidget(
                    memoryFrameModel: entry.value,
                    frameIndex: entry.key,
                    maxWidth: columnWidth,
                  ),
                );
              }).toList(),
            ),
          ),
        );
      }),
    );
  }
}

class FrameScreenWidget extends ConsumerStatefulWidget {
  const FrameScreenWidget({
    required this.memoryFrameModel,
    required this.frameIndex,
    required this.maxWidth,
    super.key,
  });

  final MemoryFrameModel memoryFrameModel;
  final int frameIndex;
  final double maxWidth;

  @override
  ConsumerState<FrameScreenWidget> createState() => _FrameScreenWidgetState();
}

class _FrameScreenWidgetState extends ConsumerState<FrameScreenWidget> {
  double? imageWidth;
  double? imageHeight;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    if (widget.memoryFrameModel.imagePath.isNotEmpty) {
      _loadImageDimensions();
    } else {
      isLoading = false;
    }
  }

  @override
  void didUpdateWidget(FrameScreenWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.memoryFrameModel.imagePath !=
        widget.memoryFrameModel.imagePath) {
      if (widget.memoryFrameModel.imagePath.isNotEmpty) {
        setState(() => isLoading = true);
        _loadImageDimensions();
      } else {
        setState(() {
          imageWidth = null;
          imageHeight = null;
          isLoading = false;
        });
      }
    }
  }

  Future<void> _loadImageDimensions() async {
    try {
      final file = File(widget.memoryFrameModel.imagePath);
      if (!await file.exists()) {
        setState(() => isLoading = false);
        return;
      }

      final bytes = await file.readAsBytes();
      final image = await decodeImageFromList(bytes);

      setState(() {
        imageWidth = image.width.toDouble();
        imageHeight = image.height.toDouble();
        isLoading = false;
      });

      image.dispose();
    } catch (e) {
      print('Error loading image dimensions: $e');
      setState(() {
        imageWidth = 300;
        imageHeight = 300;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Resources res = ref.read(resourceProvider);
    double displayWidth = widget.maxWidth;
    double displayHeight;
    String framePath = widget.memoryFrameModel.framePath;

    if (imageWidth != null && imageHeight != null) {
      final aspectRatio = imageWidth! / imageHeight!;

      displayHeight = displayWidth / aspectRatio;

      if (aspectRatio > 1) {
        if (displayHeight < displayWidth * 0.6) {
          displayHeight = displayWidth * 0.6;
        }
      } else {
        if (displayHeight > displayWidth * 1.6) {
          displayHeight = displayWidth * 1.6;
        }
      }
    } else {
      displayHeight = displayWidth;
      if (framePath.isEmpty) {
        framePath = widget.frameIndex % 2 == 1 ? squareFrame_1 : squareFrame;
      }
    }

    return SingleFrameWidget(
      res: res,
      frameImagePath: framePath,
      frameTitle: widget.memoryFrameModel.title,
      callback: () async {
        if (widget.memoryFrameModel.imagePath.isNotEmpty) {
          await ref
              .read(navigationServiceProvider)
              .pushNamed(
            RoutePaths.memoryEditScreen,
            arguments: widget.memoryFrameModel,
          );
        } else {
          final file = await ImageUtils.picImage(
            context,
            frameType: widget.memoryFrameModel.memoryFrameType ?? '',
          );

          if (file != null) {
            final bytes = await file.readAsBytes();
            final image = await decodeImageFromList(bytes);
            final aspectRatio = image.width / image.height;
            image.dispose();

            final category = FrameSelector.getAspectRatioCategory(aspectRatio);

            final allFrames = ref.read(memoryFrameProvider);

            final countForThisAspectRatio =
            FrameSelector.countFramesWithSameAspectRatio(
              allFrames,
              category,
            );

            final frameConfig = FrameSelector.selectFrameByCount(
              aspectRatio,
              countForThisAspectRatio,
            );

            final service = SharedPreferencesService();
            final userId = await service.getUserId();
            final frameId = DateTime.now().millisecondsSinceEpoch.toString();

            final MemoryFrameModel updatedFrame = widget.memoryFrameModel.copyWith(
              title: '',
              id: frameId,
              imagePath: file.path,
              framePath: frameConfig.framePath,
              memoryFrameType: frameConfig.frameType.name,
              shares: 0,
              imageId: userId,
              petId: 'b3513ad2-9352-4237-9dee-9ca80ede5f00',
              IsFromApp: true,
            );

            await ref
                .read(memoryFrameProvider.notifier)
                .addOrUpdateFrame(updatedFrame, context);

            await _loadImageDimensions();
          }
        }
      },
      photoPath: widget.memoryFrameModel.imagePath,
      width: displayWidth,
      height: displayHeight,
      showDescriptionText: widget.memoryFrameModel.title.isNotEmpty
          ? true
          : false,
    );
  }
}

class SingleFrameWidget extends StatelessWidget {
  const SingleFrameWidget({
    super.key,
    required this.res,
    required this.frameImagePath,
    required this.photoPath,
    required this.frameTitle,
    required this.callback,
    required this.width,
    required this.height,
    this.showDescriptionText = true,
  });

  final Resources res;
  final String frameImagePath;
  final String photoPath;
  final String frameTitle;
  final VoidCallback callback;
  final double width;
  final double height;
  final bool showDescriptionText;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: callback,
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  offset: const Offset(6, 6),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Stack(
              children: [
                if (photoPath.isNotEmpty)
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Image.file(File(photoPath), fit: BoxFit.cover),
                      ),
                    ),
                  )
                else
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Center(
                      child: Icon(Icons.add, color: Colors.black, size: 40),
                    ),
                  ),

                if (frameImagePath.isNotEmpty)
                  Positioned.fill(
                    child: Image.asset(frameImagePath, fit: BoxFit.fill),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
          Builder(
            builder: (context) {
              return SizedBox(
                width: width,
                child: Text(
                  photoPath.isEmpty ? "Add Memory" : frameTitle,
                  style: res.themes.appStyle.black60016,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              );
            },
          ),
      ],
    );
  }
}
