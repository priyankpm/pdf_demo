import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ThoughtBubble extends ConsumerStatefulWidget {
  final String text;
  final List<String> imagePaths;
  final Duration displayDuration;
  final VoidCallback? onTap;
  final bool showCloseButton;
  final ThoughtBubbleType type;
  final Color backgroundColor;
  final Color textColor;
  final double maxWidth;

  const ThoughtBubble({
    Key? key,
    required this.text,
    this.imagePaths = const [],
    this.displayDuration = const Duration(seconds: 5),
    this.onTap,
    this.showCloseButton = true,
    this.type = ThoughtBubbleType.speech,
    this.backgroundColor = Colors.white,
    this.textColor = Colors.black,
    this.maxWidth = 250,
  }) : super(key: key);

  @override
  _ThoughtBubbleState createState() => _ThoughtBubbleState();
}

enum ThoughtBubbleType {
  speech,
  thought,
  memory,
  question,
  reminder
}

class _ThoughtBubbleState extends ConsumerState<ThoughtBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  bool _isVisible = true;
  Timer? _autoHideTimer;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));

    _controller.forward();

    // Auto-hide after display duration
    if (widget.displayDuration != Duration.zero) {
      _autoHideTimer = Timer(widget.displayDuration, _hide);
    }
  }

  void _hide() {
    if (!mounted) return;

    setState(() {
      _isVisible = false;
    });

    _controller.reverse().then((_) {
      if (mounted) {
        // Callback to parent for removal could be added here
      }
    });
  }

  void _handleTap() {
    widget.onTap?.call();
    _hide();
  }

  void _restartTimer() {
    _autoHideTimer?.cancel();
    if (widget.displayDuration != Duration.zero) {
      _autoHideTimer = Timer(widget.displayDuration, _hide);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isVisible) return SizedBox.shrink();

    return MouseRegion(
      onEnter: (_) => _restartTimer(),
      child: GestureDetector(
        onTap: _handleTap,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Opacity(
              opacity: _opacityAnimation.value,
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: child,
              ),
            );
          },
          child: _buildBubbleContent(),
        ),
      ),
    );
  }

  Widget _buildBubbleContent() {
    return Container(
      constraints: BoxConstraints(maxWidth: widget.maxWidth),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Main bubble
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _getBubbleColor(),
              borderRadius: _getBorderRadius(),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  offset: Offset(2, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Close button
                if (widget.showCloseButton)
                  Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: _hide,
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: Colors.black26,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.close,
                          size: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                // Type indicator
                if (widget.type != ThoughtBubbleType.speech)
                  Padding(
                    padding: EdgeInsets.only(bottom: 4),
                    child: Row(
                      children: [
                        Icon(
                          _getTypeIcon(),
                          size: 12,
                          color: _getTypeColor(),
                        ),
                        SizedBox(width: 4),
                        Text(
                          _getTypeText(),
                          style: TextStyle(
                            fontSize: 10,
                            color: _getTypeColor(),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                // Text content
                Text(
                  widget.text,
                  style: TextStyle(
                    color: widget.textColor,
                    fontSize: 14,
                  ),
                  softWrap: true,
                ),

                // Images grid
                if (widget.imagePaths.isNotEmpty) ...[
                  SizedBox(height: 8),
                  _buildImagesGrid(),
                ],

                // Action buttons for specific types
                if (widget.type == ThoughtBubbleType.question ||
                    widget.type == ThoughtBubbleType.reminder)
                  _buildActionButtons(),
              ],
            ),
          ),

          // Bubble tail
          _buildBubbleTail(),
        ],
      ),
    );
  }

  Widget _buildImagesGrid() {
    final images = widget.imagePaths.take(4).toList(); // Limit to 4 images
    final crossAxisCount = images.length <= 2 ? images.length : 2;

    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemCount: images.length,
      itemBuilder: (context, index) {
        return Image.asset(
          images[index],
          fit: BoxFit.cover,
          width: 50,
          height: 50,
        );
      },
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: EdgeInsets.only(top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (widget.type == ThoughtBubbleType.question) ...[
            TextButton(
              onPressed: () => _handleAction('Yes'),
              child: Text('Yes', style: TextStyle(fontSize: 12)),
            ),
            TextButton(
              onPressed: () => _handleAction('No'),
              child: Text('No', style: TextStyle(fontSize: 12)),
            ),
          ],
          if (widget.type == ThoughtBubbleType.reminder)
            TextButton(
              onPressed: () => _handleAction('Dismiss'),
              child: Text('Dismiss', style: TextStyle(fontSize: 12)),
            ),
        ],
      ),
    );
  }

  Widget _buildBubbleTail() {
    return CustomPaint(
      size: Size(20, 10),
      painter: _BubbleTailPainter(
        color: _getBubbleColor(),
        type: widget.type,
      ),
    );
  }

  void _handleAction(String action) {
    // Handle bubble action
    print('Bubble action: $action');
    _hide();

    // You could add a callback for actions here
  }

  Color _getBubbleColor() {
    switch (widget.type) {
      case ThoughtBubbleType.thought:
        return Color(0xFFE3F2FD);
      case ThoughtBubbleType.memory:
        return Color(0xFFFFF9C4);
      case ThoughtBubbleType.question:
        return Color(0xFFE8F5E8);
      case ThoughtBubbleType.reminder:
        return Color(0xFFFFEBEE);
      case ThoughtBubbleType.speech:
      default:
        return widget.backgroundColor;
    }
  }

  BorderRadius _getBorderRadius() {
    switch (widget.type) {
      case ThoughtBubbleType.thought:
        return BorderRadius.circular(20);
      case ThoughtBubbleType.memory:
        return BorderRadius.circular(12);
      case ThoughtBubbleType.question:
        return BorderRadius.circular(16);
      case ThoughtBubbleType.reminder:
        return BorderRadius.circular(8);
      case ThoughtBubbleType.speech:
      default:
        return BorderRadius.circular(16);
    }
  }

  IconData _getTypeIcon() {
    switch (widget.type) {
      case ThoughtBubbleType.thought:
        return Icons.psychology;
      case ThoughtBubbleType.memory:
        return Icons.photo_library;
      case ThoughtBubbleType.question:
        return Icons.help_outline;
      case ThoughtBubbleType.reminder:
        return Icons.notifications;
      case ThoughtBubbleType.speech:
      default:
        return Icons.chat_bubble;
    }
  }

  Color _getTypeColor() {
    switch (widget.type) {
      case ThoughtBubbleType.thought:
        return Colors.blue;
      case ThoughtBubbleType.memory:
        return Colors.amber;
      case ThoughtBubbleType.question:
        return Colors.green;
      case ThoughtBubbleType.reminder:
        return Colors.red;
      case ThoughtBubbleType.speech:
      default:
        return Colors.grey;
    }
  }

  String _getTypeText() {
    switch (widget.type) {
      case ThoughtBubbleType.thought:
        return 'Thinking';
      case ThoughtBubbleType.memory:
        return 'Memory';
      case ThoughtBubbleType.question:
        return 'Question';
      case ThoughtBubbleType.reminder:
        return 'Reminder';
      case ThoughtBubbleType.speech:
      default:
        return 'Says';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _autoHideTimer?.cancel();
    super.dispose();
  }
}

