import 'package:flutter/material.dart';

/// Widget tổng kết sau khi hoàn thành bài học
class SummaryCard extends StatelessWidget {
  final int score;
  final int correctAnswers;
  final int totalQuestions;
  final int wordsLearned;
  final bool bossDefeated;
  final VoidCallback onFinish;

  const SummaryCard({
    super.key,
    required this.score,
    required this.correctAnswers,
    required this.totalQuestions,
    required this.wordsLearned,
    required this.bossDefeated,
    required this.onFinish,
  });

  @override
  Widget build(BuildContext context) {
    final accuracy = totalQuestions > 0
        ? (correctAnswers / totalQuestions * 100).toInt()
        : 0;

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Trophy/Result icon
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: bossDefeated
                    ? [const Color(0xFFffd700), const Color(0xFFf39c12)]
                    : [const Color(0xFF9b59b6), const Color(0xFF8e44ad)],
              ),
              boxShadow: [
                BoxShadow(
                  color:
                      (bossDefeated
                              ? const Color(0xFFffd700)
                              : const Color(0xFF9b59b6))
                          .withValues(alpha: 0.4),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Text(
              bossDefeated ? '🏆' : '📚',
              style: const TextStyle(fontSize: 64),
            ),
          ),

          const SizedBox(height: 32),

          // Title
          Text(
            bossDefeated ? 'Hoàn thành xuất sắc!' : 'Bài học hoàn thành!',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            bossDefeated
                ? 'Bạn đã đánh bại Dragon King!'
                : 'Tiếp tục luyện tập để tiến bộ hơn!',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 16,
            ),
          ),

          const SizedBox(height: 40),

          // Stats
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
            ),
            child: Column(
              children: [
                _buildStatRow(
                  Icons.star,
                  'Điểm số',
                  '$score',
                  const Color(0xFFffd700),
                ),
                const SizedBox(height: 16),
                _buildStatRow(
                  Icons.check_circle,
                  'Câu đúng',
                  '$correctAnswers/$totalQuestions',
                  const Color(0xFF2ecc71),
                ),
                const SizedBox(height: 16),
                _buildStatRow(
                  Icons.percent,
                  'Độ chính xác',
                  '$accuracy%',
                  const Color(0xFF3498db),
                ),
                const SizedBox(height: 16),
                _buildStatRow(
                  Icons.menu_book,
                  'Từ đã học',
                  '$wordsLearned từ',
                  const Color(0xFFe94560),
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),

          // Finish button
          GestureDetector(
            onTap: onFinish,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF00d9ff), Color(0xFF00b4cc)],
                ),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00d9ff).withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.home, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'Quay về trang chủ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Share/Retry buttons
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.share,
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Chia sẻ',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.replay,
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Học lại',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(IconData icon, String label, String value, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 16,
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
