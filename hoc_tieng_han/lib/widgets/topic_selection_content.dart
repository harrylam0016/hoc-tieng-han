import 'package:flutter/material.dart';
import '../data/sample_data.dart';
import '../models/topic.dart';

/// Gradient colors cho mỗi topic card
const _topicGradients = [
  [Color(0xFF1B1B2F), Color(0xFF162447)],
  [Color(0xFF2D132C), Color(0xFF801336)],
  [Color(0xFF0B3D4A), Color(0xFF1A5276)],
  [Color(0xFF1A1A2E), Color(0xFF16213E)],
  [Color(0xFF2C3E50), Color(0xFF4A6274)],
  [Color(0xFF1F1C2C), Color(0xFF928DAB)],
  [Color(0xFF0F2027), Color(0xFF203A43)],
  [Color(0xFF232526), Color(0xFF414345)],
  [Color(0xFF2B1055), Color(0xFF7597DE)],
];

/// Widget hiển thị danh sách chủ đề dạng creative grid (TikTok style)
class TopicSelectionContent extends StatelessWidget {
  final void Function(Topic topic) onTopicSelected;

  const TopicSelectionContent({super.key, required this.onTopicSelected});

  @override
  Widget build(BuildContext context) {
    final topics = sampleTopics;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1a1a2e), Color(0xFF0f0f1a)],
        ),
      ),
      child: CustomScrollView(
        slivers: [
          // Top padding for header (menu bar only, no close button)
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
          // Build creative grid rows
          ..._buildGridRows(topics),
          // Bottom padding
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }

  List<Widget> _buildGridRows(List<Topic> topics) {
    final List<Widget> rows = [];
    int i = 0;
    int patternIndex = 0;

    while (i < topics.length) {
      final remaining = topics.length - i;
      final pattern = patternIndex % 3;

      switch (pattern) {
        case 0:
          // Row pattern A: 3 equal cards
          if (remaining >= 3) {
            rows.add(
              SliverToBoxAdapter(
                child: _buildRowThreeEqual(
                  topics[i],
                  topics[i + 1],
                  topics[i + 2],
                  i,
                ),
              ),
            );
            i += 3;
          } else if (remaining == 2) {
            rows.add(
              SliverToBoxAdapter(
                child: _buildRowTwoEqual(topics[i], topics[i + 1], i),
              ),
            );
            i += 2;
          } else {
            rows.add(
              SliverToBoxAdapter(child: _buildRowFeatured(topics[i], i)),
            );
            i += 1;
          }
          break;

        case 1:
          // Row pattern B: 1 large + 1 small
          if (remaining >= 2) {
            rows.add(
              SliverToBoxAdapter(
                child: _buildRowLargeSmall(topics[i], topics[i + 1], i),
              ),
            );
            i += 2;
          } else {
            rows.add(
              SliverToBoxAdapter(child: _buildRowFeatured(topics[i], i)),
            );
            i += 1;
          }
          break;

        case 2:
          // Row pattern C: 1 full-width featured card
          rows.add(SliverToBoxAdapter(child: _buildRowFeatured(topics[i], i)));
          i += 1;
          break;
      }
      patternIndex++;
    }

    return rows;
  }

  // === Row Pattern A: 3 equal cards ===
  Widget _buildRowThreeEqual(Topic t1, Topic t2, Topic t3, int startIndex) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      child: Row(
        children: [
          Expanded(child: _buildCard(t1, startIndex, height: 200)),
          const SizedBox(width: 4),
          Expanded(child: _buildCard(t2, startIndex + 1, height: 200)),
          const SizedBox(width: 4),
          Expanded(child: _buildCard(t3, startIndex + 2, height: 200)),
        ],
      ),
    );
  }

  // === Row Pattern: 2 equal cards ===
  Widget _buildRowTwoEqual(Topic t1, Topic t2, int startIndex) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      child: Row(
        children: [
          Expanded(child: _buildCard(t1, startIndex, height: 220)),
          const SizedBox(width: 4),
          Expanded(child: _buildCard(t2, startIndex + 1, height: 220)),
        ],
      ),
    );
  }

  // === Row Pattern B: 1 large (2/3) + 1 small (1/3) ===
  Widget _buildRowLargeSmall(Topic large, Topic small, int startIndex) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      child: SizedBox(
        height: 260,
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: _buildCard(large, startIndex, height: 260),
            ),
            const SizedBox(width: 4),
            Expanded(
              flex: 1,
              child: _buildCard(
                small,
                startIndex + 1,
                height: 260,
                showBadge: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // === Row Pattern C: Full-width featured card ===
  Widget _buildRowFeatured(Topic topic, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      child: _buildCard(topic, index, height: 240, isFeatured: true),
    );
  }

  // === Individual Card ===
  Widget _buildCard(
    Topic topic,
    int index, {
    required double height,
    bool isFeatured = false,
    bool showBadge = false,
  }) {
    final gradientColors = _topicGradients[index % _topicGradients.length];
    final lessonCount = topic.lessons.length;
    final totalWords = topic.lessons.fold<int>(
      0,
      (sum, l) => sum + l.words.length,
    );

    return GestureDetector(
      onTap: () => onTopicSelected(topic),
      child: Container(
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [gradientColors[0], gradientColors[1]],
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Image background
              Positioned.fill(
                child: Image.asset(
                  topic.imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.white.withValues(alpha: 0.1),
                    );
                  },
                ),
              ),

              // Dark gradient overlay at bottom
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.7),
                      ],
                      stops: const [0.25, 1.0],
                    ),
                  ),
                ),
              ),

              // Badge (HOT)
              if (showBadge)
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF6B35),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'HOT',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),

              // Content: name + lesson count
              Positioned(
                left: 12,
                right: 12,
                bottom: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isFeatured) ...[
                      Text(
                        topic.koreanName,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.6),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                    ],
                    Text(
                      topic.name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isFeatured ? 22 : 15,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.menu_book_rounded,
                          color: Colors.white.withValues(alpha: 0.6),
                          size: isFeatured ? 15 : 12,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '$lessonCount bài học',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.6),
                            fontSize: isFeatured ? 13 : 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (isFeatured) ...[
                          const SizedBox(width: 8),
                          Container(
                            width: 3,
                            height: 3,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.4),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '$totalWords từ vựng',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.5),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
