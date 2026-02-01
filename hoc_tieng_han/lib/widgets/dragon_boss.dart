import 'dart:math';
import 'package:flutter/material.dart';
import '../models/word.dart';

/// Widget Boss Battle - chiến đấu với rồng bằng câu hỏi ôn tập
class DragonBoss extends StatefulWidget {
  final List<Word> words;
  final int bossHealth;
  final int playerHealth;
  final VoidCallback onCorrect;
  final VoidCallback onWrong;
  final VoidCallback onComplete;
  final Function(String) onSpeak;

  const DragonBoss({
    super.key,
    required this.words,
    required this.bossHealth,
    required this.playerHealth,
    required this.onCorrect,
    required this.onWrong,
    required this.onComplete,
    required this.onSpeak,
  });

  @override
  State<DragonBoss> createState() => _DragonBossState();
}

class _DragonBossState extends State<DragonBoss> with TickerProviderStateMixin {
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;
  late AnimationController _attackController;

  int _currentQuestion = 0;
  final int _totalQuestions = 5;
  Word? _currentWord;
  List<String> _options = [];
  bool _showResult = false;
  bool? _isCorrect;
  String? _selectedAnswer;
  int _bossHP = 100;
  int _playerHP = 100;
  bool _gameOver = false;
  bool _victory = false;

  @override
  void initState() {
    super.initState();
    _bossHP = widget.bossHealth;
    _playerHP = widget.playerHealth;

    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _shakeAnimation = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn),
    );

    _attackController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _generateQuestion();
  }

  @override
  void dispose() {
    _shakeController.dispose();
    _attackController.dispose();
    super.dispose();
  }

  void _generateQuestion() {
    if (_currentQuestion >= _totalQuestions || _bossHP <= 0 || _playerHP <= 0) {
      setState(() {
        _gameOver = true;
        _victory = _bossHP <= 0;
      });
      return;
    }

    final random = Random();
    _currentWord = widget.words[random.nextInt(widget.words.length)];

    // Generate options
    _options = [_currentWord!.vietnamese];
    final otherWords = widget.words.where((w) => w != _currentWord).toList()
      ..shuffle();
    for (int i = 0; i < 3 && i < otherWords.length; i++) {
      _options.add(otherWords[i].vietnamese);
    }
    _options.shuffle();

    // Speak the Korean word
    widget.onSpeak(_currentWord!.korean);
  }

  void _checkAnswer(String answer) {
    if (_showResult || _gameOver) return;

    setState(() {
      _selectedAnswer = answer;
      _isCorrect = answer == _currentWord!.vietnamese;
      _showResult = true;
    });

    if (_isCorrect!) {
      widget.onCorrect();
      _shakeController.forward().then((_) => _shakeController.reset());
      setState(() {
        _bossHP = (_bossHP - 25).clamp(0, 100);
      });
    } else {
      widget.onWrong();
      _attackController.forward().then((_) => _attackController.reset());
      setState(() {
        _playerHP = (_playerHP - 20).clamp(0, 100);
      });
    }

    // Next question
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _currentQuestion++;
          _showResult = false;
          _selectedAnswer = null;
          _isCorrect = null;
        });
        _generateQuestion();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFe74c3c), Color(0xFFc0392b)],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('🐉', style: TextStyle(fontSize: 20)),
                const SizedBox(width: 8),
                Text(
                  _gameOver
                      ? (_victory ? 'Chiến thắng!' : 'Thất bại!')
                      : 'Boss Battle',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          if (!_gameOver) ...[
            // Boss section
            Expanded(
              flex: 2,
              child: AnimatedBuilder(
                animation: _shakeAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(
                      _shakeAnimation.value * sin(_shakeController.value * 10),
                      0,
                    ),
                    child: child,
                  );
                },
                child: _buildBossSection(),
              ),
            ),

            // Question section
            Expanded(flex: 3, child: _buildQuestionSection()),

            // Player section
            _buildPlayerSection(),
          ] else ...[
            // Game over screen
            Expanded(child: _buildGameOverSection()),
          ],
        ],
      ),
    );
  }

  Widget _buildBossSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFFe74c3c).withValues(alpha: 0.3),
            Colors.transparent,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Boss name and HP
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '용왕 (Dragon King)',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Boss HP bar
          Container(
            height: 12,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(6),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: _bossHP / 100,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          _bossHP > 50
                              ? const Color(0xFF2ecc71)
                              : (_bossHP > 25
                                    ? const Color(0xFFf39c12)
                                    : const Color(0xFFe74c3c)),
                          _bossHP > 50
                              ? const Color(0xFF27ae60)
                              : (_bossHP > 25
                                    ? const Color(0xFFe67e22)
                                    : const Color(0xFFc0392b)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Text(
            '$_bossHP/100 HP',
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),

          const SizedBox(height: 16),

          // Dragon emoji (animated when hit)
          Text(
            '🐲',
            style: TextStyle(
              fontSize: 80,
              shadows: [
                Shadow(
                  color: const Color(0xFFe74c3c).withValues(alpha: 0.5),
                  blurRadius: 30,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionSection() {
    if (_currentWord == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Question
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
            ),
            child: Column(
              children: [
                Text(
                  _currentWord!.korean,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _currentWord!.romanization,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Options
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 2.5,
              physics: const NeverScrollableScrollPhysics(),
              children: _options.map((option) {
                final isSelected = option == _selectedAnswer;
                final isCorrectAnswer = option == _currentWord!.vietnamese;

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
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: borderColor, width: 2),
                    ),
                    child: Center(
                      child: Text(
                        option,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
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
        ],
      ),
    );
  }

  Widget _buildPlayerSection() {
    return AnimatedBuilder(
      animation: _attackController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, -_attackController.value * 20),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  const Color(0xFF3498db).withValues(alpha: 0.3),
                  Colors.transparent,
                ],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Text('🧙', style: TextStyle(fontSize: 40)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Bạn',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        height: 10,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            alignment: Alignment.centerLeft,
                            child: FractionallySizedBox(
                              widthFactor: _playerHP / 100,
                              child: Container(
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xFF3498db),
                                      Color(0xFF2980b9),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Text(
                        '$_playerHP/100 HP',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Câu ${_currentQuestion + 1}/$_totalQuestions',
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildGameOverSection() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(_victory ? '🎉' : '💀', style: const TextStyle(fontSize: 100)),
          const SizedBox(height: 24),
          Text(
            _victory
                ? 'Bạn đã đánh bại Dragon King!'
                : 'Dragon King đã chiến thắng!',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            _victory
                ? 'Xuất sắc! Bạn đã làm chủ các từ vựng!'
                : 'Đừng nản! Hãy ôn tập và thử lại!',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          GestureDetector(
            onTap: widget.onComplete,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: _victory
                      ? [const Color(0xFF2ecc71), const Color(0xFF27ae60)]
                      : [const Color(0xFFe74c3c), const Color(0xFFc0392b)],
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Text(
                'Tiếp tục',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
