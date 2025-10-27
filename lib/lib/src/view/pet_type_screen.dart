import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:whiskers_flutter_app/src/widgets/common_widgets/back_button.dart';

import '../common_utility/common_utility.dart';
import '../logger/log_handler.dart';
import '../provider.dart';
import '../styles/resources.dart';
import '../widgets/common_widgets/New/background_paws.dart';
import '../widgets/common_widgets/New/continue_button.dart';

class PetTypeScreen extends ConsumerStatefulWidget {
  const PetTypeScreen({super.key});

  @override
  PetTypeScreenState createState() => PetTypeScreenState();
}

class PetTypeScreenState extends ConsumerState<PetTypeScreen> {
  late final Resources _res;
  late Logger _logger;

  final List<Map<String, String>> pets = [
    {
      "name": "Dog",
      "image": dogImage,
    },
    {
      "name": "Cat",
      "image": catImage,
    }
  ];

  @override
  void initState() {
    super.initState();
    _logger = ref.read(loggerProvider);
    _logger.i('PetTypeScreenState: initState called');
    _res = ref.read(resourceProvider);
  }

  @override
  Widget build(BuildContext context) {
    final petTypeViewModel = ref.read(petTypeProvider.notifier);
    final petTypeState = ref.watch(petTypeProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back_ios, color: _res.themes.black120),
        //   onPressed: () => Navigator.pop(context),
        // ),
        leading: commonBackButton(context),
        centerTitle: true,
        title: Text(
          "Pick your Pet",
          style: TextStyle(
            color: _res.themes.black120,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BackgroundPaws(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: pets.length,
                separatorBuilder: (_, __) => const SizedBox(height: 20),
                itemBuilder: (context, index) {
                  final pet = pets[index];
                  final isSelected = petTypeState.selectedPet == pet["name"];
                  return GestureDetector(
                    onTap: () => petTypeViewModel.selectPet(pet["name"]!),
                    child: Column(
                      children: [
                        Container(
                          height: 200,
                          width: 250,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(
                              color: isSelected
                                  ? _res.themes.darkGolden
                                  : Colors.transparent,
                              width: 3,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              pet["image"]!,
                              fit: BoxFit.contain,
                              width: double.infinity,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          pet["name"]!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: _res.themes.black120,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            if (petTypeState.selectedPet != null) ...[
              const SizedBox(height: 10),
              ContinueButton(
                label: "Continue",
                onTap: () {
                  petTypeViewModel.navigateToUploadHouseScreen();
                },
              ),
              const SizedBox(height: 24),
            ]
          ],
        ),
      ),
    );
  }
}