class _BubbleTailPainter extends CustomPainter {
  final Color color;
  final ThoughtBubbleType type;

  _BubbleTailPainter({required this.color, required this.type});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();

    switch (type) {
      case ThoughtBubbleType.thought:
      // Cloud-like tail for thoughts
        path.moveTo(0, size.height);
        path.quadraticBezierTo(size.width * 0.3, size.height * 0.5,
            size.width, 0);
        path.quadraticBezierTo(size.width * 0.7, size.height * 0.5,
            0, size.height);
        break;
      case ThoughtBubbleType.memory:
      // Sharp tail for memories
        path.moveTo(0, size.height);
        path.lineTo(size.width * 0.5, 0);
        path.lineTo(size.width, size.height);
        path.close();
        break;
      default:
      // Standard rounded tail for others
        path.moveTo(0, size.height);
        path.quadraticBezierTo(size.width * 0.5, 0, size.width, size.height);
        path.close();
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Provider for managing multiple thought bubbles
final thoughtBubbleProvider = StateNotifierProvider<ThoughtBubbleNotifier, List<ThoughtBubbleData>>(
      (ref) => ThoughtBubbleNotifier(),
);

class ThoughtBubbleData {
  final String id;
  final String text;
  final List<String> imagePaths;
  final ThoughtBubbleType type;
  final Duration displayDuration;

  ThoughtBubbleData({
    required this.id,
    required this.text,
    this.imagePaths = const [],
    this.type = ThoughtBubbleType.speech,
    this.displayDuration = const Duration(seconds: 5),
  });
}

class ThoughtBubbleNotifier extends StateNotifier<List<ThoughtBubbleData>> {
  ThoughtBubbleNotifier() : super([]);

  void addBubble(ThoughtBubbleData bubble) {
    state = [...state, bubble];
  }

  void removeBubble(String id) {
    state = state.where((bubble) => bubble.id != id).toList();
  }

  void clearAll() {
    state = [];
  }

  void addMemoryBubble(String memoryText, List<String> imagePaths) {
    addBubble(ThoughtBubbleData(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: memoryText,
      imagePaths: imagePaths,
      type: ThoughtBubbleType.memory,
      displayDuration: Duration(seconds: 8),
    ));
  }

  void addQuestionBubble(String question) {
    addBubble(ThoughtBubbleData(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: question,
      type: ThoughtBubbleType.question,
      displayDuration: Duration(seconds: 10),
    ));
  }
}