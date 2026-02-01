import 'package:flutter/material.dart';
import '../../models/question.dart';

/// Game Multiple Choice - chọn đáp án đúng
class MultipleChoiceGame extends StatefulWidget {
  final List<Question> questions;
  final VoidCallback onCorrect;
  final VoidCallback onWrong;
  final VoidCallback onComplete;

  const MultipleChoiceGame({
    super.key,
    required this.questions,
    required this.onCorrect,
    required this.onWrong,
    required this.onComplete,
  });

  @override
  State<MultipleChoiceGame> createState() => _MultipleChoiceGameState();
}

class _MultipleChoiceGameState extends State<MultipleChoiceGame> {
  int _currentQuestion = 0;
  String? _selectedAnswer;
  bool? _isCorrect;
  bool _showResult = false;

  void _checkAnswer(String answer) {
    if (_showResult) return;

    setState(() {
      _selectedAnswer = answer;
      _isCorrect = answer == widget.questions[_currentQuestion].correctAnswer;
      _showResult = true;
    });

    if (_isCorrect!) {
      widget.onCorrect();
    } else {
      widget.onWrong();
    }

    // Auto advance after delay
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        if (_currentQuestion < widget.questions.length - 1) {
          setState(() {
            _currentQuestion++;
            _selectedAnswer = null;
            _isCorrect = null;
            _showResult = false;
          });
        } else {
          widget.onComplete();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final question = widget.questions[_currentQuestion];

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF9b59b6).withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.quiz, color: Color(0xFF9b59b6), size: 18),
                const SizedBox(width: 8),
                Text(
                  'Câu ${_currentQuestion + 1}/${widget.questions.length}',
                  style: const TextStyle(
                    color: Color(0xFF9b59b6),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Question card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF9b59b6).withValues(alpha: 0.3),
                  const Color(0xFF8e44ad).withValues(alpha: 0.2),
                ],
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: const Color(0xFF9b59b6).withValues(alpha: 0.5),
              ),
            ),
            child: Column(
              children: [
                const Text(
                  'Từ này có nghĩa là gì?',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                const SizedBox(height: 16),
                Text(
                  question.question,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Options
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 2,
              children: question.options.map((option) {
                final isSelected = option == _selectedAnswer;
                final isCorrectAnswer = option == question.correctAnswer;

                Color bgColor = Colors.white.withValues(alpha: 0.1);
                Color borderColor = Colors.white.withValues(alpha: 0.3);

                if (_showResult) {
                  if (isCorrectAnswer) {
                    bgColor = const Color(0xFF2ecc71).withValues(alpha: 0.3);
                    borderColor = const Color(0xFF2ecc71);
                  } else if (isSelected && !_isCorrect!) {
                    bgColor = const Color(0xFFe74c3c).withValues(alpha: 0.3);
                    borderColor = const Color(0xFFe74c3c);
                  }
                }

                return GestureDetector(
                  onTap: () => _checkAnswer(option),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: borderColor, width: 2),
                    ),
                    child: Center(
                      child: Text(
                        option,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // Result message
          if (_showResult)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _isCorrect!
                    ? const Color(0xFF2ecc71).withValues(alpha: 0.2)
                    : const Color(0xFFe74c3c).withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _isCorrect! ? Icons.check_circle : Icons.cancel,
                    color: _isCorrect!
                        ? const Color(0xFF2ecc71)
                        : const Color(0xFFe74c3c),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _isCorrect!
                        ? 'Chính xác! +10 điểm'
                        : 'Sai rồi! Đáp án: ${question.correctAnswer}',
                    style: TextStyle(
                      color: _isCorrect!
                          ? const Color(0xFF2ecc71)
                          : const Color(0xFFe74c3c),
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
}
