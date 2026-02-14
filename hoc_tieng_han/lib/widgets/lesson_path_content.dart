import 'package:flutter/material.dart';
import '../models/topic.dart';

/// Lesson path view — bản đồ học tập với đường đi nối liền các bài học
class LessonPathContent extends StatefulWidget {
  final Topic topic;
  final int currentLessonIndex; // Bài học hiện tại (mascot đứng ở đây)
  final void Function(Lesson lesson) onLessonSelected;
  final VoidCallback? onSwipeUpToLesson; // Lướt lên để vào bài học

  const LessonPathContent({
    super.key,
    required this.topic,
    required this.currentLessonIndex,
    required this.onLessonSelected,
    this.onSwipeUpToLesson,
  });

  @override
  State<LessonPathContent> createState() => _LessonPathContentState();
}

class _LessonPathContentState extends State<LessonPathContent>
    with TickerProviderStateMixin {
  late AnimationController _hintController;
  late Animation<double> _hintAnimation;
  late AnimationController _mascotController;
  late Animation<double> _mascotBounce;

  @override
  void initState() {
    super.initState();
    // Animation cho mũi tên hint lướt lên
    _hintController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _hintAnimation = Tween<double>(begin: 0, end: -12).animate(
      CurvedAnimation(parent: _hintController, curve: Curves.easeInOut),
    );

    // Animation cho mascot nhảy nhẹ
    _mascotController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
    _mascotBounce = Tween<double>(begin: 0, end: -6).animate(
      CurvedAnimation(parent: _mascotController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _hintController.dispose();
    _mascotController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragEnd: (details) {
        // Lướt lên (velocity âm) → vào bài học hiện tại
        if (details.primaryVelocity != null &&
            details.primaryVelocity! < -300) {
          widget.onSwipeUpToLesson?.call();
        }
      },
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF8F4EE), Color(0xFFF0EBE3)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(top: 80, bottom: 100),
            child: _buildPathLayout(),
          ),
        ),
      ),
    );
  }

  Widget _buildPathLayout() {
    final lessons = widget.topic.lessons;
    final totalLessons = lessons.length;

    return Column(
      children: [
        // == ROW 1: Lesson 1 (left) ——— Lesson 2 (right) ==
        if (totalLessons >= 2)
          _buildTopRow(lessons)
        else if (totalLessons == 1)
          _buildSingleNode(lessons[0], 0),

        // == VERTICAL CHAIN: Lesson 3+ (right side) ==
        if (totalLessons > 2)
          for (int i = 2; i < totalLessons; i++) ...[
            _buildVerticalConnector(),
            _buildRightAlignedNode(lessons[i], i),
          ],

        // == BOTTOM ROW: connector + Exam/Review ==
        _buildVerticalConnector(),
        _buildBottomRow(),

        // == Swipe-up hint ==
        const SizedBox(height: 40),
        _buildSwipeHint(),
      ],
    );
  }

  // ===== ROW 1: Lesson 1 — Lesson 2 =====
  Widget _buildTopRow(List<Lesson> lessons) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        children: [
          // Lesson 1 (left)
          _buildLessonCard(lessons[0], 0),
          // Horizontal connector
          Expanded(
            child: Container(
              height: 3,
              margin: const EdgeInsets.only(bottom: 24),
              color: const Color(0xFFE0D8CC),
            ),
          ),
          // Lesson 2 (right)
          _buildLessonCard(lessons[1], 1),
        ],
      ),
    );
  }

  // ===== Right-aligned node =====
  Widget _buildRightAlignedNode(Lesson lesson, int index) {
    return Padding(
      padding: const EdgeInsets.only(right: 32),
      child: Align(
        alignment: Alignment.centerRight,
        child: _buildLessonCard(lesson, index),
      ),
    );
  }

  // ===== Single node (center) =====
  Widget _buildSingleNode(Lesson lesson, int index) {
    return Center(child: _buildLessonCard(lesson, index));
  }

  // ===== Vertical connector =====
  Widget _buildVerticalConnector() {
    return Padding(
      padding: const EdgeInsets.only(right: 32),
      child: Align(
        alignment: Alignment.centerRight,
        child: SizedBox(
          width: 76,
          height: 50,
          child: Center(
            child: Container(
              width: 3,
              height: 50,
              color: const Color(0xFFE0D8CC),
            ),
          ),
        ),
      ),
    );
  }

  // ===== Bottom row: Exam (left) — Review (right) =====
  Widget _buildBottomRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        children: [
          // Exam (left)
          _buildExamNode(),
          // Horizontal connector
          Expanded(
            child: Container(
              height: 3,
              margin: const EdgeInsets.only(bottom: 24),
              color: const Color(0xFFE0D8CC),
            ),
          ),
          // Review (right)
          _buildReviewNode(),
        ],
      ),
    );
  }

  // ===== Lesson Card =====
  Widget _buildLessonCard(Lesson lesson, int index) {
    final isCurrent = index == widget.currentLessonIndex;
    final isUnlocked = index <= widget.currentLessonIndex;
    final isCompleted = index < widget.currentLessonIndex;

    return GestureDetector(
      onTap: isUnlocked ? () => widget.onLessonSelected(lesson) : null,
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              // Card chính
              Container(
                width: 76,
                height: 76,
                decoration: BoxDecoration(
                  color: isCurrent
                      ? const Color(0xFF8B7AE8)
                      : isCompleted
                      ? Colors.white
                      : const Color(0xFFF0EBE3),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isCurrent
                        ? const Color(0xFF7B68EE)
                        : isCompleted
                        ? const Color(0xFF7B68EE).withValues(alpha: 0.5)
                        : const Color(0xFFD8D0C4),
                    width: isCurrent ? 3 : 2,
                  ),
                  boxShadow: isCurrent
                      ? [
                          BoxShadow(
                            color: const Color(
                              0xFF7B68EE,
                            ).withValues(alpha: 0.3),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ]
                      : [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                ),
                child: Center(
                  child: isCurrent
                      ? const Icon(
                          Icons.play_arrow_rounded,
                          color: Colors.white,
                          size: 36,
                        )
                      : isCompleted
                      ? Text(
                          '${index + 1}',
                          style: const TextStyle(
                            color: Color(0xFF7B68EE),
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                          ),
                        )
                      : Icon(
                          Icons.lock_rounded,
                          color: Colors.grey.shade400,
                          size: 26,
                        ),
                ),
              ),

              // Mascot water (chỉ ở bài hiện tại)
              if (isCurrent)
                AnimatedBuilder(
                  animation: _mascotBounce,
                  builder: (context, child) {
                    return Positioned(
                      top: -52 + _mascotBounce.value,
                      child: child!,
                    );
                  },
                  child: Image.asset(
                    'assets/images/water.webp',
                    width: 52,
                    height: 52,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.water_drop,
                        size: 36,
                        color: Color(0xFF7B68EE),
                      );
                    },
                  ),
                ),

              // Badge (ở bài hiện tại)
              if (isCurrent)
                Positioned(
                  top: -8,
                  right: -8,
                  child: Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFAA33),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFFAA33).withValues(alpha: 0.4),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        '${lesson.words.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Lesson ${index + 1}',
            style: TextStyle(
              color: isUnlocked
                  ? const Color(0xFF4A4A4A)
                  : Colors.grey.shade400,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  // ===== Exam Node =====
  Widget _buildExamNode() {
    return Column(
      children: [
        Container(
          width: 76,
          height: 76,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFFFD54F), Color(0xFFFFB300)],
            ),
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFE8D5A0), width: 2),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFFB300).withValues(alpha: 0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Center(
            child: Icon(
              Icons.emoji_events_rounded,
              color: Colors.white,
              size: 32,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Exam',
          style: TextStyle(
            color: Colors.grey.shade400,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  // ===== Review Node =====
  Widget _buildReviewNode() {
    return Column(
      children: [
        Container(
          width: 76,
          height: 76,
          decoration: BoxDecoration(
            color: const Color(0xFFF0EBE3),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFD8D0C4), width: 2),
          ),
          child: Center(
            child: Icon(
              Icons.refresh_rounded,
              color: Colors.grey.shade400,
              size: 26,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Review',
          style: TextStyle(
            color: Colors.grey.shade400,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  // ===== Swipe-up hint =====
  Widget _buildSwipeHint() {
    if (widget.currentLessonIndex >= widget.topic.lessons.length) {
      return const SizedBox.shrink();
    }
    return AnimatedBuilder(
      animation: _hintAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _hintAnimation.value),
          child: child,
        );
      },
      child: Column(
        children: [
          Icon(
            Icons.keyboard_arrow_up_rounded,
            color: const Color(0xFF7B68EE).withValues(alpha: 0.6),
            size: 32,
          ),
          const SizedBox(height: 4),
          Text(
            'Lướt lên để bắt đầu học',
            style: TextStyle(
              color: const Color(0xFF7B68EE).withValues(alpha: 0.6),
              fontSize: 13,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}
