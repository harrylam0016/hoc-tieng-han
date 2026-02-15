import 'package:flutter/material.dart';
import '../models/topic.dart';
import '../services/tts_service.dart';
import '../widgets/lesson_path_content.dart';
import '../widgets/topic_selection_content.dart';
import 'lesson_screen.dart';

enum ShellView { topics, lessonPath, lesson }

/// Hướng chuyển cảnh
enum _TransitionDir {
  enterLesson, // Path ↑ out, Lesson ↑ in from below
  completedLesson, // Lesson ↑ out, Path ↑ in from below
  backToPath, // Lesson ↓ out, Path ↓ in from above
}

class LearningShellScreen extends StatefulWidget {
  final Lesson? initialLesson;

  const LearningShellScreen({super.key, this.initialLesson});

  @override
  State<LearningShellScreen> createState() => _LearningShellScreenState();
}

class _LearningShellScreenState extends State<LearningShellScreen>
    with TickerProviderStateMixin {
  int _selectedTab = 0;

  ShellView _currentView = ShellView.topics;
  Topic? _currentTopic;
  Lesson? _currentLesson;
  int _currentLessonIndex = 0;

  int _lessonCurrentIndex = 0;
  int _lessonTotalPages = 1;

  // --- Transition ---
  late AnimationController _transitionController;
  bool _isTransitioning = false;
  _TransitionDir _transitionDir = _TransitionDir.enterLesson;

  // GlobalKey giữ state cho LessonContent qua transition (tránh reset page)
  final _lessonGlobalKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    if (widget.initialLesson != null) {
      _currentLesson = widget.initialLesson;
      _currentView = ShellView.lesson;
    }
    TtsService().initialize();

    _transitionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _transitionController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _isTransitioning = false;
          if (_transitionDir == _TransitionDir.enterLesson) {
            _currentView = ShellView.lesson;
          } else {
            _currentLesson = null;
            _currentView = ShellView.lessonPath;
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _transitionController.dispose();
    super.dispose();
  }

  // --- Offset helpers based on direction ---
  Offset _outgoingEnd() {
    switch (_transitionDir) {
      case _TransitionDir.enterLesson:
      case _TransitionDir.completedLesson:
        return const Offset(0, -0.2); // slide UP out
      case _TransitionDir.backToPath:
        return const Offset(0, 0.2); // slide DOWN out
    }
  }

  Offset _incomingStart() {
    switch (_transitionDir) {
      case _TransitionDir.enterLesson:
      case _TransitionDir.completedLesson:
        return const Offset(0, 1.0); // from below
      case _TransitionDir.backToPath:
        return const Offset(0, -1.0); // from above
    }
  }

  void _onTopicSelected(Topic topic) {
    setState(() {
      _currentTopic = topic;
      _currentLessonIndex = 0;
      _currentView = ShellView.lessonPath;
    });
  }

  void _onLessonSelected(Lesson lesson) {
    final index = _currentTopic?.lessons.indexOf(lesson) ?? 0;
    if (index > _currentLessonIndex) return;
    _startLesson(lesson);
  }

  void _onSwipeUpToLesson() {
    if (_currentTopic == null || _isTransitioning) return;
    if (_currentLessonIndex >= _currentTopic!.lessons.length) return;
    final lesson = _currentTopic!.lessons[_currentLessonIndex];
    _startLesson(lesson);
  }

  /// Vào bài học — path slides UP, lesson enters from BELOW
  void _startLesson(Lesson lesson) {
    if (_isTransitioning) return;
    setState(() {
      _currentLesson = lesson;
      _lessonCurrentIndex = 0;
      _lessonTotalPages = lesson.words.length * 3;
      _transitionDir = _TransitionDir.enterLesson;
      _isTransitioning = true;
    });
    _transitionController.forward(from: 0);
  }

  /// Hoàn thành bài — lesson slides UP, path enters from BELOW
  void _onLessonCompleted() {
    if (_isTransitioning) return;
    setState(() {
      if (_currentTopic != null &&
          _currentLessonIndex < _currentTopic!.lessons.length - 1) {
        _currentLessonIndex++;
      }
      _transitionDir = _TransitionDir.completedLesson;
      _isTransitioning = true;
    });
    _transitionController.forward(from: 0);
  }

  /// Kéo quá đầu bài — lesson slides DOWN, path enters from ABOVE
  void _onSwipeBackToPath() {
    if (_isTransitioning) return;
    setState(() {
      _transitionDir = _TransitionDir.backToPath;
      _isTransitioning = true;
    });
    _transitionController.forward(from: 0);
  }

  void _onBackPressed() {
    if (_isTransitioning) return;
    switch (_currentView) {
      case ShellView.lesson:
        _onSwipeBackToPath();
        break;
      case ShellView.lessonPath:
        setState(() {
          _currentTopic = null;
          _currentView = ShellView.topics;
        });
        break;
      case ShellView.topics:
        break;
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
    final isInLesson = _currentView == ShellView.lesson;
    final showBackButton = _currentView != ShellView.topics || _isTransitioning;
    final progress = isInLesson
        ? (_lessonCurrentIndex + 1) / _lessonTotalPages
        : 0.0;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          _buildContent(),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              bottom: false,
              child: _buildHeader(progress, isInLesson, showBackButton),
            ),
          ),
          if (isInLesson && !_isTransitioning)
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

  Widget _buildContent() {
    if (_isTransitioning) {
      return _buildTransitionContent();
    }

    switch (_currentView) {
      case ShellView.topics:
        return TopicSelectionContent(onTopicSelected: _onTopicSelected);
      case ShellView.lessonPath:
        return _buildLessonPathWidget();
      case ShellView.lesson:
        return _buildLessonWidget();
    }
  }

  Widget _buildTransitionContent() {
    final Widget outgoing;
    final Widget incoming;

    if (_transitionDir == _TransitionDir.enterLesson) {
      outgoing = _buildLessonPathWidget();
      incoming = _buildLessonWidget();
    } else {
      // Outgoing = lesson (giữ nguyên state nhờ GlobalKey)
      outgoing = IgnorePointer(child: _buildLessonWidget());
      incoming = _buildLessonPathWidget();
    }

    final outgoingSlide = Tween<Offset>(begin: Offset.zero, end: _outgoingEnd())
        .animate(
          CurvedAnimation(
            parent: _transitionController,
            curve: Curves.easeInCubic,
          ),
        );

    final outgoingFade = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _transitionController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    final incomingSlide =
        Tween<Offset>(begin: _incomingStart(), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _transitionController,
            curve: Curves.easeOutCubic,
          ),
        );

    final incomingFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _transitionController,
        curve: const Interval(0.1, 0.7, curve: Curves.easeOut),
      ),
    );

    return Stack(
      fit: StackFit.expand,
      children: [
        SlideTransition(
          position: outgoingSlide,
          child: FadeTransition(opacity: outgoingFade, child: outgoing),
        ),
        SlideTransition(
          position: incomingSlide,
          child: FadeTransition(opacity: incomingFade, child: incoming),
        ),
      ],
    );
  }

  Widget _buildLessonPathWidget() {
    return LessonPathContent(
      key: ValueKey('path_${_currentTopic?.id}_$_currentLessonIndex'),
      topic: _currentTopic!,
      currentLessonIndex: _currentLessonIndex,
      onLessonSelected: _onLessonSelected,
      onSwipeUpToLesson: _onSwipeUpToLesson,
    );
  }

  Widget _buildLessonWidget() {
    return LessonContent(
      key: _lessonGlobalKey,
      lesson: _currentLesson!,
      onProgressChanged: _onLessonProgressChanged,
      onSwipeBackToPath: _onSwipeBackToPath,
      onLessonCompleted: _onLessonCompleted,
    );
  }

  Widget _buildHeader(double progress, bool isInLesson, bool showBackButton) {
    final isDarkText =
        (_currentView == ShellView.lessonPath ||
            _currentView == ShellView.topics ||
            _currentView == ShellView.lesson) &&
        !_isTransitioning;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 8),
          Stack(
            alignment: Alignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IgnorePointer(
                  ignoring: !showBackButton,
                  child: Opacity(
                    opacity: showBackButton ? 1.0 : 0.0,
                    child: GestureDetector(
                      onTap: _onBackPressed,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          // No background
                        ),
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          color: isDarkText
                              ? const Color(0xFF4A3B32)
                              : Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildMenuItem('Từ vựng', 0, isDarkText),
                  const SizedBox(width: 24),
                  _buildMenuItem('Chữ cái', 1, isDarkText),
                  const SizedBox(width: 24),
                  _buildMenuItem('Câu', 2, isDarkText),
                ],
              ),
            ],
          ),
          if (isInLesson) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: 120,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: const Color(
                    0xFF4A3B32,
                  ).withValues(alpha: 0.2),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFF795548), // Brown color
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

  Widget _buildMenuItem(String text, int index, bool isDarkText) {
    final isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = index),
      child: Text(
        text,
        style: TextStyle(
          color: isDarkText
              ? (isSelected
                    ? const Color(0xFF4A3B32)
                    : const Color(0xFF4A3B32).withValues(alpha: 0.4))
              : (isSelected
                    ? Colors.white
                    : Colors.white.withValues(alpha: 0.5)),
          fontSize: 17,
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildBottomHint() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Icon(
        Icons.keyboard_arrow_up,
        color: Colors.white.withValues(alpha: 0.6),
        size: 24,
      ),
    );
  }
}
