/// Một từ vựng tiếng Hàn
class Word {
  final String korean;
  final String vietnamese;
  final String romanization;

  const Word({
    required this.korean,
    required this.vietnamese,
    required this.romanization,
  });
}

/// Một câu ví dụ sử dụng từ vựng
class Example {
  final String korean;
  final String vietnamese;
  final String highlightWord; // Từ cần highlight trong câu

  const Example({
    required this.korean,
    required this.vietnamese,
    required this.highlightWord,
  });
}
