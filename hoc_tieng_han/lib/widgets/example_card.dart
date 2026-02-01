import 'package:flutter/material.dart';
import '../models/word.dart';

/// Widget hiển thị câu ví dụ
class ExampleCard extends StatelessWidget {
  final Example example;
  final int cardNumber;
  final int totalCards;
  final Function(String) onSpeak;

  const ExampleCard({
    super.key,
    required this.example,
    required this.cardNumber,
    required this.totalCards,
    required this.onSpeak,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Card number indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFffd700).withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.format_quote,
                  color: Color(0xFFffd700),
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  'Ví dụ $cardNumber/$totalCards',
                  style: const TextStyle(
                    color: Color(0xFFffd700),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Main card
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
                borderRadius: BorderRadius.circular(32),
                border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Korean sentence with highlighted word
                  _buildHighlightedText(
                    example.korean,
                    example.highlightWord,
                    const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      height: 1.5,
                    ),
                    const TextStyle(
                      color: Color(0xFF00d9ff),
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Divider
                  Container(
                    width: 60,
                    height: 3,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Vietnamese translation
                  Text(
                    example.vietnamese,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 20,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 40),

                  // Speak button
                  GestureDetector(
                    onTap: () => onSpeak(example.korean),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF00d9ff), Color(0xFF00b4cc)],
                        ),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFF00d9ff,
                            ).withValues(alpha: 0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.volume_up, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            'Nghe phát âm',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHighlightedText(
    String text,
    String highlight,
    TextStyle normalStyle,
    TextStyle highlightStyle,
  ) {
    final parts = text.split(highlight);
    if (parts.length == 1) {
      return Text(text, style: normalStyle, textAlign: TextAlign.center);
    }

    List<TextSpan> spans = [];
    for (int i = 0; i < parts.length; i++) {
      if (parts[i].isNotEmpty) {
        spans.add(TextSpan(text: parts[i], style: normalStyle));
      }
      if (i < parts.length - 1) {
        spans.add(TextSpan(text: highlight, style: highlightStyle));
      }
    }

    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(children: spans),
    );
  }
}
