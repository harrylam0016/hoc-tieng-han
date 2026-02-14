import 'package:flutter/material.dart';
import '../models/topic.dart';

const _kCardSize = 90.0;
const _kRowSpacing = 200.0;
const _kHalfCard = _kCardSize / 2;

// ---- Palette based on reference image ----
const _kBgColor = Color(0xFFF5E7CD); // Warm beige background
const _kActiveColor = Color(0xFFC8553D); // Burnt orange for current topic
const _kLockedColor = Color(0xFF7D9B76); // Sage green for locked/others
const _kTextColor = Color(0xFF4A3B32); // Dark brown text
const _kIconColor = Color(0xFFF3EFE0); // Cream icon color

/// Lesson path: Funnel/Bone shaped connections
class LessonPathContent extends StatefulWidget {
  final Topic topic;
  final int currentLessonIndex;
  final void Function(Lesson lesson) onLessonSelected;
  final VoidCallback? onSwipeUpToLesson;

  const LessonPathContent({
    super.key,
    required this.topic,
    required this.currentLessonIndex,
    required this.onLessonSelected,
    this.onSwipeUpToLesson,
  });

  @override
  State<LessonPathContent> createState() => _LessonPathContentState();
}

class _LessonPathContentState extends State<LessonPathContent>
    with TickerProviderStateMixin {
  late AnimationController _hintController;
  late Animation<double> _hintAnimation;

  @override
  void initState() {
    super.initState();
    _hintController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _hintAnimation = Tween<double>(begin: 0, end: -8).animate(
      CurvedAnimation(parent: _hintController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _hintController.dispose();
    super.dispose();
  }

  List<Offset> _calcNodes(double w) {
    // 2-column layout
    final leftX = w * 0.22;
    final rightX = w * 0.78;
    const startY = 80.0;

    final positions = <Offset>[];
    for (int i = 0; i < widget.topic.lessons.length; i++) {
      final row = i ~/ 2;
      final col = i % 2;
      // Even rows: Left -> Right
      // Odd rows: Right -> Left
      final isRowReverse = row % 2 != 0;

      double x;
      if (!isRowReverse) {
        x = (col == 0) ? leftX : rightX;
      } else {
        x = (col == 0) ? rightX : leftX;
      }

      positions.add(Offset(x, startY + row * _kRowSpacing));
    }
    return positions;
  }

  Offset _examPos(double w, int rows) =>
      Offset(w * 0.22, 80.0 + rows * _kRowSpacing);
  Offset _reviewPos(double w, int rows) =>
      Offset(w * 0.78, 80.0 + rows * _kRowSpacing);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragEnd: (details) {
        if (details.primaryVelocity != null &&
            details.primaryVelocity! < -300) {
          widget.onSwipeUpToLesson?.call();
        }
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background
          Container(color: _kBgColor),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(top: 100, bottom: 50),
              child: LayoutBuilder(
                builder: (context, constraints) =>
                    _buildContent(constraints.maxWidth),
              ),
            ),
          ),

          Positioned(left: 0, right: 0, bottom: 30, child: _buildHint()),
        ],
      ),
    );
  }

  Widget _buildContent(double w) {
    final lessons = widget.topic.lessons;
    final nodes = _calcNodes(w);
    final nRows = (lessons.length / 2).ceil();
    final exam = _examPos(w, nRows);
    final review = _reviewPos(w, nRows);
    final h = exam.dy + _kCardSize + 100;

    return SizedBox(
      height: h,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Path Painter (Funnel Style)
          CustomPaint(
            size: Size(w, h),
            painter: _FunnelPathPainter(
              lessonPositions: nodes,
              examPosition: exam,
              reviewPosition: review,
              currentLessonIndex: widget.currentLessonIndex,
            ),
          ),

          // Lessons
          for (int i = 0; i < lessons.length; i++)
            Positioned(
              left: nodes[i].dx - _kHalfCard,
              top: nodes[i].dy - _kHalfCard,
              child: _buildLessonNode(lessons[i], i),
            ),

          // Exam Node
          Positioned(
            left: exam.dx - _kHalfCard,
            top: exam.dy - _kHalfCard,
            child: _buildExamNode(),
          ),

          // Review Node
          Positioned(
            left: review.dx - _kHalfCard,
            top: review.dy - _kHalfCard,
            child: _buildReviewNode(),
          ),
        ],
      ),
    );
  }

  Widget _buildLessonNode(Lesson lesson, int index) {
    final isCurrent = index == widget.currentLessonIndex;
    final isLocked = index > widget.currentLessonIndex;
    final color = isCurrent ? _kActiveColor : _kLockedColor;

    return GestureDetector(
      onTap: !isLocked ? () => widget.onLessonSelected(lesson) : null,
      child: SizedBox(
        width: _kCardSize,
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                // Node Shape
                Container(
                  width: _kCardSize,
                  height: _kCardSize,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Center(
                    child: isCurrent
                        ? const Icon(
                            Icons.play_arrow_rounded,
                            color: _kIconColor,
                            size: 44,
                          )
                        : !isLocked
                        // Completed
                        ? Text(
                            '${index + 1}',
                            style: TextStyle(
                              color: _kIconColor.withValues(alpha: 0.9),
                              fontSize: 32,
                              fontWeight: FontWeight.w800,
                            ),
                          )
                        // Locked
                        : const Icon(
                            Icons.lock_rounded,
                            color: _kIconColor,
                            size: 32,
                          ),
                  ),
                ),

                // Mascot on Current
                if (isCurrent)
                  Positioned(
                    top: -35,
                    child: Image.asset(
                      'assets/images/water.webp',
                      width: 50,
                      height: 50,
                      errorBuilder: (context, error, stackTrace) =>
                          const SizedBox.shrink(),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExamNode() {
    return SizedBox(
      width: _kCardSize,
      child: Column(
        children: [
          Container(
            width: _kCardSize,
            height: _kCardSize,
            decoration: BoxDecoration(
              color: _kLockedColor,
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Center(
              child: Icon(
                Icons.emoji_events_rounded,
                color: _kIconColor,
                size: 36,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewNode() {
    return SizedBox(
      width: _kCardSize,
      child: Column(
        children: [
          Container(
            width: _kCardSize,
            height: _kCardSize,
            decoration: BoxDecoration(
              color: _kLockedColor,
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Center(
              child: Icon(Icons.refresh_rounded, color: _kIconColor, size: 36),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHint() {
    if (widget.currentLessonIndex >= widget.topic.lessons.length) {
      return const SizedBox.shrink();
    }
    return AnimatedBuilder(
      animation: _hintAnimation,
      builder: (_, child) => Transform.translate(
        offset: Offset(0, _hintAnimation.value),
        child: child,
      ),
      child: Column(
        children: [
          // Origami-like icon or chevron
          Icon(
            Icons.keyboard_arrow_up_rounded,
            color: _kTextColor.withValues(alpha: 0.6),
            size: 36,
          ),
          const Text(
            'Lướt để học',
            style: TextStyle(
              color: _kTextColor,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _FunnelPathPainter extends CustomPainter {
  final List<Offset> lessonPositions;
  final Offset examPosition;
  final Offset reviewPosition;
  final int currentLessonIndex;

  _FunnelPathPainter({
    required this.lessonPositions,
    required this.examPosition,
    required this.reviewPosition,
    required this.currentLessonIndex,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (lessonPositions.isEmpty) return;

    final allNodes = [...lessonPositions, examPosition, reviewPosition];
    // Fill style for the funnel shapes
    final paint = Paint()..style = PaintingStyle.fill;

    for (int i = 0; i < allNodes.length - 1; i++) {
      final start = allNodes[i];
      final end = allNodes[i + 1];

      // Color depends on start logic
      Color color = _kLockedColor;
      if (i == currentLessonIndex) {
        color = _kActiveColor;
      }
      paint.color = color;

      final path = _buildFunnelPath(start, end);
      canvas.drawPath(path, paint);
    }
  }

  Path _buildFunnelPath(Offset from, Offset to) {
    // Config:

    final dx = to.dx - from.dx;
    final dy = to.dy - from.dy;

    final path = Path(); // Used for fallback

    // 1. Vertical Connection (Same X)
    if (dx.abs() < 10) {
      // Connect Bottom of From to Top of To
      return _drawBoneShape(
        start: Offset(from.dx, from.dy + 40),
        end: Offset(to.dx, to.dy - 40),
        isVertical: true,
      );
    }

    // 2. Horizontal Connection (Same Y roughly)
    if (dy.abs() < 10) {
      final isRight = to.dx > from.dx;
      final startX = from.dx + (isRight ? 40 : -40);
      final endX = to.dx + (isRight ? -40 : 40);

      return _drawBoneShape(
        start: Offset(startX, from.dy),
        end: Offset(endX, to.dy),
        isVertical: false,
      );
    }

    // 3. Diagonal/S-Curve fallback (should rarely happen with this layout)
    path.moveTo(from.dx, from.dy);
    path.lineTo(to.dx, to.dy);
    return path;
  }

  Path _drawBoneShape({
    required Offset start,
    required Offset end,
    required bool isVertical,
  }) {
    final path = Path();
    const wStart = 28.0; // Wide flare (covers ~90% of node)
    const wMid = 2.0; // Thin middle line (4px total)
    const flareLen =
        50.0; // Length of the flare curve (Needs to be long for curve)

    if (isVertical) {
      // Points
      final dist = (end.dy - start.dy).abs();
      // If distance is too short, just do simple bezier
      if (dist < flareLen * 2) {
        // Fallback to simple shape if nodes are too close
        final pTopLeft = Offset(start.dx - wStart, start.dy);
        final pTopRight = Offset(start.dx + wStart, start.dy);
        final pBotRight = Offset(end.dx + wStart, end.dy);
        final pBotLeft = Offset(end.dx - wStart, end.dy);
        final midY = (start.dy + end.dy) / 2;

        path.moveTo(pTopLeft.dx, pTopLeft.dy);
        path.lineTo(pTopRight.dx, pTopRight.dy);
        path.cubicTo(
          start.dx + wMid,
          midY - 10,
          end.dx + wMid,
          midY + 10,
          pBotRight.dx,
          pBotRight.dy,
        );
        path.lineTo(pBotLeft.dx, pBotLeft.dy);
        path.cubicTo(
          end.dx - wMid,
          midY + 10,
          start.dx - wMid,
          midY - 10,
          pTopLeft.dx,
          pTopLeft.dy,
        );
        path.close();
        return path;
      }

      // Vertical flared Line
      final pStartLeft = Offset(start.dx - wStart, start.dy);
      final pStartRight = Offset(start.dx + wStart, start.dy);

      final pEndRight = Offset(end.dx + wStart, end.dy);
      final pEndLeft = Offset(end.dx - wStart, end.dy);

      // Mid Points (Thin straight segment)
      final midStartLeft = Offset(start.dx - wMid, start.dy + flareLen);
      final midStartRight = Offset(start.dx + wMid, start.dy + flareLen);

      final midEndRight = Offset(end.dx + wMid, end.dy - flareLen);
      final midEndLeft = Offset(end.dx - wMid, end.dy - flareLen);

      path.moveTo(pStartLeft.dx, pStartLeft.dy);
      path.lineTo(pStartRight.dx, pStartRight.dy);

      // Flare In (Right)
      path.cubicTo(
        pStartRight.dx,
        start.dy + flareLen * 0.1, // Control 1: Narrow immediately (0.1)
        midStartRight.dx,
        midStartRight.dy - flareLen * 0.9, // Control 2: Reach thin early (0.9)
        midStartRight.dx,
        midStartRight.dy,
      );

      // Straight Line
      path.lineTo(midEndRight.dx, midEndRight.dy);

      // Flare Out (Right)
      path.cubicTo(
        midEndRight.dx,
        midEndRight.dy + flareLen * 0.9,
        pEndRight.dx,
        end.dy - flareLen * 0.1,
        pEndRight.dx,
        pEndRight.dy,
      );

      path.lineTo(pEndLeft.dx, pEndLeft.dy);

      // Flare In (Left - Reverse)
      path.cubicTo(
        pEndLeft.dx,
        end.dy - flareLen * 0.1,
        midEndLeft.dx,
        midEndLeft.dy + flareLen * 0.9,
        midEndLeft.dx,
        midEndLeft.dy,
      );

      path.lineTo(midStartLeft.dx, midStartLeft.dy);

      // Flare Out (Left - Reverse)
      path.cubicTo(
        midStartLeft.dx,
        midStartLeft.dy - flareLen * 0.9,
        pStartLeft.dx,
        start.dy + flareLen * 0.1,
        pStartLeft.dx,
        pStartLeft.dy,
      );
    } else {
      // Horizontal
      final isRight = end.dx > start.dx;

      final dist = (end.dx - start.dx).abs();
      if (dist < flareLen * 2) {
        // Fallback simple
        final pStartTop = Offset(start.dx, start.dy - wStart);
        final pStartBot = Offset(start.dx, start.dy + wStart);
        final pEndBot = Offset(end.dx, end.dy + wStart);
        final pEndTop = Offset(end.dx, end.dy - wStart);
        final midX = (start.dx + end.dx) / 2;

        path.moveTo(pStartTop.dx, pStartTop.dy);
        path.cubicTo(
          midX - 10,
          start.dy - wMid,
          midX + 10,
          end.dy - wMid,
          pEndTop.dx,
          pEndTop.dy,
        );
        path.lineTo(pEndBot.dx, pEndBot.dy);
        path.cubicTo(
          midX + 10,
          end.dy + wMid,
          midX - 10,
          start.dy + wMid,
          pStartBot.dx,
          pStartBot.dy,
        );
        path.close();
        return path;
      }

      // Horizontal Flared Line
      final pStartTop = Offset(start.dx, start.dy - wStart);
      final pStartBot = Offset(start.dx, start.dy + wStart);
      final pEndBot = Offset(end.dx, end.dy + wStart);
      final pEndTop = Offset(end.dx, end.dy - wStart);

      // Determine direction for flare offset
      final dir = isRight ? 1.0 : -1.0;

      final midStartTop = Offset(start.dx + flareLen * dir, start.dy - wMid);
      final midStartBot = Offset(start.dx + flareLen * dir, start.dy + wMid);

      final midEndTop = Offset(end.dx - flareLen * dir, end.dy - wMid);
      final midEndBot = Offset(end.dx - flareLen * dir, end.dy + wMid);

      path.moveTo(pStartTop.dx, pStartTop.dy);

      // Top Flare In
      path.cubicTo(
        start.dx + flareLen * 0.1 * dir,
        pStartTop.dy, // C1
        midStartTop.dx - flareLen * 0.9 * dir,
        midStartTop.dy, // C2
        midStartTop.dx,
        midStartTop.dy,
      );

      // Top Straight Line
      path.lineTo(midEndTop.dx, midEndTop.dy);

      // Top Flare Out
      path.cubicTo(
        midEndTop.dx + flareLen * 0.9 * dir,
        midEndTop.dy, // C1
        end.dx - flareLen * 0.1 * dir,
        pEndTop.dy, // C2
        pEndTop.dx,
        pEndTop.dy,
      );

      path.lineTo(pEndBot.dx, pEndBot.dy);

      // Bottom Flare In (Reverse)
      path.cubicTo(
        end.dx - flareLen * 0.1 * dir,
        pEndBot.dy,
        midEndBot.dx + flareLen * 0.9 * dir,
        midEndBot.dy,
        midEndBot.dx,
        midEndBot.dy,
      );

      // Bottom Straight Line
      path.lineTo(midStartBot.dx, midStartBot.dy);

      // Bottom Flare Out (Reverse)
      path.cubicTo(
        midStartBot.dx - flareLen * 0.9 * dir,
        midStartBot.dy,
        start.dx + flareLen * 0.1 * dir,
        pStartBot.dy,
        pStartBot.dx,
        pStartBot.dy,
      );
    }

    path.close();
    return path;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
