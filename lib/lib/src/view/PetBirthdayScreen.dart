import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../logger/log_handler.dart';
import '../provider.dart';
import '../services/SharedPreferencesService.dart';
import '../styles/resources.dart';
import '../widgets/common_widgets/New/background_paws.dart';
import '../widgets/common_widgets/New/continue_button.dart';
import '../widgets/common_widgets/back_button.dart';

class PetBirthdayScreen extends ConsumerStatefulWidget {
  const PetBirthdayScreen({super.key});

  @override
  PetBirthdayScreenState createState() => PetBirthdayScreenState();
}

class PetBirthdayScreenState extends ConsumerState<PetBirthdayScreen> {
  late final Resources _res;
  late Logger _logger;
  String? petName;
  String? _petPortraitUrl;
  bool _isLoading = true;

  // Default images for fallback
  final Map<int, String> _defaultImages = {
    0: 'assets/samples/living.jpg',
    1: 'assets/samples/bedroom.jpg',
    2: 'assets/samples/kitchen.jpg',
  };

  @override
  void initState() {
    super.initState();
    _logger = ref.read(loggerProvider);
    _logger.i('PetBirthdayScreenState: initState called');
    _res = ref.read(resourceProvider);
    _loadPetName();
    _loadPetPortraitUrl();
  }

  // Load pet name from SharedPreferences
  Future<void> _loadPetName() async {
    final name = await SharedPreferencesService().getPetName();
    setState(() {
      petName = name;
    });
  }

  // Load pet portrait URL from SharedPreferences
  Future<void> _loadPetPortraitUrl() async {
    try {
      _logger.i('🖼️ Loading pet portrait URL from SharedPreferences');

      final prefsService = ref.read(sharedPreferencesServiceProvider);
      final url = await prefsService.getPetPortraitUrl();

      if (url != null && url.isNotEmpty) {
        _logger.i('✅ Loaded pet portrait URL: $url');
        setState(() {
          _petPortraitUrl = url;
        });
      } else {
        _logger.w('⚠️ No pet portrait URL found in SharedPreferences, using default image');
      }
    } catch (e) {
      _logger.e('💥 Error loading pet portrait URL: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Get living room background image - index 0
  String _getLivingRoomImage() {
    final backgroundState = ref.read(backgroundImageProvider);

    if (backgroundState.isNotEmpty && backgroundState.length > 0 && backgroundState[0] != null) {
      final livingRoomImage = backgroundState[0]!;
      final livingRoomImagePath = livingRoomImage.path;

      if (!livingRoomImagePath.startsWith('assets/')) {
        final file = File(livingRoomImagePath);
        if (file.existsSync()) {
          return livingRoomImagePath;
        }
      } else {
        return livingRoomImagePath;
      }
    }

    return _defaultImages[0]!; // Fallback to default living room
  }

  @override
  Widget build(BuildContext context) {
    final petBirthdayViewModel = ref.read(petBirthdayProvider.notifier);
    final petBirthdayState = ref.watch(petBirthdayProvider);

    // Dropdown values
    final months = List.generate(12, (index) => '${index + 1}');
    final days = List.generate(31, (index) => '${index + 1}');
    final currentYear = DateTime.now().year;
    final years = List.generate(100, (index) => '${currentYear - index}');

    return Scaffold(
      body: BackgroundPaws(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top bar with arrow + centered title
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: commonBackButton(context, onPressed: () {
                        petBirthdayViewModel.navigateBack();
                      },),
                    ),
                    // Align(
                    //   alignment: Alignment.centerLeft,
                    //   child: IconButton(
                    //     onPressed: () => petBirthdayViewModel.navigateBack(),
                    //     icon: Icon(Icons.arrow_back, color: _res.themes.black120),
                    //   ),
                    // ),
                    Center(
                      child: Text(
                        "${petName ?? "Your Pet"}'s Birthday",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: _res.themes.black120,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // Pet Image with Background Frame - Increased height by 100px
                _buildPetImageWithFrame(),

                const SizedBox(height: 30),

                // Birthday Dropdowns
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _dropdownField(
                      "MM",
                      petBirthdayState.month,
                      months,
                          (value) => petBirthdayViewModel.updateMonth(value),
                      _res,
                    ),
                    _dropdownField(
                      "DD",
                      petBirthdayState.day,
                      days,
                          (value) => petBirthdayViewModel.updateDay(value),
                      _res,
                    ),
                    _dropdownField(
                      "YYYY",
                      petBirthdayState.year,
                      years,
                          (value) => petBirthdayViewModel.updateYear(value),
                      _res,
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // Continue Button
                if (petBirthdayState.isComplete)
                  Center(
                    child: ContinueButton(
                      label: "Continue",
                      onTap: () => petBirthdayViewModel.navigateToNextScreen(),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPetImageWithFrame() {
    final livingRoomImagePath = _getLivingRoomImage();

    return Center(
      child: Container(
        width: 300, // Fixed width for frame
        height: 300, // Increased by 100px (from 250 to 350)
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [

          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10), // Slightly smaller than frame
          child: Stack(
            children: [
              // Background Image ONLY inside the frame
              Positioned.fill(
                child: Image.asset(
                  livingRoomImagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: const Color(0xFFF5E1C0),
                    );
                  },
                ),
              ),

              // Pet Image on top of the background
              Center(
                child: _buildPetImageContent(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPetImageContent() {
    if (_isLoading) {
      return Container(
        width: 250, // Smaller than frame
        height: 300, // Adjusted for new frame height
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // If we have a stored URL, show the network image
    if (_petPortraitUrl != null && _petPortraitUrl!.isNotEmpty) {
      return Container(
        width: 250, // Smaller than frame
        height: 300, // Adjusted for new frame height
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),

        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            _petPortraitUrl!,
            width: 250,
            height: 300,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                width: 250,
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white.withOpacity(0.8),
                ),
                child: Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              _logger.e('💥 Error loading network image: $error');
              // Fallback to default image if network image fails to load
              return _buildDefaultImageContent();
            },
          ),
        ),
      );
    }

    // Fallback to default image if no URL is available
    return _buildDefaultImageContent();
  }

  Widget _buildDefaultImageContent() {
    return Container(
      width: 250, // Smaller than frame
      height: 300, // Adjusted for new frame height
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white.withOpacity(0.9),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
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

  Widget _dropdownField(
      String hint,
      String? value,
      List<String> items,
      Function(String?) onChanged,
      Resources res,
      ) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: DropdownButtonFormField<String>(
          value: value,
          hint: Text(
            hint,
            style: TextStyle(color: res.themes.grey100),
          ),
          items: items.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.black12, width: 1), // subtle black stripe
                  ),
                ),
                child: Text(
                  value,
                  style: TextStyle(color: res.themes.black120),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }).toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: res.themes.grey100),
            ),
            filled: true,
            fillColor: res.themes.lightGrey, // background for the field
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: res.themes.darkGolden),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
          ),
          dropdownColor: res.themes.lightGrey, // ✅ light grey popup background
          icon: Icon(Icons.arrow_drop_down, color: res.themes.black120),
          style: TextStyle(color: res.themes.black120, fontSize: 14),
          isExpanded: true,
          menuMaxHeight: 200,
          borderRadius: BorderRadius.circular(12),
          elevation: 0, // no shadow
        ),
      ),
    );
  }
}