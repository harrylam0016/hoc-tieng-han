import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import '../models/topic.dart';
import '../models/word.dart';
import '../services/tts_service.dart';

/// Loại card trong bài học
enum CardType { basic, flashText, flashImage }

/// Màn hình học từ vựng
class LessonScreen extends StatefulWidget {
  final Lesson lesson;

  const LessonScreen({super.key, required this.lesson});

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  late PageController _pageController;
  final TtsService _tts = TtsService();
  int _currentIndex = 0;
  final Set<int> _likedWords = {};

  int get _totalPages => widget.lesson.words.length * 3;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _speakCurrentWord();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _tts.stop();
    super.dispose();
  }

  CardType _getCardType(int pageIndex) {
    final wordsCount = widget.lesson.words.length;
    if (pageIndex < wordsCount) {
      return CardType.basic;
    } else if (pageIndex < wordsCount * 2) {
      return CardType.flashText;
    } else {
      return CardType.flashImage;
    }
  }

  Word _getWordForPage(int pageIndex) {
    final wordsCount = widget.lesson.words.length;
    final wordIndex = pageIndex % wordsCount;
    return widget.lesson.words[wordIndex];
  }

  void _speakCurrentWord() {
    // Chỉ tự động phát âm khi ở Basic Card
    if (_getCardType(_currentIndex) == CardType.basic) {
      if (_tts.isReady && widget.lesson.words.isNotEmpty) {
        final word = _getWordForPage(_currentIndex);
        _tts.speak(word.korean);
      }
    }
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
    _speakCurrentWord();
  }

  void _toggleLike() {
    final wordIndex = _currentIndex % widget.lesson.words.length;
    setState(() {
      if (_likedWords.contains(wordIndex)) {
        _likedWords.remove(wordIndex);
      } else {
        _likedWords.add(wordIndex);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final word = _getWordForPage(_currentIndex);
    final cardType = _getCardType(_currentIndex);
    final isBasicCard = cardType == CardType.basic;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Layer 0: Blurred background
          _buildBlurredBackground(word),

          // Layer 1: PageView (full screen, slides behind header & bottom)
          SafeArea(
            child: PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.vertical,
              onPageChanged: _onPageChanged,
              itemCount: _totalPages,
              itemBuilder: (context, index) {
                final cardType = _getCardType(index);
                final word = _getWordForPage(index);

                switch (cardType) {
                  case CardType.basic:
                    return _buildBasicCard(word);
                  case CardType.flashText:
                    return _buildFlipCardWithLabel(
                      FlipCardWidget(
                        key: ValueKey('flash_text_$index'),
                        front: _buildFlashTextFront(word),
                        back: _buildFlashTextBack(word),
                        onFlip: () => _tts.speak(word.korean),
                      ),
                    );
                  case CardType.flashImage:
                    return _buildFlipCardWithLabel(
                      FlipCardWidget(
                        key: ValueKey('flash_image_$index'),
                        front: _buildFlashImageFront(word),
                        back: _buildFlashImageBack(word),
                        onFlip: () => _tts.speak(word.korean),
                      ),
                    );
                }
              },
            ),
          ),

          // Layer 2: Header (on top, cards slide behind it)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(bottom: false, child: _buildHeader()),
          ),

          // Layer 3: Bottom hint (on top, cards slide behind it)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SafeArea(top: false, child: _buildBottomHint()),
          ),

          // Layer 4: Action buttons (basic card only)
          if (isBasicCard)
            Positioned(
              right: 16,
              top: 0,
              bottom: 0,
              child: SafeArea(child: Center(child: _buildFixedActionButtons())),
            ),
        ],
      ),
    );
  }

  Widget _buildFlipCardWithLabel(Widget flipCard) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        flipCard,
        const SizedBox(height: 24),
        Text(
          'Chạm để lật',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.6),
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildBlurredBackground(Word word) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          word.imagePath,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF2d1f3d), Color(0xFF1a1a2e)],
                ),
              ),
            );
          },
        ),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
          child: Container(color: Colors.black.withValues(alpha: 0.5)),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    final progress = (_currentIndex + 1) / _totalPages;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildMenuItem('Từ vựng', true),
                const SizedBox(width: 24),
                _buildMenuItem('Chữ cái', false),
                const SizedBox(width: 24),
                _buildMenuItem('Câu', false),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Stack(
            alignment: Alignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.3),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 120,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.white.withValues(alpha: 0.2),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFF4A90D9),
                    ),
                    minHeight: 6,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(String text, bool isSelected) {
    return Text(
      text,
      style: TextStyle(
        color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.5),
        fontSize: 17,
        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
      ),
    );
  }

  Widget _buildBasicCard(Word word) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 220,
            height: 220,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Image.asset(
                word.imagePath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Icon(
                      Icons.image_not_supported,
                      size: 64,
                      color: Colors.grey,
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 28),

          Text(
            word.korean,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 44,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 6),

          Text(
            word.romanization,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 18,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 14),

          Container(
            width: 80,
            height: 1,
            color: Colors.white.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 14),

          Text(
            word.vietnamese,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // Flash Text Card - Front (không có nút, không có text)
  Widget _buildFlashTextFront(Word word) {
    return Container(
      width: 300,
      height: 420,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF4A90D9), Color(0xFF357ABD)],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            word.korean,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 52,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            word.romanization,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 22,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  // Flash Text Card - Back (có nút âm thanh icon only)
  Widget _buildFlashTextBack(Word word) {
    return Container(
      width: 300,
      height: 420,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            word.vietnamese,
            style: const TextStyle(
              color: Color(0xFF1a1a2e),
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),

          // Audio action buttons (icon only)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildIconOnlyButton(
                icon: Icons.volume_up,
                color: const Color(0xFF4A90D9),
                onTap: () => _tts.speak(word.korean),
              ),
              const SizedBox(width: 24),
              _buildIconOnlyButton(
                icon: Icons.slow_motion_video,
                color: const Color(0xFF4A90D9).withValues(alpha: 0.7),
                onTap: () => _tts.speak(word.korean, rate: 0.1), // Rất chậm
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Flash Image Card - Front (không có nút)
  Widget _buildFlashImageFront(Word word) {
    return Container(
      width: 300,
      height: 420,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              word.imagePath,
              width: 220,
              height: 220,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.image_not_supported,
                  size: 64,
                  color: Colors.grey,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Flash Image Card - Back (có nút âm thanh)
  Widget _buildFlashImageBack(Word word) {
    return Container(
      width: 300,
      height: 420,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            word.korean,
            style: const TextStyle(
              color: Color(0xFF1a1a2e),
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            word.romanization,
            style: TextStyle(
              color: const Color(0xFF1a1a2e).withValues(alpha: 0.6),
              fontSize: 20,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: 60,
            height: 1,
            color: const Color(0xFF1a1a2e).withValues(alpha: 0.2),
          ),
          const SizedBox(height: 20),
          Text(
            word.vietnamese,
            style: const TextStyle(
              color: Color(0xFF1a1a2e),
              fontSize: 28,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 32),

          // Audio action buttons (icon only)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildIconOnlyButton(
                icon: Icons.volume_up,
                color: const Color(0xFF4A90D9),
                onTap: () => _tts.speak(word.korean),
              ),
              const SizedBox(width: 24),
              _buildIconOnlyButton(
                icon: Icons.slow_motion_video,
                color: const Color(0xFF4A90D9).withValues(alpha: 0.7),
                onTap: () => _tts.speak(word.korean, rate: 0.1), // Rất chậm
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIconOnlyButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: 28),
      ),
    );
  }

  Widget _buildFixedActionButtons() {
    final wordIndex = _currentIndex % widget.lesson.words.length;
    final isLiked = _likedWords.contains(wordIndex);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildActionButton(
          icon: Icon(
            isLiked ? Icons.favorite : Icons.favorite_border,
            color: isLiked ? Colors.red : Colors.white,
            size: 28,
          ),
          onTap: _toggleLike,
        ),
        const SizedBox(height: 28),

        _buildActionButton(
          icon: const Icon(Icons.volume_up, color: Colors.white, size: 28),
          onTap: () {
            final word = _getWordForPage(_currentIndex);
            _tts.speak(word.korean);
          },
        ),
        const SizedBox(height: 28),

        _buildActionButton(
          icon: const Icon(
            Icons.slow_motion_video,
            color: Colors.white,
            size: 28,
          ),
          onTap: () {
            final word = _getWordForPage(_currentIndex);
            _tts.speak(word.korean, rate: 0.1); // Rate rất chậm
          },
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required Widget icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.3),
          shape: BoxShape.circle,
        ),
        child: icon,
      ),
    );
  }

  Widget _buildBottomHint() {
    if (_currentIndex >= _totalPages - 1) {
      return const SizedBox(height: 60);
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(height: 4),
          Icon(
            Icons.keyboard_arrow_up,
            color: Colors.white.withValues(alpha: 0.6),
            size: 24,
          ),
        ],
      ),
    );
  }
}

/// Widget Flip Card với animation mượt mà
class FlipCardWidget extends StatefulWidget {
  final Widget front;
  final Widget back;
  final VoidCallback? onFlip; // Callback khi lật

  const FlipCardWidget({
    super.key,
    required this.front,
    required this.back,
    this.onFlip,
  });

  @override
  State<FlipCardWidget> createState() => _FlipCardWidgetState();
}

class _FlipCardWidgetState extends State<FlipCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _showFront = true;

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

  void _flip() {
    if (_showFront) {
      _controller.forward();
      // Chỉ gọi callback khi lật sang mặt sau
      widget.onFlip?.call();
    } else {
      _controller.reverse();
    }
    setState(() {
      _showFront = !_showFront;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _flip,
      child: Center(
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            final angle = _animation.value * pi;
            final isFrontVisible = angle < pi / 2;

            return Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(angle),
              alignment: Alignment.center,
              child: isFrontVisible
                  ? widget.front
                  : Transform(
                      transform: Matrix4.identity()..rotateY(pi),
                      alignment: Alignment.center,
                      child: widget.back,
                    ),
            );
          },
        ),
      ),
    );
  }
}
