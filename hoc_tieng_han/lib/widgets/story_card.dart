import 'package:flutter/material.dart';
import '../models/word.dart';

/// Widget hiển thị truyện chêm
class StoryCard extends StatelessWidget {
  final String story;
  final String translation;
  final List<Word> words;
  final Function(String) onSpeak;

  const StoryCard({
    super.key,
    required this.story,
    required this.translation,
    required this.words,
    required this.onSpeak,
  });

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
                colors: [Color(0xFFe94560), Color(0xFFff6b6b)],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.auto_stories, color: Colors.white, size: 18),
                SizedBox(width: 8),
                Text(
                  'Truyện chêm',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Story content
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
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
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Korean story
                    _buildStoryText(story, words),

                    const SizedBox(height: 24),

                    // Speak button
                    GestureDetector(
                      onTap: () => onSpeak(story),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF00d9ff).withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(color: const Color(0xFF00d9ff)),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.play_circle, color: Color(0xFF00d9ff)),
                            SizedBox(width: 8),
                            Text(
                              'Nghe đọc truyện',
                              style: TextStyle(
                                color: Color(0xFF00d9ff),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Divider
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 1,
                            color: Colors.white.withValues(alpha: 0.2),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            '번역 • Dịch',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.5),
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 1,
                            color: Colors.white.withValues(alpha: 0.2),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Vietnamese translation
                    Text(
                      translation,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 16,
                        height: 1.8,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoryText(String text, List<Word> wordsToHighlight) {
    // Highlight learned words in the story
    List<TextSpan> spans = [];

    // Split by lines first
    final lines = text.split('\n');

    for (int i = 0; i < lines.length; i++) {
      String line = lines[i];
      List<TextSpan> lineSpans = [];

      // Find and highlight words
      String remaining = line;
      while (remaining.isNotEmpty) {
        int earliestIndex = remaining.length;
        Word? foundWord;

        for (final word in wordsToHighlight) {
          final index = remaining.indexOf(word.korean);
          if (index != -1 && index < earliestIndex) {
            earliestIndex = index;
            foundWord = word;
          }
        }

        if (foundWord != null && earliestIndex < remaining.length) {
          // Add text before the word
          if (earliestIndex > 0) {
            lineSpans.add(
              TextSpan(
                text: remaining.substring(0, earliestIndex),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  height: 1.8,
                ),
              ),
            );
          }

          // Add highlighted word
          lineSpans.add(
            TextSpan(
              text: foundWord.korean,
              style: const TextStyle(
                color: Color(0xFF00d9ff),
                fontSize: 18,
                fontWeight: FontWeight.bold,
                height: 1.8,
              ),
            ),
          );

          remaining = remaining.substring(
            earliestIndex + foundWord.korean.length,
          );
        } else {
          // No more words to highlight
          lineSpans.add(
            TextSpan(
              text: remaining,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                height: 1.8,
              ),
            ),
          );
          break;
        }
      }

      spans.addAll(lineSpans);
      if (i < lines.length - 1) {
        spans.add(const TextSpan(text: '\n'));
      }
    }

    return RichText(text: TextSpan(children: spans));
  }
}
