import 'dart:ui';
import 'package:flutter/material.dart';
import '../models/topic.dart';
import '../models/word.dart';
import '../services/tts_service.dart';
import '../widgets/flip_card_widget.dart';

/// Loại card trong bài học
enum CardType { basic, flashText, flashImage }

/// Nội dung bài học (không có header/bottom — được quản lý bởi LearningShellScreen)
class LessonContent extends StatefulWidget {
  final Lesson lesson;
  final void Function(int currentIndex, int totalPages)? onProgressChanged;
  final VoidCallback? onSwipeBackToPath; // Lướt xuống ở trang đầu
  final VoidCallback? onLessonCompleted; // Lướt lên ở trang cuối

  const LessonContent({
    super.key,
    required this.lesson,
    this.onProgressChanged,
    this.onSwipeBackToPath,
    this.onLessonCompleted,
  });

  @override
  State<LessonContent> createState() => _LessonContentState();
}

class _LessonContentState extends State<LessonContent> {
  late PageController _pageController;
  final TtsService _tts = TtsService();
  int _currentIndex = 0;
  final Set<int> _likedWords = {};

  int get _totalPages => widget.lesson.words.length * 3;

  // Overscroll tracking
  bool _overscrollTriggered = false;
  static const _overscrollThreshold = 40.0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _speakCurrentWord();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onProgressChanged?.call(_currentIndex, _totalPages);
    });
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
    widget.onProgressChanged?.call(index, _totalPages);
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

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification is ScrollStartNotification) {
      _overscrollTriggered = false;
    } else if (notification is ScrollUpdateNotification) {
      if (_overscrollTriggered) return false;
      final pixels = notification.metrics.pixels;
      final maxExtent = notification.metrics.maxScrollExtent;

      // Kéo quá đầu
      if (pixels < -_overscrollThreshold) {
        _overscrollTriggered = true;
        widget.onSwipeBackToPath?.call();
      }

      // Kéo quá cuối
      if (pixels > maxExtent + _overscrollThreshold) {
        _overscrollTriggered = true;
        widget.onLessonCompleted?.call();
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final word = _getWordForPage(_currentIndex);
    final cardType = _getCardType(_currentIndex);
    final isBasicCard = cardType == CardType.basic;

    return Stack(
      fit: StackFit.expand,
      children: [
        // Background
        _buildBlurredBackground(word),

        // PageView with overscroll detection
        SafeArea(
          child: NotificationListener<ScrollNotification>(
            onNotification: _handleScrollNotification,
            child: PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.vertical,
              physics: const BouncingScrollPhysics(),
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
        ),

        // Action buttons (basic card only)
        if (isBasicCard)
          Positioned(
            right: 16,
            top: 0,
            bottom: 0,
            child: SafeArea(child: Center(child: _buildFixedActionButtons())),
          ),
      ],
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
                onTap: () => _tts.speak(word.korean, rate: 0.1),
              ),
            ],
          ),
        ],
      ),
    );
  }

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
                onTap: () => _tts.speak(word.korean, rate: 0.1),
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
            _tts.speak(word.korean, rate: 0.1);
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
}
