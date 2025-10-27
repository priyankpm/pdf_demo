import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class BoundingBox extends ConsumerStatefulWidget {
  final Offset position;
  final VoidCallback onPet;
  final double size;
  final Duration animationDuration;

  const BoundingBox({
    Key? key,
    required this.position,
    required this.onPet,
    this.size = 100.0,
    this.animationDuration = const Duration(milliseconds: 300),
  }) : super(key: key);

  @override
  _BoundingBoxState createState() => _BoundingBoxState();
}

class _BoundingBoxState extends ConsumerState<BoundingBox>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  bool _isVisible = true;
  int _petCount = 0;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: widget.animationDuration,
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

    // Start animation
    _controller.forward();

    // Auto-hide after some time
    _startAutoHideTimer();
  }

  void _startAutoHideTimer() {
    Future.delayed(Duration(seconds: 3), () {
      if (mounted) {
        _hide();
      }
    });
  }

  void _hide() {
    setState(() {
      _isVisible = false;
    });
    _controller.reverse().then((_) {
      if (mounted) {
        // Remove widget after animation completes
        // This would typically be handled by the parent
      }
    });
  }

  void _handlePet() {
    _petCount++;
    widget.onPet();

    // Show petting feedback
    _showPettingFeedback();

    // Reset or hide after multiple pets
    if (_petCount >= 3) {
      _hide();
    } else {
      // Restart animation for subsequent pets
      _controller.reset();
      _controller.forward();
      _startAutoHideTimer();
    }
  }

  void _showPettingFeedback() {
    // Show a little heart animation or other feedback
    _showFloatingHeart();

    // Haptic feedback (if available)
    // HapticFeedback.lightImpact();
  }

  void _showFloatingHeart() {
    OverlayEntry? overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: widget.position.dx - 20,
        top: widget.position.dy - 40,
        child: Material(
          color: Colors.transparent,
          child: HeartAnimation(
            onComplete: () {
              overlayEntry?.remove();
            },
          ),
        ),
      ),
    );

    Overlay.of(context).insert(overlayEntry);
  }

  @override
  Widget build(BuildContext context) {
    if (!_isVisible) return SizedBox.shrink();

    return Positioned(
      left: widget.position.dx - widget.size / 2,
      top: widget.position.dy - widget.size / 2,
      child: GestureDetector(
        onTap: _handlePet,
        onPanUpdate: (details) {
          // Update position while panning
          // This would require callback to parent to update position
        },
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
          child: _buildBoundingBoxContent(),
        ),
      ),
    );
  }

  Widget _buildBoundingBoxContent() {
    return Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.amber.withOpacity(0.8),
          width: 3.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.amber.withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Pulsing animation background
          _buildPulsingBackground(),

          // Touch indicator
          Center(
            child: Icon(
              Icons.touch_app,
              color: Colors.amber,
              size: 32,
            ),
          ),

          // Pet count indicator
          Positioned(
            top: 5,
            right: 5,
            child: Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.amber,
                shape: BoxShape.circle,
              ),
              child: Text(
                '$_petCount',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // Instruction text
          Positioned(
            bottom: 5,
            left: 0,
            right: 0,
            child: Text(
              'Pet here!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.amber,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPulsingBackground() {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 1500),
      builder: (context, double value, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.amber.withOpacity(0.2 * (1 - value)),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

// Heart animation for petting feedback
class HeartAnimation extends StatefulWidget {
  final VoidCallback onComplete;

  const HeartAnimation({Key? key, required this.onComplete}) : super(key: key);

  @override
  _HeartAnimationState createState() => _HeartAnimationState();
}

class _HeartAnimationState extends State<HeartAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _positionAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.5,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));

    _opacityAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _positionAnimation = Tween<Offset>(
      begin: Offset(0, 0),
      end: Offset(0, -1.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));

    _controller.forward().then((_) {
      widget.onComplete();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _opacityAnimation.value,
          child: Transform.translate(
            offset: _positionAnimation.value * 50,
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: child,
            ),
          ),
        );
      },
      child: Icon(
        Icons.favorite,
        color: Colors.red,
        size: 24,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

// Provider for managing multiple bounding boxes
final boundingBoxProvider = StateNotifierProvider<BoundingBoxNotifier, List<Offset>>(
      (ref) => BoundingBoxNotifier(),
);

class BoundingBoxNotifier extends StateNotifier<List<Offset>> {
  BoundingBoxNotifier() : super([]);

  void addBoundingBox(Offset position) {
    state = [...state, position];
  }

  void removeBoundingBox(Offset position) {
    state = state.where((pos) => pos != position).toList();
  }

  void clearAll() {
    state = [];
  }
}