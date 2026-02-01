import 'package:flutter/material.dart';
import '../models/topic.dart';
import '../models/question.dart';
import '../widgets/flash_card.dart';
import '../widgets/example_card.dart';
import '../widgets/story_card.dart';
import '../widgets/games/multiple_choice_game.dart';
import '../widgets/games/matching_game.dart';
import '../widgets/games/fill_blank_game.dart';
import '../widgets/dragon_boss.dart';
import '../widgets/summary_card.dart';
import '../services/tts_service.dart';

/// Màn hình học bài với TikTok-style vertical swipe
class LessonScreen extends StatefulWidget {
  final Lesson lesson;

  const LessonScreen({super.key, required this.lesson});

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  late PageController _pageController;
  final TtsService _tts = TtsService();
  int _currentPage = 0;
  int _score = 0;
  int _totalQuestions = 0;
  int _correctAnswers = 0;
  int _bossHealth = 100;
  int _playerHealth = 100;

  // Tính tổng số trang
  int get _totalPages {
    // 5 flashcards + examples + story + 3 games + boss battle + summary
    return widget.lesson.words.length +
        widget.lesson.examples.length +
        1 + // story
        3 + // games
        1 + // boss battle
        1; // summary
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _totalQuestions = widget.lesson.questions.length + 5;

    // Speak first word khi TTS sẵn sàng
    _speakFirstWord();
  }

  Future<void> _speakFirstWord() async {
    // Chỉ speak nếu TTS đã ready
    if (!_tts.isReady) return;

    if (mounted && widget.lesson.words.isNotEmpty) {
      await Future.delayed(const Duration(milliseconds: 300));
      _speak(widget.lesson.words[0].korean);
    }
  }

  Future<void> _speak(String text) async {
    await _tts.speak(text);
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });

    // Auto-speak based on current page content
    _speakCurrentPage(page);
  }

  void _speakCurrentPage(int page) {
    final wordsCount = widget.lesson.words.length;
    final examplesCount = widget.lesson.examples.length;

    if (page < wordsCount) {
      // FlashCard - speak Korean word
      _speak(widget.lesson.words[page].korean);
    } else if (page < wordsCount + examplesCount) {
      // Example - speak Korean sentence
      final exampleIndex = page - wordsCount;
      _speak(widget.lesson.examples[exampleIndex].korean);
    } else if (page == wordsCount + examplesCount) {
      // Story - speak story
      _speak(widget.lesson.story);
    }
  }

  void _onAnswerCorrect() {
    setState(() {
      _score += 10;
      _correctAnswers++;
      _bossHealth = (_bossHealth - 20).clamp(0, 100);
    });
  }

  void _onAnswerWrong() {
    setState(() {
      _playerHealth = (_playerHealth - 15).clamp(0, 100);
    });
  }

  void _goToNextPage() {
    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1a1a2e), Color(0xFF16213e), Color(0xFF0f3460)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Progress bar and close button
              _buildHeader(),

              // Main content - PageView
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  scrollDirection: Axis.vertical,
                  onPageChanged: _onPageChanged,
                  itemCount: _totalPages,
                  itemBuilder: (context, index) {
                    return _buildPage(index);
                  },
                ),
              ),

              // Swipe hint
              _buildSwipeHint(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          // Close button
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.close, color: Colors.white, size: 24),
            ),
          ),
          const SizedBox(width: 16),
          // Progress bar
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.lesson.name,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: (_currentPage + 1) / _totalPages,
                    backgroundColor: Colors.white.withValues(alpha: 0.2),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFF00d9ff),
                    ),
                    minHeight: 8,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Score
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFe94560).withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(Icons.star, color: Color(0xFFffd700), size: 18),
                const SizedBox(width: 4),
                Text(
                  '$_score',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwipeHint() {
    if (_currentPage >= _totalPages - 1) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.swipe_up,
            color: Colors.white.withValues(alpha: 0.5),
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            'Lướt lên để tiếp tục',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.5),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(int index) {
    final wordsCount = widget.lesson.words.length;
    final examplesCount = widget.lesson.examples.length;
    final storyIndex = wordsCount + examplesCount;
    final gamesStartIndex = storyIndex + 1;
    final bossIndex = gamesStartIndex + 3;
    final summaryIndex = bossIndex + 1;

    // FlashCards (pages 0 to wordsCount-1)
    if (index < wordsCount) {
      return FlashCardWidget(
        word: widget.lesson.words[index],
        cardNumber: index + 1,
        totalCards: wordsCount,
        onSpeak: _speak,
      );
    }

    // Examples (pages wordsCount to wordsCount+examplesCount-1)
    if (index < storyIndex) {
      final exampleIndex = index - wordsCount;
      return ExampleCard(
        example: widget.lesson.examples[exampleIndex],
        cardNumber: exampleIndex + 1,
        totalCards: examplesCount,
        onSpeak: _speak,
      );
    }

    // Story (page storyIndex)
    if (index == storyIndex) {
      return StoryCard(
        story: widget.lesson.story,
        translation: widget.lesson.storyTranslation,
        words: widget.lesson.words,
        onSpeak: _speak,
      );
    }

    // Games (pages gamesStartIndex to gamesStartIndex+2)
    if (index == gamesStartIndex) {
      // Multiple Choice Game
      final mcQuestions = widget.lesson.questions
          .where((q) => q.type == QuestionType.multipleChoice)
          .toList();
      if (mcQuestions.isEmpty) {
        return _buildEmptyGamePlaceholder('Multiple Choice');
      }
      return MultipleChoiceGame(
        questions: mcQuestions,
        onCorrect: _onAnswerCorrect,
        onWrong: _onAnswerWrong,
        onComplete: _goToNextPage,
      );
    }

    if (index == gamesStartIndex + 1) {
      // Matching Game
      return MatchingGame(
        words: widget.lesson.words,
        onCorrect: _onAnswerCorrect,
        onWrong: _onAnswerWrong,
        onComplete: _goToNextPage,
      );
    }

    if (index == gamesStartIndex + 2) {
      // Fill Blank Game
      final fillQuestions = widget.lesson.questions
          .where((q) => q.type == QuestionType.fillBlank)
          .toList();
      if (fillQuestions.isEmpty) {
        return _buildEmptyGamePlaceholder('Fill in Blank');
      }
      return FillBlankGame(
        questions: fillQuestions,
        onCorrect: _onAnswerCorrect,
        onWrong: _onAnswerWrong,
        onComplete: _goToNextPage,
      );
    }

    // Boss Battle (page bossIndex)
    if (index == bossIndex) {
      return DragonBoss(
        words: widget.lesson.words,
        bossHealth: _bossHealth,
        playerHealth: _playerHealth,
        onCorrect: _onAnswerCorrect,
        onWrong: _onAnswerWrong,
        onComplete: _goToNextPage,
        onSpeak: _speak,
      );
    }

    // Summary (page summaryIndex)
    if (index == summaryIndex) {
      return SummaryCard(
        score: _score,
        correctAnswers: _correctAnswers,
        totalQuestions: _totalQuestions,
        wordsLearned: widget.lesson.words.length,
        bossDefeated: _bossHealth <= 0,
        onFinish: () => Navigator.pop(context),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildEmptyGamePlaceholder(String gameName) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.games, color: Colors.white54, size: 64),
            const SizedBox(height: 16),
            Text(
              '$gameName sẽ có trong phiên bản tiếp theo!',
              style: const TextStyle(color: Colors.white54, fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _goToNextPage,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00d9ff),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
              child: const Text('Tiếp tục'),
            ),
          ],
        ),
      ),
    );
  }
}
