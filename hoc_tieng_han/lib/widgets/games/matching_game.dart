import 'package:flutter/material.dart';
import '../../models/word.dart';

/// Game nối từ - Matching
class MatchingGame extends StatefulWidget {
  final List<Word> words;
  final VoidCallback onCorrect;
  final VoidCallback onWrong;
  final VoidCallback onComplete;

  const MatchingGame({
    super.key,
    required this.words,
    required this.onCorrect,
    required this.onWrong,
    required this.onComplete,
  });

  @override
  State<MatchingGame> createState() => _MatchingGameState();
}

class _MatchingGameState extends State<MatchingGame> {
  late List<Word> _shuffledKorean;
  late List<Word> _shuffledVietnamese;
  String? _selectedKorean;
  final Set<String> _matchedKorean = {};
  final Set<String> _matchedVietnamese = {};
  bool _showWrong = false;
  String? _wrongKorean;
  String? _wrongVietnamese;

  @override
  void initState() {
    super.initState();
    _shuffledKorean = List.from(widget.words)..shuffle();
    _shuffledVietnamese = List.from(widget.words)..shuffle();
  }

  void _onKoreanTap(Word word) {
    if (_matchedKorean.contains(word.korean)) return;

    setState(() {
      _selectedKorean = word.korean;
      _showWrong = false;
    });
  }

  void _onVietnameseTap(Word word) {
    if (_matchedVietnamese.contains(word.vietnamese)) return;
    if (_selectedKorean == null) return;

    // Find the word that matches the selected Korean
    final selectedWord = widget.words.firstWhere(
      (w) => w.korean == _selectedKorean,
    );

    if (selectedWord.vietnamese == word.vietnamese) {
      // Correct match
      setState(() {
        _matchedKorean.add(_selectedKorean!);
        _matchedVietnamese.add(word.vietnamese);
        _selectedKorean = null;
      });
      widget.onCorrect();

      // Check if game complete
      if (_matchedKorean.length == widget.words.length) {
        Future.delayed(const Duration(milliseconds: 500), () {
          widget.onComplete();
        });
      }
    } else {
      // Wrong match
      setState(() {
        _showWrong = true;
        _wrongKorean = _selectedKorean;
        _wrongVietnamese = word.vietnamese;
      });
      widget.onWrong();

      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) {
          setState(() {
            _showWrong = false;
            _wrongKorean = null;
            _wrongVietnamese = null;
            _selectedKorean = null;
          });
        }
      });
    }
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
              color: const Color(0xFF3498db).withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.compare_arrows, color: Color(0xFF3498db), size: 18),
                SizedBox(width: 8),
                Text(
                  'Nối từ',
                  style: TextStyle(
                    color: Color(0xFF3498db),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Progress
          Text(
            'Đã nối: ${_matchedKorean.length}/${widget.words.length}',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 14,
            ),
          ),

          const SizedBox(height: 24),

          // Matching columns
          Expanded(
            child: Row(
              children: [
                // Korean column
                Expanded(
                  child: ListView.builder(
                    itemCount: _shuffledKorean.length,
                    itemBuilder: (context, index) {
                      final word = _shuffledKorean[index];
                      final isMatched = _matchedKorean.contains(word.korean);
                      final isSelected = _selectedKorean == word.korean;
                      final isWrong = _showWrong && _wrongKorean == word.korean;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: GestureDetector(
                          onTap: () => _onKoreanTap(word),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isMatched
                                  ? const Color(
                                      0xFF2ecc71,
                                    ).withValues(alpha: 0.3)
                                  : isWrong
                                  ? const Color(
                                      0xFFe74c3c,
                                    ).withValues(alpha: 0.3)
                                  : isSelected
                                  ? const Color(
                                      0xFF3498db,
                                    ).withValues(alpha: 0.3)
                                  : Colors.white.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isMatched
                                    ? const Color(0xFF2ecc71)
                                    : isWrong
                                    ? const Color(0xFFe74c3c)
                                    : isSelected
                                    ? const Color(0xFF3498db)
                                    : Colors.white.withValues(alpha: 0.3),
                                width: 2,
                              ),
                            ),
                            child: Text(
                              word.korean,
                              style: TextStyle(
                                color: isMatched
                                    ? Colors.white54
                                    : Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                decoration: isMatched
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Center divider
                SizedBox(
                  width: 40,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.sync_alt,
                        color: Colors.white.withValues(alpha: 0.3),
                        size: 32,
                      ),
                    ],
                  ),
                ),

                // Vietnamese column
                Expanded(
                  child: ListView.builder(
                    itemCount: _shuffledVietnamese.length,
                    itemBuilder: (context, index) {
                      final word = _shuffledVietnamese[index];
                      final isMatched = _matchedVietnamese.contains(
                        word.vietnamese,
                      );
                      final isWrong =
                          _showWrong && _wrongVietnamese == word.vietnamese;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: GestureDetector(
                          onTap: () => _onVietnameseTap(word),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isMatched
                                  ? const Color(
                                      0xFF2ecc71,
                                    ).withValues(alpha: 0.3)
                                  : isWrong
                                  ? const Color(
                                      0xFFe74c3c,
                                    ).withValues(alpha: 0.3)
                                  : Colors.white.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isMatched
                                    ? const Color(0xFF2ecc71)
                                    : isWrong
                                    ? const Color(0xFFe74c3c)
                                    : Colors.white.withValues(alpha: 0.3),
                                width: 2,
                              ),
                            ),
                            child: Text(
                              word.vietnamese,
                              style: TextStyle(
                                color: isMatched
                                    ? Colors.white54
                                    : Colors.white,
                                fontSize: 16,
                                decoration: isMatched
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Instructions
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'Chọn từ tiếng Hàn, sau đó chọn nghĩa tiếng Việt tương ứng',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
