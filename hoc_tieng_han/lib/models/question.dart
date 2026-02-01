enum QuestionType { multipleChoice, matching, fillBlank }

/// Một câu hỏi trong mini-game hoặc boss battle
class Question {
  final QuestionType type;
  final String question;
  final List<String> options;
  final String correctAnswer;
  final String? hint;

  const Question({
    required this.type,
    required this.question,
    required this.options,
    required this.correctAnswer,
    this.hint,
  });
}

/// Cặp từ cho game nối từ (Matching)
class MatchingPair {
  final String korean;
  final String vietnamese;

  const MatchingPair({required this.korean, required this.vietnamese});
}
