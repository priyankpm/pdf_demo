import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:whiskers_flutter_app/src/styles/resources.dart';
import 'package:whiskers_flutter_app/src/styles/utils/app_styles.dart';

import '../../provider.dart';
import '../../styles/utils/common_constants.dart';

final Map<int, String> _defaultImages = {
  0: 'assets/samples/living.jpg',
  1: 'assets/samples/bedroom.jpg',
  2: 'assets/samples/kitchen.jpg',
};

class FeedbackDialog extends ConsumerStatefulWidget {
  final bool? isFullScreen;
  final String screeName;
  final String asset;
  final String assetPath;

  const FeedbackDialog({
    super.key,
    this.isFullScreen,
    required this.screeName,
    required this.asset,
    required this.assetPath,
  });

  @override
  ConsumerState<FeedbackDialog> createState() => _FeedbackDialogState();
}

class _FeedbackDialogState extends ConsumerState<FeedbackDialog> {
  String? selectedOption = '';
  final TextEditingController _textController = TextEditingController();
  late final Resources _res;

  @override
  void initState() {
    super.initState();
    _res = ref.read(resourceProvider);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.isFullScreen == true
        ? screenView(context)
        : dialogView(context);
  }

  Widget screenView(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 34),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(reportBg),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "We're sorry to hear you are facing issues.",
                  style: AppTextStyle().commonTextStyle(
                    textColor: _res.themes.blackPure,
                    fontSize: 20,
                    appFontStyle: AppFontStyle.bold,
                  ),
                  textAlign: TextAlign.start,
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(
                    'Please let us know what went wrong so we are able to make the necessary changes.',
                    style: AppTextStyle().commonTextStyle(
                      textColor: _res.themes.blackPure,
                      fontSize: 14,
                      appFontStyle: AppFontStyle.medium,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),

                Center(
                  child: IntrinsicWidth(
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 32),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5E1C0),
                        borderRadius: BorderRadius.circular(12),

                        border: Border.all(
                          color: _res.themes.checkBoxColor,
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Image.network(
                          widget.assetPath,
                          height: 250,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              height: 250,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.white.withValues(alpha: 0.8),
                              ),
                              child: Center(
                                child: CircularProgressIndicator(
                                  value:
                                      loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return _buildDefaultImageContent();
                          },
                        ),
                      ),
                    ),
                  ),
                ),

                _buildRadioOption('App Crashed & Freezing'),
                const SizedBox(height: 3),
                _buildRadioOption('Incorrect Pet'),
                const SizedBox(height: 3),
                _buildRadioOption('Other'),
                const SizedBox(height: 12),
                selectedOption == "Other" ? _describeText() : SizedBox(),
                const SizedBox(height: 15),
                _submitButton(context),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget dialogView(BuildContext context) {
    final kitchenImagePath = _getKitchenImage();

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 16),
                Align(
                  alignment: AlignmentGeometry.centerRight,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.05),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close,
                        size: 18,
                        color: Color(0xFF666666),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 6),

                // Title
                Text(
                  "We're sorry to hear you are facing issues.",
                  style: AppTextStyle().commonTextStyle(
                    textColor: _res.themes.blackPure,
                    fontSize: 16,
                    appFontStyle: AppFontStyle.bold,
                  ),
                  textAlign: TextAlign.start,
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    'Please let us know what went wrong so we are able to make the necessary changes.',
                    style: AppTextStyle().commonTextStyle(
                      textColor: _res.themes.blackPure,
                      fontSize: 14,
                      appFontStyle: AppFontStyle.medium,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),

                widget.assetPath.isNotEmpty
                    ? Center(
                        child: Container(
                          height: 190,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                              image: kitchenImagePath.startsWith('assets/')
                                  ? AssetImage(kitchenImagePath)
                                        as ImageProvider
                                  : FileImage(File(kitchenImagePath))
                                        as ImageProvider,
                              fit: BoxFit.cover,
                            ),
                            border: Border.all(
                              color: _res.themes.checkBoxColor,
                              width: 2,
                            ),
                          ),
                          child: IntrinsicWidth(
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Image.asset(
                                widget.assetPath,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    'assets/pet/natural.gif',
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: Colors.grey[200],
                                        child: const Icon(
                                          Icons.pets,
                                          size: 150,
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      )
                    : SizedBox(),

                const SizedBox(height: 20),
                _buildRadioOption('App Crashed & Freezing'),
                const SizedBox(height: 3),
                _buildRadioOption('Incorrect Pet'),
                const SizedBox(height: 3),
                _buildRadioOption('Other'),
                const SizedBox(height: 3),
                selectedOption == "Other" ? _describeText() : SizedBox(),
                const SizedBox(height: 15),

                _submitButton(context),
                const SizedBox(height: 26),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRadioOption(String text) {
    final isSelected = selectedOption == text;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedOption = text;
        });
      },
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Color(0xffF4F4F4),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _res.themes.checkBoxColor, width: 1),
        ),
        child: Row(
          children: [
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? _res.themes.creamPrimary
                    : Colors.transparent,
                border: Border.all(
                  color: isSelected
                      ? _res.themes.creamPrimary
                      : Color(0XFF7A7A7A),
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Center(
                        child: Icon(Icons.done, color: Colors.white, size: 15),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Text(
              text,
              style: AppTextStyle().commonTextStyle(
                textColor: _res.themes.blackPure,
                fontSize: 13,
                appFontStyle: AppFontStyle.regular,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _describeText() {
    return TextField(
      controller: _textController,
      maxLines: 3,
      style: AppTextStyle().commonTextStyle(
        textColor: _res.themes.blackPure,
        fontSize: 13,
        appFontStyle: AppFontStyle.regular,
      ),
      decoration: InputDecoration(
        hintText: 'Describe your experience here',
        hintStyle: AppTextStyle().commonTextStyle(
          textColor: _res.themes.blackPure,
          fontSize: 13,
          appFontStyle: AppFontStyle.regular,
        ),
        filled: true,
        fillColor: Color(0xffF4F4F4),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _res.themes.checkBoxColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _res.themes.checkBoxColor),
        ),
      ),
    );
  }

  Widget _submitButton(BuildContext context) {
    final feedbackState = ref.watch(feedbackViewModelProvider);

    return GestureDetector(
      onTap:
          (selectedOption!.isNotEmpty && selectedOption != "Other") ||
              (selectedOption == "Other" && _textController.text.isNotEmpty)
          ? () => _addReport(context)
          : null,
      child: Container(
        height: 53,
        decoration: BoxDecoration(
          gradient:
              (selectedOption!.isNotEmpty && selectedOption != "Other") ||
                  (selectedOption == "Other" && _textController.text.isNotEmpty)
              ? _res.themes.buttonGradient
              : LinearGradient(
                  colors: [Colors.grey.shade200, Colors.grey.shade200],
                ),
          borderRadius: BorderRadius.circular(12),
        ),
        width: double.infinity,
        child: Center(
          child: feedbackState.isLoading
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: CircularProgressIndicator(
                    color: _res.themes.blackPure,
                    strokeWidth: 3,
                  ),
                )
              : const Text(
                  'Submit Feedback',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
        ),
      ),
    );
  }

  String _getKitchenImage() {
    final backgroundState = ref.read(backgroundImageProvider);
    if (backgroundState.isNotEmpty) {
      String image = widget.screeName == "sleep"
          ? _defaultImages[1]!
          : widget.screeName == "eat"
          ? _defaultImages[0]!
          : "";
      if (!image.startsWith('assets/')) {
        final file = File(image);
        if (file.existsSync()) {
          return image;
        }
      } else {
        return image;
      }
    }

    return _defaultImages[2]!;
  }

  Future<void> _addReport(BuildContext context) async {
    final service = ref.read(feedbackViewModelProvider.notifier);

    final reason = selectedOption == "Other"
        ? _textController.text.trim()
        : selectedOption!;
    final petId = "ce8c76d0-69b2-4613-98c5-8e1bc3990b06";

    await service.submitFeedback(
      context: context,
      reason: reason,
      screenName: widget.screeName,
      asset: 'chewing' /*?? widget.asset*/,
      petId: petId,
    );

    if (ref.read(feedbackViewModelProvider).hasValue) {
      Navigator.pop(context);
      if (widget.isFullScreen == true) {
        Navigator.pop(context);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Feedback submitted successfully!")),
      );
    }
  }

  Widget _buildDefaultImageContent() {
    return Container(
      width: 250,
      height: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white.withValues(alpha: 0.9),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 8,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(
          "assets/samples/cool_cate.png", // Default image
          width: 250,
          height: 300,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
