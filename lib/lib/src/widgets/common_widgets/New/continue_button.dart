import 'package:flutter/material.dart';

class ContinueButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool loading;
  final bool enabled;

  const ContinueButton({
    super.key,
    required this.label,
    this.onTap,
    this.loading = false,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final bool isButtonEnabled = enabled && !loading;

    return Center(
      child: GestureDetector(
        onTap: isButtonEnabled ? onTap : null,
          child: Container(
            width: 216,
            height: 50, // ✅ fixed height for button
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isButtonEnabled
                    ? [
                  const Color.fromRGBO(255, 210, 136, 0.5),
                  const Color.fromRGBO(177, 86, 0, 0.5),
                ]
                    : [
                  const Color.fromRGBO(255, 210, 136, 0.3),
                  const Color.fromRGBO(177, 86, 0, 0.3),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center, // ✅ centers child
            child: loading
                ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
              ),
            )
                : Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: isButtonEnabled ? Colors.black : Colors.black54,
              ),
            ),
          ),

      ),
    );
  }
}