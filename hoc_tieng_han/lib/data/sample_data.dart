import '../models/topic.dart';
import '../models/word.dart';
import '../models/question.dart';

/// Dữ liệu mẫu cho các chủ đề học tiếng Hàn
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
  Topic(
    id: 'food',
    name: 'Ẩm thực',
    koreanName: '음식',
    description: 'Các từ vựng về đồ ăn và món ăn Hàn Quốc',
    emoji: '🍜',
    lessons: [
      Lesson(
        id: 'food_1',
        topicId: 'food',
        name: 'Món ăn phổ biến',
        lessonNumber: 1,
        words: const [
          Word(
            korean: '밥',
            vietnamese: 'Cơm',
            romanization: 'Bap',
            imagePath: 'assets/images/family.png',
          ),
          Word(
            korean: '김치',
            vietnamese: 'Kim chi',
            romanization: 'Gimchi',
            imagePath: 'assets/images/family.png',
          ),
          Word(
            korean: '불고기',
            vietnamese: 'Thịt nướng',
            romanization: 'Bulgogi',
            imagePath: 'assets/images/family.png',
          ),
          Word(
            korean: '라면',
            vietnamese: 'Mì gói',
            romanization: 'Ramyeon',
            imagePath: 'assets/images/family.png',
          ),
          Word(
            korean: '떡볶이',
            vietnamese: 'Bánh gạo cay',
            romanization: 'Tteokbokki',
            imagePath: 'assets/images/family.png',
          ),
        ],
        questions: const [],
      ),
    ],
  ),
  Topic(
    id: 'drinks',
    name: 'Đồ uống',
    koreanName: '음료',
    description: 'Các từ vựng về đồ uống',
    emoji: '☕',
    lessons: [
      Lesson(
        id: 'drinks_1',
        topicId: 'drinks',
        name: 'Đồ uống hàng ngày',
        lessonNumber: 1,
        words: const [
          Word(
            korean: '물',
            vietnamese: 'Nước',
            romanization: 'Mul',
            imagePath: 'assets/images/family.png',
          ),
          Word(
            korean: '커피',
            vietnamese: 'Cà phê',
            romanization: 'Keopi',
            imagePath: 'assets/images/family.png',
          ),
          Word(
            korean: '차',
            vietnamese: 'Trà',
            romanization: 'Cha',
            imagePath: 'assets/images/family.png',
          ),
          Word(
            korean: '주스',
            vietnamese: 'Nước ép',
            romanization: 'Juseu',
            imagePath: 'assets/images/family.png',
          ),
          Word(
            korean: '우유',
            vietnamese: 'Sữa',
            romanization: 'Uyu',
            imagePath: 'assets/images/family.png',
          ),
        ],
        questions: const [],
      ),
    ],
  ),
  Topic(
    id: 'travel',
    name: 'Du lịch',
    koreanName: '여행',
    description: 'Từ vựng hữu ích khi đi du lịch Hàn Quốc',
    emoji: '✈️',
    lessons: [
      Lesson(
        id: 'travel_1',
        topicId: 'travel',
        name: 'Di chuyển',
        lessonNumber: 1,
        words: const [
          Word(
            korean: '공항',
            vietnamese: 'Sân bay',
            romanization: 'Gonghang',
            imagePath: 'assets/images/family.png',
          ),
          Word(
            korean: '호텔',
            vietnamese: 'Khách sạn',
            romanization: 'Hotel',
            imagePath: 'assets/images/family.png',
          ),
          Word(
            korean: '택시',
            vietnamese: 'Taxi',
            romanization: 'Taeksi',
            imagePath: 'assets/images/family.png',
          ),
          Word(
            korean: '지하철',
            vietnamese: 'Tàu điện ngầm',
            romanization: 'Jihacheol',
            imagePath: 'assets/images/family.png',
          ),
          Word(
            korean: '버스',
            vietnamese: 'Xe buýt',
            romanization: 'Beoseu',
            imagePath: 'assets/images/family.png',
          ),
        ],
        questions: const [],
      ),
    ],
  ),
  Topic(
    id: 'greetings',
    name: 'Chào hỏi',
    koreanName: '인사',
    description: 'Các câu chào hỏi cơ bản trong tiếng Hàn',
    emoji: '👋',
    lessons: [
      Lesson(
        id: 'greetings_1',
        topicId: 'greetings',
        name: 'Lời chào cơ bản',
        lessonNumber: 1,
        words: const [
          Word(
            korean: '안녕하세요',
            vietnamese: 'Xin chào',
            romanization: 'Annyeonghaseyo',
            imagePath: 'assets/images/family.png',
          ),
          Word(
            korean: '감사합니다',
            vietnamese: 'Cảm ơn',
            romanization: 'Gamsahamnida',
            imagePath: 'assets/images/family.png',
          ),
          Word(
            korean: '죄송합니다',
            vietnamese: 'Xin lỗi',
            romanization: 'Joesonghamnida',
            imagePath: 'assets/images/family.png',
          ),
          Word(
            korean: '네',
            vietnamese: 'Vâng',
            romanization: 'Ne',
            imagePath: 'assets/images/family.png',
          ),
          Word(
            korean: '아니요',
            vietnamese: 'Không',
            romanization: 'Aniyo',
            imagePath: 'assets/images/family.png',
          ),
        ],
        questions: const [],
      ),
    ],
  ),
  Topic(
    id: 'numbers',
    name: 'Số đếm',
    koreanName: '숫자',
    description: 'Học đếm số trong tiếng Hàn',
    emoji: '🔢',
    lessons: [
      Lesson(
        id: 'numbers_1',
        topicId: 'numbers',
        name: 'Số 1-10',
        lessonNumber: 1,
        words: const [
          Word(
            korean: '하나',
            vietnamese: 'Một',
            romanization: 'Hana',
            imagePath: 'assets/images/family.png',
          ),
          Word(
            korean: '둘',
            vietnamese: 'Hai',
            romanization: 'Dul',
            imagePath: 'assets/images/family.png',
          ),
          Word(
            korean: '셋',
            vietnamese: 'Ba',
            romanization: 'Set',
            imagePath: 'assets/images/family.png',
          ),
          Word(
            korean: '넷',
            vietnamese: 'Bốn',
            romanization: 'Net',
            imagePath: 'assets/images/family.png',
          ),
          Word(
            korean: '다섯',
            vietnamese: 'Năm',
            romanization: 'Daseot',
            imagePath: 'assets/images/family.png',
          ),
        ],
        questions: const [],
      ),
    ],
  ),
  Topic(
    id: 'transport',
    name: 'Giao thông',
    koreanName: '교통',
    description: 'Từ vựng về phương tiện giao thông',
    emoji: '🚆',
    lessons: [
      Lesson(
        id: 'transport_1',
        topicId: 'transport',
        name: 'Phương tiện',
        lessonNumber: 1,
        words: const [
          Word(
            korean: '자동차',
            vietnamese: 'Ô tô',
            romanization: 'Jadongcha',
            imagePath: 'assets/images/family.png',
          ),
          Word(
            korean: '자전거',
            vietnamese: 'Xe đạp',
            romanization: 'Jajeongeo',
            imagePath: 'assets/images/family.png',
          ),
          Word(
            korean: '비행기',
            vietnamese: 'Máy bay',
            romanization: 'Bihaenggi',
            imagePath: 'assets/images/family.png',
          ),
          Word(
            korean: '배',
            vietnamese: 'Tàu thuyền',
            romanization: 'Bae',
            imagePath: 'assets/images/family.png',
          ),
          Word(
            korean: '기차',
            vietnamese: 'Tàu hỏa',
            romanization: 'Gicha',
            imagePath: 'assets/images/family.png',
          ),
        ],
        questions: const [],
      ),
    ],
  ),
  Topic(
    id: 'kpop',
    name: 'K-Pop',
    koreanName: '케이팝',
    description: 'Từ vựng trong nhạc K-Pop và văn hóa idol',
    emoji: '🎤',
    lessons: [
      Lesson(
        id: 'kpop_1',
        topicId: 'kpop',
        name: 'Thuật ngữ K-Pop',
        lessonNumber: 1,
        words: const [
          Word(
            korean: '노래',
            vietnamese: 'Bài hát',
            romanization: 'Norae',
            imagePath: 'assets/images/family.png',
          ),
          Word(
            korean: '가수',
            vietnamese: 'Ca sĩ',
            romanization: 'Gasu',
            imagePath: 'assets/images/family.png',
          ),
          Word(
            korean: '팬',
            vietnamese: 'Fan',
            romanization: 'Paen',
            imagePath: 'assets/images/family.png',
          ),
          Word(
            korean: '춤',
            vietnamese: 'Nhảy/Múa',
            romanization: 'Chum',
            imagePath: 'assets/images/family.png',
          ),
          Word(
            korean: '콘서트',
            vietnamese: 'Concert',
            romanization: 'Konseoteu',
            imagePath: 'assets/images/family.png',
          ),
        ],
        questions: const [],
      ),
    ],
  ),
  Topic(
    id: 'honorifics',
    name: 'Kính ngữ',
    koreanName: '존댓말',
    description: 'Cách nói lịch sự và kính ngữ trong tiếng Hàn',
    emoji: '🎎',
    lessons: [
      Lesson(
        id: 'honorifics_1',
        topicId: 'honorifics',
        name: 'Kính ngữ cơ bản',
        lessonNumber: 1,
        words: const [
          Word(
            korean: '선생님',
            vietnamese: 'Thầy/Cô',
            romanization: 'Seonsaengnim',
            imagePath: 'assets/images/family.png',
          ),
          Word(
            korean: '사장님',
            vietnamese: 'Giám đốc',
            romanization: 'Sajangnim',
            imagePath: 'assets/images/family.png',
          ),
          Word(
            korean: '부모님',
            vietnamese: 'Cha mẹ (kính)',
            romanization: 'Bumonim',
            imagePath: 'assets/images/family.png',
          ),
          Word(
            korean: '어르신',
            vietnamese: 'Người lớn tuổi',
            romanization: 'Eoreusin',
            imagePath: 'assets/images/family.png',
          ),
          Word(
            korean: '댁',
            vietnamese: 'Nhà (kính)',
            romanization: 'Daek',
            imagePath: 'assets/images/family.png',
          ),
        ],
        questions: const [],
      ),
    ],
  ),
];
