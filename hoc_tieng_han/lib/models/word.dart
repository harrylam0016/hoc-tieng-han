/// Một từ vựng tiếng Hàn
class Word {
  final String korean;
  final String vietnamese;
  final String romanization;
  final String imagePath; // Đường dẫn hình ảnh minh họa

  const Word({
    required this.korean,
    required this.vietnamese,
    required this.romanization,
    required this.imagePath,
  });
}
