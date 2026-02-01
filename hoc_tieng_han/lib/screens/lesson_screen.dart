import 'dart:ui';
import 'package:flutter/material.dart';
import '../models/topic.dart';
import '../models/word.dart';
import '../services/tts_service.dart';

/// Màn hình học từ vựng với thiết kế mới
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

  void _speakCurrentWord({double rate = 0.5}) {
    if (_tts.isReady && widget.lesson.words.isNotEmpty) {
      _tts.speak(widget.lesson.words[_currentIndex].korean);
    }
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
    _speakCurrentWord();
  }

  void _toggleLike() {
    setState(() {
      if (_likedWords.contains(_currentIndex)) {
        _likedWords.remove(_currentIndex);
      } else {
        _likedWords.add(_currentIndex);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final word = widget.lesson.words[_currentIndex];
    final totalWords = widget.lesson.words.length;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background với blur effect
          _buildBlurredBackground(word),

          // Nội dung chính
          SafeArea(
            child: Column(
              children: [
                // Header
                _buildHeader(),

                // PageView cho từ vựng
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    scrollDirection: Axis.vertical,
                    onPageChanged: _onPageChanged,
                    itemCount: totalWords,
                    itemBuilder: (context, index) {
                      return _buildWordCard(widget.lesson.words[index]);
                    },
                  ),
                ),

                // Bottom hint
                _buildBottomHint(),
              ],
            ),
          ),

          // Action buttons - Neo cố định bên phải
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
    final progress = (_currentIndex + 1) / widget.lesson.words.length;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.white.withValues(alpha: 0.2),
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFF4A90D9),
              ),
              minHeight: 4,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.close, color: Colors.white, size: 20),
                ),
              ),
              const SizedBox(width: 16),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Lesson ${widget.lesson.lessonNumber}: ${widget.lesson.name}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Card từ vựng - không chứa action buttons nữa
  Widget _buildWordCard(Word word) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 24,
        right: 24,
      ), // right padding cho action buttons
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image card
          Container(
            width: 250,
            height: 250,
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
          const SizedBox(height: 32),

          // Korean word
          Text(
            word.korean,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 48,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 8),

          // Romanization
          Text(
            word.romanization,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 20,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 16),

          // Divider
          Container(
            width: 100,
            height: 1,
            color: Colors.white.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),

          // Vietnamese meaning
          Text(
            word.vietnamese,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  /// Action buttons cố định bên phải
  Widget _buildFixedActionButtons() {
    final isLiked = _likedWords.contains(_currentIndex);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Like button
        _buildActionButton(
          icon: Icon(
            isLiked ? Icons.favorite : Icons.favorite_border,
            color: isLiked ? Colors.red : Colors.white,
            size: 28,
          ),
          onTap: _toggleLike,
        ),
        const SizedBox(height: 28),

        // Normal speed button
        _buildActionButton(
          icon: const Icon(Icons.volume_up, color: Colors.white, size: 28),
          onTap: () => _speakCurrentWord(rate: 0.5),
        ),
        const SizedBox(height: 28),

        // Slow speed button
        _buildActionButton(
          icon: const Icon(
            Icons.slow_motion_video,
            color: Colors.white,
            size: 28,
          ),
          onTap: () => _speakCurrentWord(rate: 0.3),
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
    if (_currentIndex >= widget.lesson.words.length - 1) {
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
