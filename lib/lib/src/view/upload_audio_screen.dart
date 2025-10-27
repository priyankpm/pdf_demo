import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:whiskers_flutter_app/src/common_utility/route_paths.dart';
import 'package:whiskers_flutter_app/src/provider.dart';
import 'package:whiskers_flutter_app/src/styles/resources.dart';
import 'package:whiskers_flutter_app/src/viewmodel/upload_audio_viewmodel.dart';

import '../widgets/common_widgets/back_button.dart';

class UploadAudioScreen extends ConsumerWidget {
  const UploadAudioScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenSize = MediaQuery.of(context).size;
    final res = ref.watch(resourceProvider);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(statusBarHandler).setStatusBarColor(res.themes.pureWhite);
    });
    return Material(
      child: Stack(
        children: [
          Positioned(
            top: -50,
            right: -50,
            child: SvgPicture.asset(
              'assets/home_screen/paw.svg',
              width: 200,
              height: 200,
              colorFilter: ColorFilter.mode(res.themes.lightOrange.withOpacity(0.3), BlendMode.srcIn),
            ),
          ),
          Positioned(
            bottom: -50,
            left: -50,
            child: SvgPicture.asset(
              'assets/home_screen/paw.svg',
              width: 200,
              height: 200,
              colorFilter: ColorFilter.mode(res.themes.lightOrange.withOpacity(0.3), BlendMode.srcIn),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                _header(context, ref, res),
                SizedBox(height: screenSize.height * 0.05),
                _buildInstructions(res),
                SizedBox(height: screenSize.height * 0.05),
                _buildUploadBox(context, ref, res),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _header(BuildContext context, WidgetRef ref, Resources res) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // IconButton(
        //   icon: Icon(Icons.arrow_back),
        //   onPressed: () => Navigator.of(context).pop(),
        // ),
        commonBackButton(context),
        Text(
          'Upload Audio',
          style: res.themes.appStyle.black50025,
        ),
        TextButton(
          onPressed: () {
            ref.read(navigationServiceProvider).pushNamed(RoutePaths.homeScreen);
          },
          child: Text(
            'Skip',
            style: res.themes.appStyle.interBold14,
          ),
        ),
      ],
    );
  }

  Widget _buildInstructions(Resources res) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Please upload up to 3 audio files for your pet. If you do not have any recorded audio, please upload any video that features the voice of your pet ensuring the following:',
            style: res.themes.appStyle.black40016,
          ),
          SizedBox(height: 16),
          _buildInstructionPoint("Your pet's voice must be loud and clear", res),
          _buildInstructionPoint("Your pet is the only one speaking", res),
          _buildInstructionPoint("Minimal noise in the background", res),
        ],
      ),
    );
  }

  Widget _buildInstructionPoint(String text, Resources res) {
    return Row(
      children: [
        Text(
          '• ',
          style: res.themes.appStyle.black40016,
        ),
        Expanded(
          child: Text(
            text,
            style: res.themes.appStyle.black40016,
          ),
        ),
      ],
    );
  }

  Widget _buildUploadBox(BuildContext context, WidgetRef ref, Resources res) {
    final uploadAudioVM = ref.read(uploadAudioProvider).uploadAudioViewModel;
    return GestureDetector(
      onTap: () {
        uploadAudioVM.pickFile(context);
      },
      child: Container(
        margin: const EdgeInsets.all(20.0),
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: res.themes.lightOrange,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            SvgPicture.asset(
              'assets/create_account/dog_paw.svg', // Placeholder
              height: 40,
            ),
            SizedBox(height: 16),
            Text(
              'Upload an audio/video file',
              style: res.themes.appStyle.interBold14.copyWith(
                color: res.themes.lightOrange,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Supported formates: mp3, mp4, mov',
              style: res.themes.appStyle.black40016.copyWith(
                color: res.themes.grey100,
              ),
            ),
          ],
        ),
      ),
    );
  }
}