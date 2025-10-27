import 'package:flutter/material.dart';

class SampleImagesPopup extends StatelessWidget {
  final String title;
  final List<String> cautions;
  final List<String> samples;

  const SampleImagesPopup({
    super.key,
    required this.title,
    required this.cautions,
    required this.samples,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Cautions:"),
            const SizedBox(height: 8),
            ...cautions.map((c) => Text(c)).toList(),
            const SizedBox(height: 16),
            const Text("Samples:"),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: samples.map((path) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(path, width: 100, height: 100, fit: BoxFit.cover),
                );
              }).toList(),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Close"),
        ),
      ],
    );
  }
}
