import 'package:flutter/material.dart';
import '../../models/question.dart';

/// Game điền từ vào chỗ trống
class FillBlankGame extends StatefulWidget {
  final List<Question> questions;
  final VoidCallback onCorrect;
  final VoidCallback onWrong;
  final VoidCallback onComplete;

  const FillBlankGame({
    super.key,
    required this.questions,
    required this.onCorrect,
    required this.onWrong,
    required this.onComplete,
  });

  @override
  State<FillBlankGame> createState() => _FillBlankGameState();
}

class _FillBlankGameState extends State<FillBlankGame> {
  int _currentQuestion = 0;
  final TextEditingController _controller = TextEditingController();
  bool? _isCorrect;
  bool _showResult = false;
  bool _showHint = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _checkAnswer() {
    if (_showResult) return;

    final answer = _controller.text.trim();
    final correct = widget.questions[_currentQuestion].correctAnswer;

    setState(() {
      _isCorrect = answer == correct;
      _showResult = true;
    });

    if (_isCorrect!) {
      widget.onCorrect();
    } else {
      widget.onWrong();
    }

    // Auto advance
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (mounted) {
        if (_currentQuestion < widget.questions.length - 1) {
          setState(() {
            _currentQuestion++;
            _controller.clear();
            _isCorrect = null;
            _showResult = false;
            _showHint = false;
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
              color: const Color(0xFFe67e22).withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.edit, color: Color(0xFFe67e22), size: 18),
                const SizedBox(width: 8),
                Text(
                  'Điền từ ${_currentQuestion + 1}/${widget.questions.length}',
                  style: const TextStyle(
                    color: Color(0xFFe67e22),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Question card
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withValues(alpha: 0.15),
                    Colors.white.withValues(alpha: 0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Điền từ tiếng Hàn phù hợp',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),

                  const SizedBox(height: 24),

                  // Question text
                  Text(
                    question.question,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 32),

                  // Text input
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: _showResult
                            ? (_isCorrect!
                                  ? const Color(0xFF2ecc71)
                                  : const Color(0xFFe74c3c))
                            : const Color(0xFFe67e22),
                        width: 2,
                      ),
                    ),
                    child: TextField(
                      controller: _controller,
                      enabled: !_showResult,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Nhập từ tiếng Hàn...',
                        hintStyle: TextStyle(
                          color: Colors.white.withValues(alpha: 0.3),
                          fontSize: 18,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(20),
                      ),
                      onSubmitted: (_) => _checkAnswer(),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Hint button
                  if (!_showResult && question.hint != null)
                    GestureDetector(
                      onTap: () => setState(() => _showHint = !_showHint),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _showHint
                                  ? Icons.lightbulb
                                  : Icons.lightbulb_outline,
                              color: const Color(0xFFffd700),
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _showHint ? question.hint! : 'Xem gợi ý',
                              style: TextStyle(
                                color: _showHint
                                    ? const Color(0xFFffd700)
                                    : Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  if (!_showResult) ...[
                    const SizedBox(height: 24),

                    // Submit button
                    GestureDetector(
                      onTap: _checkAnswer,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFe67e22), Color(0xFFf39c12)],
                          ),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(
                                0xFFe67e22,
                              ).withValues(alpha: 0.3),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: const Text(
                          'Kiểm tra',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],

                  // Result
                  if (_showResult) ...[
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: _isCorrect!
                            ? const Color(0xFF2ecc71).withValues(alpha: 0.2)
                            : const Color(0xFFe74c3c).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Row(
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
                                _isCorrect! ? 'Chính xác!' : 'Sai rồi!',
                                style: TextStyle(
                                  color: _isCorrect!
                                      ? const Color(0xFF2ecc71)
                                      : const Color(0xFFe74c3c),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                          if (!_isCorrect!) ...[
                            const SizedBox(height: 8),
                            Text(
                              'Đáp án: ${question.correctAnswer}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
