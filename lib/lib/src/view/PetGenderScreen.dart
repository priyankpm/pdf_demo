// screens/pet_gender_screen.dart
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../logger/log_handler.dart';
import '../provider.dart';
import '../services/SharedPreferencesService.dart';
import '../styles/res/app_themes.dart';
import '../styles/resources.dart';
import '../widgets/common_widgets/New/background_paws.dart';
import '../widgets/common_widgets/New/continue_button.dart';
import '../widgets/common_widgets/back_button.dart';

class PetGenderScreen extends ConsumerStatefulWidget {
  const PetGenderScreen({super.key});

  @override
  PetGenderScreenState createState() => PetGenderScreenState();
}

class PetGenderScreenState extends ConsumerState<PetGenderScreen> {
  late final Resources _res;
  late Logger _logger;
  String? petName;

  @override
  void initState() {
    super.initState();
    _logger = ref.read(loggerProvider);
    _logger.i('PetGenderScreenState: initState called');
    _res = ref.read(resourceProvider);
    _loadPetName();
  }

  Future<void> _loadPetName() async {
    final name = await SharedPreferencesService().getPetName();
    setState(() {
      petName = name;
    });
  }

  @override
  Widget build(BuildContext context) {
    final petGenderState = ref.watch(petGenderProvider);
    final petGenderViewModel = ref.read(petGenderProvider.notifier);

    return Scaffold(
      body: BackgroundPaws(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Top Row: Back button + Centered Title
                Row(
                  children: [
                    commonBackButton(context, onPressed: petGenderState.loading
                        ? null
                        : () => petGenderViewModel.navigateBack()),
                    // IconButton(
                    //   onPressed: petGenderState.loading
                    //       ? null
                    //       : () => petGenderViewModel.navigateBack(),
                    //   icon: Icon(
                    //     Icons.arrow_back,
                    //     color: petGenderState.loading
                    //         ? _res.themes.grey100
                    //         : _res.themes.black120,
                    //   ),
                    // ),
                    Expanded(
                      child: Center(
                        child: Text(
                          "$petName's Gender",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: _res.themes.black120,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 48), // Balance the back button
                  ],
                ),

                const SizedBox(height: 200),

                // Gender Options - Centered Buttons
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: _GenderOption(
                        label: "Male",
                        isSelected: petGenderState.gender == "Male",
                        onTap: petGenderState.loading
                            ? null
                            : () => petGenderViewModel.updateGender("Male"),
                        themes: _res.themes,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Center(
                      child: _GenderOption(
                        label: "Female",
                        isSelected: petGenderState.gender == "Female",
                        onTap: petGenderState.loading
                            ? null
                            : () => petGenderViewModel.updateGender("Female"),
                        themes: _res.themes,
                      ),
                    ),
                  ],
                ),

                const Spacer(),

                // Error Message - Limited height with scrollable content
                if (petGenderState.errorMessage != null) ...[
                  Container(
                    width: double.infinity,
                    constraints: const BoxConstraints(
                      maxHeight: 60,
                    ),
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: _res.themes.red100.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: _res.themes.red100),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.error_outline,
                                color: _res.themes.red100, size: 16),
                            const SizedBox(width: 8),
                            Text(
                              'Error',
                              style: TextStyle(
                                color: _res.themes.red100,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            if (!petGenderState.loading)
                              IconButton(
                                icon: Icon(Icons.close,
                                    size: 16, color: _res.themes.red100),
                                onPressed: () =>
                                    petGenderViewModel.clearError(),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(
                                  minWidth: 24,
                                  minHeight: 24,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: Text(
                              petGenderState.errorMessage!,
                              style: TextStyle(
                                color: _res.themes.red100,
                                fontSize: 13,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                ],

                // Continue Button
                if (petGenderState.isComplete)
                  ContinueButton(
                    label: petGenderState.loading
                        ? "Creating Pet..."
                        : "Continue",
                    onTap: petGenderState.loading
                        ? null
                        : () => petGenderViewModel.savePetAndNavigate(),
                    loading: petGenderState.loading,
                    enabled: !petGenderState.loading &&
                        petGenderState.isComplete,
                  ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Gender Option Widget (No radio icons, centered buttons)
class _GenderOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;
  final AppThemes themes;

  const _GenderOption({
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.themes,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 200,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
            colors: [
              const Color.fromRGBO(255, 210, 136, 0.5),
              const Color.fromRGBO(177, 86, 0, 0.5),
            ],
          )
              : null,
          color: isSelected ? null : themes.lightGrey,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? themes.darkGolden : themes.grey100,
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: themes.darkGolden.withOpacity(0.15),
              blurRadius: 6,
              offset: const Offset(0, 3),
            )
          ]
              : [],
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: isSelected ? themes.blackPure : themes.black120,
            ),
          ),
        ),
      ),
    );
  }
}
