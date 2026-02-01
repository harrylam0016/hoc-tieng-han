import 'package:flutter/material.dart';
import '../models/word.dart';

/// Widget FlashCard hiển thị từ vựng - TikTok style full screen
class FlashCardWidget extends StatefulWidget {
  final Word word;
  final int cardNumber;
  final int totalCards;
  final Function(String) onSpeak;

  const FlashCardWidget({
    super.key,
    required this.word,
    required this.cardNumber,
    required this.totalCards,
    required this.onSpeak,
  });

  @override
  State<FlashCardWidget> createState() => _FlashCardWidgetState();
}

class _FlashCardWidgetState extends State<FlashCardWidget>
    with SingleTickerProviderStateMixin {
  bool _isFlipped = false;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleCard() {
    if (_isFlipped) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
    setState(() {
      _isFlipped = !_isFlipped;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleCard,
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Card number indicator
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF00d9ff).withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Từ ${widget.cardNumber}/${widget.totalCards}',
                style: const TextStyle(
                  color: Color(0xFF00d9ff),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Main card
            Expanded(
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  final isBack = _animation.value > 0.5;
                  final transform = Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateY(_animation.value * 3.14159);

                  return Transform(
                    transform: transform,
                    alignment: Alignment.center,
                    child: isBack ? _buildBackCard() : _buildFrontCard(),
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            // Hint
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.touch_app,
                  color: Colors.white.withValues(alpha: 0.5),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Chạm để xem nghĩa',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.5),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFrontCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2d1b69), Color(0xFF11998e)],
        ),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF11998e).withValues(alpha: 0.3),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Korean text
          Text(
            widget.word.korean,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 64,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 16),

          // Romanization
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              widget.word.romanization,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                letterSpacing: 1,
              ),
            ),
          ),

          const SizedBox(height: 32),

          // Speak button
          GestureDetector(
            onTap: () => widget.onSpeak(widget.word.korean),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.volume_up, color: Colors.white, size: 32),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackCard() {
    return Transform(
      transform: Matrix4.identity()..rotateY(3.14159),
      alignment: Alignment.center,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFe94560), Color(0xFFff6b6b)],
          ),
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFe94560).withValues(alpha: 0.3),
              blurRadius: 30,
              offset: const Offset(0, 15),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.translate, color: Colors.white54, size: 48),
            const SizedBox(height: 24),
            Text(
              widget.word.vietnamese,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              widget.word.korean,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 28,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
