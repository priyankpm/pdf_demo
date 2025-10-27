import 'package:flutter/material.dart';

class ReportIssueScreen extends StatefulWidget {
  const ReportIssueScreen({super.key});

  @override
  State<ReportIssueScreen> createState() => _ReportIssueScreenState();
}

class _ReportIssueScreenState extends State<ReportIssueScreen> {
  String? selectedIssue = "Other";
  final TextEditingController feedbackController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Title
              const Text(
                "We’re sorry to hear you are facing issues.",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                "Please let us know what went wrong so we are able to make the necessary changes.",
                style: TextStyle(fontSize: 14, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              // Pet image
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  "assets/pet.png", // replace with your pet image path
                  height: 180,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20),

              // Options
              Column(
                children: [
                  buildOption("App Crashed & Freezing"),
                  buildOption("Incorrect Pet"),
                  buildOption("Other"),
                ],
              ),
              const SizedBox(height: 20),

              // Text input
              TextField(
                controller: feedbackController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: "Describe your experience here",
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Submit button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Handle submit
                    debugPrint("Issue: $selectedIssue");
                    debugPrint("Feedback: ${feedbackController.text}");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const LinearGradient(
                      colors: [Color(0xFFD4A373), Color(0xFFB06C49)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).createShader(const Rect.fromLTWH(0, 0, 200, 50))
                    as Color?, // simple trick for gradient-like look
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Submit Feedback",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildOption(String title) {
    return RadioListTile<String>(
      value: title,
      groupValue: selectedIssue,
      activeColor: Colors.brown,
      onChanged: (value) {
        setState(() {
          selectedIssue = value;
        });
      },
      title: Text(title),
    );
  }
}
