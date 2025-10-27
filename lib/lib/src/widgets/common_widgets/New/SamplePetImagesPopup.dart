import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:whiskers_flutter_app/src/styles/resources.dart';
import 'package:whiskers_flutter_app/src/logger/log_handler.dart';
import 'package:whiskers_flutter_app/src/provider.dart';

class SamplePetImagesPopup extends ConsumerWidget {
  const SamplePetImagesPopup({
    super.key,
    required this.res,
    required this.title,
    required this.cautions,
    required this.correctSamples,
    required this.incorrectSamples,
  });

  final Resources res;
  final String title;
  final List<String> cautions;
  final List<String> correctSamples;
  final List<String> incorrectSamples;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logger = ref.read(loggerProvider);
    logger.i('SamplePetImagesPopup: build called');

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      insetPadding: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.8, // 80% screen height
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Close button
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: Icon(Icons.close, color: res.themes.black120),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),

                // Title
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: res.themes.black120,
                  ),
                ),
                const SizedBox(height: 16),

                // Cautions list
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: cautions
                      .map(
                        (caution) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        caution,
                        style: TextStyle(
                          fontSize: 14,
                          color: res.themes.black120,
                        ),
                      ),
                    ),
                  )
                      .toList(),
                ),

                const SizedBox(height: 16),

                Text(
                  "Examples include:",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: res.themes.black120,
                  ),
                ),
                const SizedBox(height: 12),

                // Correct examples
                GridView.count(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: correctSamples
                      .map((sample) => _exampleItem(sample, true, res))
                      .toList(),
                ),
                const SizedBox(height: 12),

                // Incorrect examples
                GridView.count(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: incorrectSamples
                      .map((sample) => _exampleItem(sample, false, res))
                      .toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _exampleItem(String asset, bool correct, Resources res) {
    return SizedBox(
      height: 110, // total height for image + icon
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                asset,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Icon(
            correct ? Icons.check_circle : Icons.cancel,
            color: correct ? res.themes.fillsGreenDefault : res.themes.red100,
            size: 20,
          ),
        ],
      ),
    );
  }
}

void showSampleImages(BuildContext context, WidgetRef ref) {
  showDialog(
    context: context,
    builder: (_) => SamplePetImagesPopup(
      title: "Please upload up to 3 images of your pet ensuring the following:",
      cautions: const [
        "• Your pet’s head and shoulders are visible",
        "• Your pet is the only main subject",
        "• Minimal distraction in the background",
      ],
      correctSamples: const [
        "assets/samples/cat_good1.png",
        "assets/samples/dog_good.png",
        "assets/samples/cat_good2.png",
      ],
      incorrectSamples: const [
        "assets/samples/cat_body.png",
        "assets/samples/dog_with_cat.png",
        "assets/samples/multiple_pets.png",
      ],
      res: ref.read(resourceProvider),
    ),
  );
}
