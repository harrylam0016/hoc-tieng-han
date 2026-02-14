import 'package:flutter/material.dart';

import '../data/sample_data.dart';
import '../models/topic.dart';

// Palette matches the "Lesson Path" bright beige concept, but adapted for wood texture
const _kBgColor = Color(0xFFF5E7CD); // Warm Beige (Background)
const _kMascotBgColor = Color(0xFF3E2723); // Dark brown for mascot circle bg

// Birdhouse Palette
const _kHouseBodyColor = Color(0xFFD7CCC8); // Light wood
const _kHouseRoofBrown = Color(0xFF795548); // Darker wood (original)
const _kHouseRoofRed = Color(0xFFC8553D); // Burnt Orange from Lesson Path
const _kHouseRoofGreen = Color(0xFF7D9B76); // Sage Green from Lesson Path
const _kHoleColor = Color(0xFF3E2723); // Dark hollow
const _kNailColor = Color(0xFF5D4037); // Rust/Dark brown

class TopicSelectionContent extends StatelessWidget {
  final void Function(Topic topic) onTopicSelected;

  const TopicSelectionContent({super.key, required this.onTopicSelected});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBgColor,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Background Texture (Faint wood planks)
          CustomPaint(painter: _WoodPlankPainter(), size: Size.infinite),

          SafeArea(
            child: CustomScrollView(
              slivers: [
                // 2. Mascot Header (Scrollable)
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      const SizedBox(height: 60), // Space for Shell Header
                      _buildMascotHeader(),
                    ],
                  ),
                ),

                // 3. Birdhouse Grid
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 24,
                  ),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.85, // Taller for house shape
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 32,
                        ),
                    delegate: SliverChildBuilderDelegate((context, index) {
                      return _BirdhouseItem(
                        topic: sampleTopics[index],
                        index: index,
                        onTap: () => onTopicSelected(sampleTopics[index]),
                      );
                    }, childCount: sampleTopics.length),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMascotHeader() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _kMascotBgColor,
              border: Border.all(color: _kHouseRoofBrown, width: 4),
              // No shadow
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                'assets/images/water.webp', // Updated to .webp
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.pets, color: Colors.white, size: 40),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: 60,
            height: 12,
            decoration: BoxDecoration(
              color: _kMascotBgColor.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ],
      ),
    );
  }
}

class _BirdhouseItem extends StatelessWidget {
  final Topic topic;
  final int index;
  final VoidCallback onTap;

  const _BirdhouseItem({
    required this.topic,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Subtle organic tilt
    final double rotateAmt = (index % 2 == 0 ? -0.05 : 0.05);

    // Roof Color: Cycle through Brown, Red, Green
    final colorIndex = index % 3;
    final roofColor = colorIndex == 0
        ? _kHouseRoofBrown
        : (colorIndex == 1 ? _kHouseRoofRed : _kHouseRoofGreen);

    return GestureDetector(
      onTap: onTap,
      child: Transform(
        alignment: Alignment.center,
        transform: Matrix4.rotationZ(rotateAmt),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // House Shape (Body + Roof)
            CustomPaint(
              size: const Size(160, 200),
              painter: _BirdhousePainter(roofColor: roofColor),
            ),

            // Entrance Hole & Content
            Positioned(
              top: 60, // Below roof
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: _kHoleColor,
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Image.asset(
                          topic.imagePath,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.star, color: Colors.amber),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Topic Name
                  Text(
                    topic.name.toUpperCase(),
                    style: const TextStyle(
                      fontFamily: 'PatrickHand',
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF4E342E), // Dark wood text
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BirdhousePainter extends CustomPainter {
  final Color roofColor;

  _BirdhousePainter({required this.roofColor});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Shadows - Removed per request

    // Body Paint
    final bodyPaint = Paint()..color = _kHouseBodyColor;
    final roofPaint = Paint()..color = roofColor;
    final nailPaint = Paint()..color = _kNailColor;

    // 1. Draw Shadow - Removed
    // final path = Path()...
    // canvas.drawPath(path.shift(const Offset(4, 6)), shadowPaint);

    // 2. Draw Body (Rectangle)
    // Start slightly below roof peak
    final bodyRect = Rect.fromLTWH(10, 40, w - 20, h - 40);
    // Draw "planks" on body?
    canvas.drawRect(bodyRect, bodyPaint);

    // 3. Draw Roof
    final roofPath = Path();
    roofPath.moveTo(0, 40);
    roofPath.lineTo(w / 2, 0);
    roofPath.lineTo(w, 40);
    roofPath.lineTo(w - 10, 40); // Overhang return
    roofPath.lineTo(w / 2, 10); // Inner peak
    roofPath.lineTo(10, 40);
    roofPath.close();

    // Fill roof
    // Actually standard triangle roof looks better
    final simpleRoof = Path();
    simpleRoof.moveTo(-10, 45); // Extend past body
    simpleRoof.lineTo(w / 2, -5);
    simpleRoof.lineTo(w + 10, 45);
    simpleRoof.lineTo(w, 45);
    simpleRoof.lineTo(w / 2, 5);
    simpleRoof.lineTo(0, 45);
    simpleRoof.close();

    // Draw main roof triangle
    final mainRoof = Path();
    mainRoof.moveTo(-5, 45);
    mainRoof.lineTo(w / 2, -5);
    mainRoof.lineTo(w + 5, 45);
    mainRoof.close();
    canvas.drawPath(mainRoof, roofPaint);

    // 4. Nails
    canvas.drawCircle(Offset(20, 55), 3, nailPaint);
    canvas.drawCircle(Offset(w - 20, 55), 3, nailPaint);
    canvas.drawCircle(Offset(20, h - 15), 3, nailPaint);
    canvas.drawCircle(Offset(w - 20, h - 15), 3, nailPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Simple wood plank background
class _WoodPlankPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Just vertical faint lines
    final paint = Paint()
      ..color = Colors.brown.withValues(alpha: 0.1)
      ..strokeWidth = 2;

    double x = 40;
    while (x < size.width) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
      x += 80; // Wide planks
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
