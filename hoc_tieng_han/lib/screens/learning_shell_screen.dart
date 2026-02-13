import 'package:flutter/material.dart';
import '../models/topic.dart';
import '../services/tts_service.dart';
import '../widgets/topic_selection_content.dart';
import 'lesson_screen.dart';

/// Màn hình shell chứa header/menu bar dùng chung
/// Chuyển đổi giữa topic selection và lesson content
class LearningShellScreen extends StatefulWidget {
  final Lesson? initialLesson;

  const LearningShellScreen({super.key, this.initialLesson});

  @override
  State<LearningShellScreen> createState() => _LearningShellScreenState();
}

class _LearningShellScreenState extends State<LearningShellScreen> {
  int _selectedTab = 0; // 0: Từ vựng, 1: Chữ cái, 2: Câu
  Lesson? _currentLesson;

  // Lesson progress tracking
  int _lessonCurrentIndex = 0;
  int _lessonTotalPages = 1;

  @override
  void initState() {
    super.initState();
    _currentLesson = widget.initialLesson;
    // Initialize TTS in background
    TtsService().initialize();
  }

  void _onLessonSelected(Lesson lesson) {
    setState(() {
      _currentLesson = lesson;
      _lessonCurrentIndex = 0;
      _lessonTotalPages = lesson.words.length * 3;
    });
  }

  void _onClosePressed() {
    if (_currentLesson != null) {
      // Đang học → quay về chọn bài
      setState(() {
        _currentLesson = null;
      });
    }
  }

  void _onLessonProgressChanged(int currentIndex, int totalPages) {
    setState(() {
      _lessonCurrentIndex = currentIndex;
      _lessonTotalPages = totalPages;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isInLesson = _currentLesson != null;
    final progress = isInLesson
        ? (_lessonCurrentIndex + 1) / _lessonTotalPages
        : 0.0;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Layer 0: Content (lesson or topic selection)
          if (isInLesson)
            LessonContent(
              key: ValueKey(_currentLesson!.id),
              lesson: _currentLesson!,
              onProgressChanged: _onLessonProgressChanged,
            )
          else
            TopicSelectionContent(onLessonSelected: _onLessonSelected),

          // Layer 1: Header (on top)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              bottom: false,
              child: _buildHeader(progress, isInLesson),
            ),
          ),

          // Layer 2: Bottom hint (only in lesson)
          if (isInLesson)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: SafeArea(top: false, child: _buildBottomHint()),
            ),
        ],
      ),
    );
  }

  Widget _buildHeader(double progress, bool isInLesson) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 8),
          // Top Row: Back Button + Menu Bar
          Stack(
            alignment: Alignment.center,
            children: [
              // Back Button (Left aligned)
              if (isInLesson)
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: _onClosePressed,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.3),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ),

              // Menu Bar (Center aligned)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize:
                    MainAxisSize.min, // Keep it compact to center properly
                children: [
                  _buildMenuItem('Từ vựng', 0),
                  const SizedBox(width: 24),
                  _buildMenuItem('Chữ cái', 1),
                  const SizedBox(width: 24),
                  _buildMenuItem('Câu', 2),
                ],
              ),
            ],
          ),

          // Progress bar (only show when in lesson)
          if (isInLesson) ...[
            const SizedBox(height: 16),
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
        ],
      ),
    );
  }

  Widget _buildMenuItem(String text, int index) {
    final isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTab = index;
        });
      },
      child: Text(
        text,
        style: TextStyle(
          color: isSelected
              ? Colors.white
              : Colors.white.withValues(alpha: 0.5),
          fontSize: 17,
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildBottomHint() {
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
