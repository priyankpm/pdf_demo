import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ic.dart';
import 'package:whiskers_flutter_app/src/provider.dart';
import 'package:whiskers_flutter_app/src/styles/resources.dart';

import '../common_utility/common_utility.dart';
import '../widgets/common_widgets/back_button.dart';

class PetPreferenceScreen extends ConsumerStatefulWidget {
  const PetPreferenceScreen({super.key});

  @override
  ConsumerState<PetPreferenceScreen> createState() => _PetPreferenceScreenState();
}

class _PetPreferenceScreenState extends ConsumerState<PetPreferenceScreen> {
  late Resources res;

  final List<String> howIWantMyPetToBe = [
    'Loyal', 'Quiet', 'Sarcastic', 'Tough', 'Goofy', 'Regal', 'Chill', 'Wise',
    'Silly', 'Soft', 'Happy', 'Cuddly', 'Loud', 'Fun', 'Energetic',
  ];

  final List<String> howMyPetShouldInteractWithMe = [
    'Remind me', 'Check-in', 'Ask how I am feeling each day', 'Be my best friend', 'Make me laugh',
    'Tell me stories', 'Talk to me every day', 'Help me stay on track', 'Surprise me',
    'Show me old memories', 'Be chill and quiet', 'Be silly and wild', 'Remind me to smile',
    'Build my self-esteem', 'I want to feed my pet', 'My pet eats by itself',
  ];

  final Set<String> _selectedHowIWantMyPetToBe = {};
  final Set<String> _selectedHowMyPetShouldInteractWithMe = {};

  @override
  void initState() {
    super.initState();
    res = ref.read(resourceProvider);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          'Pet Preferences',
          style: res.themes.appStyle.interBold120,
        ),
        toolbarHeight: 72,
        leadingWidth: 30,
        // leading: GestureDetector(
        //   onTap: () {
        //     Navigator.of(context).pop();
        //   },
        //   child: Padding(
        //     padding: const EdgeInsets.only(left: 12.0),
        //     child: SizedBox(width: 30, child: Iconify(Ic.baseline_less_than)),
        //   ),
        // ),
        leading: commonBackButton(context),
      ),
      body: Stack(
        children: [
          // Background Paw SVGs
          Positioned(
            top: -50,
            right: -50,
            child: Transform.rotate(
              angle: 0.5, // Adjust angle as per Figma
              child: SvgPicture.asset(
                pawSvg,
                width: 200,
                height: 200,
                colorFilter: ColorFilter.mode(Color(0x1A935B00), BlendMode.srcIn),
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            left: -50,
            child: Transform.rotate(
              angle: -0.5, // Adjust angle as per Figma
              child: SvgPicture.asset(
                pawSvg,
                width: 200,
                height: 200,
                colorFilter: ColorFilter.mode(Color(0x1A935B00), BlendMode.srcIn),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Text(
                    'Select all that apply to you',
                    style: res.themes.appStyle.black60010,
                  ),
                  const SizedBox(height: 20),
                  _buildSectionTitle('How I want my pet to be'),
                  _buildChips(howIWantMyPetToBe, _selectedHowIWantMyPetToBe),
                  const SizedBox(height: 20),
                  _buildSectionTitle('How my pet should interact with me'),
                  _buildChips(howMyPetShouldInteractWithMe, _selectedHowMyPetShouldInteractWithMe),
                  const SizedBox(height: 20),
                  _buildContinueButton(),
                  const SizedBox(height: 74),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: res.themes.appStyle.black60016,
      ),
    );
  }

  Widget _buildChips(List<String> items, Set<String> selectedSet) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: items.map((item) {
        final isSelected = selectedSet.contains(item);
        return GestureDetector(
          onTap: () {
            setState(() {
              if (isSelected) {
                selectedSet.remove(item);
              } else {
                selectedSet.add(item);
              }
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            decoration: BoxDecoration(
              color: isSelected ? null : const Color(0xFFE7E7E7),
              gradient: isSelected
                  ? const LinearGradient(
                      colors: [
                        Color(0xFFFFD288),
                        Color(0xFFB15600),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Text(
              item,
              style: TextStyle(
                color: isSelected ? Colors.black : Colors.black,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildContinueButton() {
    return Center(
      child: GestureDetector(
        onTap: () {
          ref.read(navigationServiceProvider).pushNamed(RoutePaths.humanAudioScreen);
        },
        child: Container(
          width: 216,
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFFFFD288),
                Color(0xFFB15600),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            'Continue',
            textAlign: TextAlign.center,
            style: res.themes.appStyle.white70016.copyWith(color: Colors.black),
          ),
        ),
      ),
    );
  }
}