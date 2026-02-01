import '../models/topic.dart';
import '../models/word.dart';
import '../models/question.dart';

/// Dữ liệu mẫu: Chủ đề Gia đình
final List<Topic> sampleTopics = [
  Topic(
    id: 'family',
    name: 'Gia đình',
    koreanName: '가족',
    description: 'Các từ vựng về thành viên trong gia đình',
    emoji: '👨‍👩‍👧‍👦',
    lessons: [
      Lesson(
        id: 'family_1',
        topicId: 'family',
        name: 'Thành viên gia đình',
        lessonNumber: 1,
        words: const [
          Word(
            korean: '가족',
            vietnamese: 'Gia đình',
            romanization: 'Gajok',
            imagePath: 'assets/images/family.png',
          ),
          Word(
            korean: '아버지',
            vietnamese: 'Bố',
            romanization: 'Abeoji',
            imagePath: 'assets/images/father.png',
          ),
          Word(
            korean: '어머니',
            vietnamese: 'Mẹ',
            romanization: 'Eomeoni',
            imagePath: 'assets/images/mother.png',
          ),
          Word(
            korean: '형',
            vietnamese: 'Anh trai',
            romanization: 'Hyeong',
            imagePath: 'assets/images/older_brother.png',
          ),
          Word(
            korean: '여동생',
            vietnamese: 'Em gái',
            romanization: 'Yeodongsaeng',
            imagePath: 'assets/images/younger_sister.png',
          ),
        ],
        questions: const [
          Question(
            type: QuestionType.multipleChoice,
            question: '가족',
            options: ['Gia đình', 'Trường học', 'Công ty', 'Bệnh viện'],
            correctAnswer: 'Gia đình',
          ),
          Question(
            type: QuestionType.multipleChoice,
            question: '아버지',
            options: ['Bố', 'Mẹ', 'Anh trai', 'Em gái'],
            correctAnswer: 'Bố',
          ),
          Question(
            type: QuestionType.multipleChoice,
            question: '어머니',
            options: ['Bố', 'Mẹ', 'Anh trai', 'Em gái'],
            correctAnswer: 'Mẹ',
          ),
          Question(
            type: QuestionType.fillBlank,
            question: '___ (Anh trai)',
            options: ['형'],
            correctAnswer: '형',
            hint: 'Hyeong',
          ),
          Question(
            type: QuestionType.multipleChoice,
            question: 'Em gái trong tiếng Hàn là?',
            options: ['여동생', '남동생', '누나', '언니'],
            correctAnswer: '여동생',
          ),
        ],
      ),
    ],
  ),
];
