import 'word.dart';
import 'question.dart';

/// Một chủ đề học (ví dụ: Chào hỏi, Gia đình, Thức ăn)
class Topic {
  final String id;
  final String name;
  final String koreanName;
  final String description;
  final String emoji;
  final List<Lesson> lessons;

  const Topic({
    required this.id,
    required this.name,
    required this.koreanName,
    required this.description,
    required this.emoji,
    required this.lessons,
  });
}

/// Một bài học trong chủ đề (chứa 5 từ mới)
class Lesson {
  final String id;
  final String topicId;
  final String name;
  final int lessonNumber;
  final List<Word> words;
  final List<Question> questions;

  const Lesson({
    required this.id,
    required this.topicId,
    required this.name,
    required this.lessonNumber,
    required this.words,
    required this.questions,
  });
}
