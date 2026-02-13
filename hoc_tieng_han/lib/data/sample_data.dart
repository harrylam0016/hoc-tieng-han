import '../models/topic.dart';
import '../models/word.dart';
import '../models/question.dart';

/// Dữ liệu mẫu cho các chủ đề học tiếng Hàn
final List<Topic> sampleTopics = [
  // 1. Gia đình
  Topic(
    id: 'family',
    name: 'Gia đình',
    koreanName: '가족',
    description: 'Các từ vựng về thành viên trong gia đình',
    emoji: '👨‍👩‍👧‍👦',
    imagePath: 'assets/images/family.webp',
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
            imagePath: 'assets/images/family.webp',
          ),
          Word(
            korean: '아버지',
            vietnamese: 'Bố',
            romanization: 'Abeoji',
            imagePath: 'assets/images/family.webp',
          ),
          Word(
            korean: '어머니',
            vietnamese: 'Mẹ',
            romanization: 'Eomeoni',
            imagePath: 'assets/images/family.webp',
          ),
          Word(
            korean: '형',
            vietnamese: 'Anh trai',
            romanization: 'Hyeong',
            imagePath: 'assets/images/family.webp',
          ),
          Word(
            korean: '여동생',
            vietnamese: 'Em gái',
            romanization: 'Yeodongsaeng',
            imagePath: 'assets/images/family.webp',
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

  // 2. Số đếm
  Topic(
    id: 'numbers',
    name: 'Số đếm',
    koreanName: '숫자',
    description: 'Học đếm số trong tiếng Hàn',
    emoji: '🔢',
    imagePath: 'assets/images/number.webp',
    lessons: [
      Lesson(
        id: 'numbers_1',
        topicId: 'numbers',
        name: 'Số 1-5',
        lessonNumber: 1,
        words: const [
          Word(
            korean: '하나',
            vietnamese: 'Một',
            romanization: 'Hana',
            imagePath: 'assets/images/number.webp',
          ),
          Word(
            korean: '둘',
            vietnamese: 'Hai',
            romanization: 'Dul',
            imagePath: 'assets/images/number.webp',
          ),
          Word(
            korean: '셋',
            vietnamese: 'Ba',
            romanization: 'Set',
            imagePath: 'assets/images/number.webp',
          ),
          Word(
            korean: '넷',
            vietnamese: 'Bốn',
            romanization: 'Net',
            imagePath: 'assets/images/number.webp',
          ),
          Word(
            korean: '다섯',
            vietnamese: 'Năm',
            romanization: 'Daseot',
            imagePath: 'assets/images/number.webp',
          ),
        ],
        questions: const [],
      ),
    ],
  ),

  // 3. Thời gian
  Topic(
    id: 'time',
    name: 'Thời gian',
    koreanName: '시간',
    description: 'Từ vựng về thời gian và ngày tháng',
    emoji: '🕐',
    imagePath: 'assets/images/clock.webp',
    lessons: [
      Lesson(
        id: 'time_1',
        topicId: 'time',
        name: 'Giờ và phút',
        lessonNumber: 1,
        words: const [
          Word(
            korean: '시간',
            vietnamese: 'Thời gian',
            romanization: 'Sigan',
            imagePath: 'assets/images/clock.webp',
          ),
          Word(
            korean: '오늘',
            vietnamese: 'Hôm nay',
            romanization: 'Oneul',
            imagePath: 'assets/images/clock.webp',
          ),
          Word(
            korean: '내일',
            vietnamese: 'Ngày mai',
            romanization: 'Naeil',
            imagePath: 'assets/images/clock.webp',
          ),
          Word(
            korean: '어제',
            vietnamese: 'Hôm qua',
            romanization: 'Eoje',
            imagePath: 'assets/images/clock.webp',
          ),
          Word(
            korean: '지금',
            vietnamese: 'Bây giờ',
            romanization: 'Jigeum',
            imagePath: 'assets/images/clock.webp',
          ),
        ],
        questions: const [],
      ),
    ],
  ),

  // 4. Ăn uống
  Topic(
    id: 'food',
    name: 'Ăn uống',
    koreanName: '음식',
    description: 'Các từ vựng về đồ ăn và đồ uống',
    emoji: '🍜',
    imagePath: 'assets/images/drink.webp',
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
            imagePath: 'assets/images/drink.webp',
          ),
          Word(
            korean: '김치',
            vietnamese: 'Kim chi',
            romanization: 'Gimchi',
            imagePath: 'assets/images/drink.webp',
          ),
          Word(
            korean: '불고기',
            vietnamese: 'Thịt nướng',
            romanization: 'Bulgogi',
            imagePath: 'assets/images/drink.webp',
          ),
          Word(
            korean: '라면',
            vietnamese: 'Mì gói',
            romanization: 'Ramyeon',
            imagePath: 'assets/images/drink.webp',
          ),
          Word(
            korean: '떡볶이',
            vietnamese: 'Bánh gạo cay',
            romanization: 'Tteokbokki',
            imagePath: 'assets/images/drink.webp',
          ),
        ],
        questions: const [],
      ),
    ],
  ),

  // 5. Địa điểm
  Topic(
    id: 'places',
    name: 'Địa điểm',
    koreanName: '장소',
    description: 'Từ vựng về các địa điểm phổ biến',
    emoji: '📍',
    imagePath: 'assets/images/cinema.webp',
    lessons: [
      Lesson(
        id: 'places_1',
        topicId: 'places',
        name: 'Nơi chốn',
        lessonNumber: 1,
        words: const [
          Word(
            korean: '학교',
            vietnamese: 'Trường học',
            romanization: 'Hakgyo',
            imagePath: 'assets/images/cinema.webp',
          ),
          Word(
            korean: '병원',
            vietnamese: 'Bệnh viện',
            romanization: 'Byeongwon',
            imagePath: 'assets/images/cinema.webp',
          ),
          Word(
            korean: '은행',
            vietnamese: 'Ngân hàng',
            romanization: 'Eunhaeng',
            imagePath: 'assets/images/cinema.webp',
          ),
          Word(
            korean: '시장',
            vietnamese: 'Chợ',
            romanization: 'Sijang',
            imagePath: 'assets/images/cinema.webp',
          ),
          Word(
            korean: '공원',
            vietnamese: 'Công viên',
            romanization: 'Gongwon',
            imagePath: 'assets/images/cinema.webp',
          ),
        ],
        questions: const [],
      ),
    ],
  ),

  // 6. Nhà cửa
  Topic(
    id: 'house',
    name: 'Nhà cửa',
    koreanName: '집',
    description: 'Từ vựng về nhà cửa và đồ vật trong nhà',
    emoji: '🏠',
    imagePath: 'assets/images/house.webp',
    lessons: [
      Lesson(
        id: 'house_1',
        topicId: 'house',
        name: 'Đồ vật trong nhà',
        lessonNumber: 1,
        words: const [
          Word(
            korean: '집',
            vietnamese: 'Nhà',
            romanization: 'Jip',
            imagePath: 'assets/images/house.webp',
          ),
          Word(
            korean: '방',
            vietnamese: 'Phòng',
            romanization: 'Bang',
            imagePath: 'assets/images/house.webp',
          ),
          Word(
            korean: '문',
            vietnamese: 'Cửa',
            romanization: 'Mun',
            imagePath: 'assets/images/house.webp',
          ),
          Word(
            korean: '창문',
            vietnamese: 'Cửa sổ',
            romanization: 'Changmun',
            imagePath: 'assets/images/house.webp',
          ),
          Word(
            korean: '의자',
            vietnamese: 'Ghế',
            romanization: 'Uija',
            imagePath: 'assets/images/house.webp',
          ),
        ],
        questions: const [],
      ),
    ],
  ),

  // 7. Giao thông
  Topic(
    id: 'transport',
    name: 'Giao thông',
    koreanName: '교통',
    description: 'Từ vựng về phương tiện giao thông',
    emoji: '🚌',
    imagePath: 'assets/images/bus.webp',
    lessons: [
      Lesson(
        id: 'transport_1',
        topicId: 'transport',
        name: 'Phương tiện',
        lessonNumber: 1,
        words: const [
          Word(
            korean: '버스',
            vietnamese: 'Xe buýt',
            romanization: 'Beoseu',
            imagePath: 'assets/images/bus.webp',
          ),
          Word(
            korean: '지하철',
            vietnamese: 'Tàu điện ngầm',
            romanization: 'Jihacheol',
            imagePath: 'assets/images/bus.webp',
          ),
          Word(
            korean: '택시',
            vietnamese: 'Taxi',
            romanization: 'Taeksi',
            imagePath: 'assets/images/bus.webp',
          ),
          Word(
            korean: '자동차',
            vietnamese: 'Ô tô',
            romanization: 'Jadongcha',
            imagePath: 'assets/images/bus.webp',
          ),
          Word(
            korean: '자전거',
            vietnamese: 'Xe đạp',
            romanization: 'Jajeongeo',
            imagePath: 'assets/images/bus.webp',
          ),
        ],
        questions: const [],
      ),
    ],
  ),

  // 8. Động vật
  Topic(
    id: 'animals',
    name: 'Động vật',
    koreanName: '동물',
    description: 'Từ vựng về các loài động vật',
    emoji: '🐶',
    imagePath: 'assets/images/dog.webp',
    lessons: [
      Lesson(
        id: 'animals_1',
        topicId: 'animals',
        name: 'Vật nuôi',
        lessonNumber: 1,
        words: const [
          Word(
            korean: '개',
            vietnamese: 'Chó',
            romanization: 'Gae',
            imagePath: 'assets/images/dog.webp',
          ),
          Word(
            korean: '고양이',
            vietnamese: 'Mèo',
            romanization: 'Goyangi',
            imagePath: 'assets/images/dog.webp',
          ),
          Word(
            korean: '새',
            vietnamese: 'Chim',
            romanization: 'Sae',
            imagePath: 'assets/images/dog.webp',
          ),
          Word(
            korean: '물고기',
            vietnamese: 'Cá',
            romanization: 'Mulgogi',
            imagePath: 'assets/images/dog.webp',
          ),
          Word(
            korean: '토끼',
            vietnamese: 'Thỏ',
            romanization: 'Tokki',
            imagePath: 'assets/images/dog.webp',
          ),
        ],
        questions: const [],
      ),
    ],
  ),

  // 9. Cảm xúc
  Topic(
    id: 'emotions',
    name: 'Cảm xúc',
    koreanName: '감정',
    description: 'Từ vựng về cảm xúc và tâm trạng',
    emoji: '❤️',
    imagePath: 'assets/images/heart.webp',
    lessons: [
      Lesson(
        id: 'emotions_1',
        topicId: 'emotions',
        name: 'Cảm xúc cơ bản',
        lessonNumber: 1,
        words: const [
          Word(
            korean: '기쁘다',
            vietnamese: 'Vui',
            romanization: 'Gippeuda',
            imagePath: 'assets/images/heart.webp',
          ),
          Word(
            korean: '슬프다',
            vietnamese: 'Buồn',
            romanization: 'Seulpeuda',
            imagePath: 'assets/images/heart.webp',
          ),
          Word(
            korean: '화나다',
            vietnamese: 'Tức giận',
            romanization: 'Hwanada',
            imagePath: 'assets/images/heart.webp',
          ),
          Word(
            korean: '무섭다',
            vietnamese: 'Sợ',
            romanization: 'Museopda',
            imagePath: 'assets/images/heart.webp',
          ),
          Word(
            korean: '사랑',
            vietnamese: 'Tình yêu',
            romanization: 'Sarang',
            imagePath: 'assets/images/heart.webp',
          ),
        ],
        questions: const [],
      ),
    ],
  ),

  // 10. Mua sắm
  Topic(
    id: 'shopping',
    name: 'Mua sắm',
    koreanName: '쇼핑',
    description: 'Từ vựng khi đi mua sắm',
    emoji: '🛍️',
    imagePath: 'assets/images/sale.webp',
    lessons: [
      Lesson(
        id: 'shopping_1',
        topicId: 'shopping',
        name: 'Mua hàng',
        lessonNumber: 1,
        words: const [
          Word(
            korean: '가게',
            vietnamese: 'Cửa hàng',
            romanization: 'Gage',
            imagePath: 'assets/images/sale.webp',
          ),
          Word(
            korean: '돈',
            vietnamese: 'Tiền',
            romanization: 'Don',
            imagePath: 'assets/images/sale.webp',
          ),
          Word(
            korean: '비싸다',
            vietnamese: 'Đắt',
            romanization: 'Bissada',
            imagePath: 'assets/images/sale.webp',
          ),
          Word(
            korean: '싸다',
            vietnamese: 'Rẻ',
            romanization: 'Ssada',
            imagePath: 'assets/images/sale.webp',
          ),
          Word(
            korean: '카드',
            vietnamese: 'Thẻ',
            romanization: 'Kadeu',
            imagePath: 'assets/images/sale.webp',
          ),
        ],
        questions: const [],
      ),
    ],
  ),
];
