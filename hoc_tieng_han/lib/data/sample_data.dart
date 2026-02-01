import '../models/topic.dart';
import '../models/word.dart';
import '../models/question.dart';

/// Dữ liệu mẫu cho các chủ đề và bài học
final List<Topic> sampleTopics = [
  // ===== CHỦ ĐỀ 1: CHÀO HỎI =====
  Topic(
    id: 'greetings',
    name: 'Chào hỏi',
    koreanName: '인사',
    description: 'Học cách chào hỏi cơ bản trong tiếng Hàn',
    emoji: '👋',
    lessons: [
      Lesson(
        id: 'greetings_1',
        topicId: 'greetings',
        name: 'Chào hỏi cơ bản',
        lessonNumber: 1,
        words: const [
          Word(
            korean: '안녕하세요',
            vietnamese: 'Xin chào',
            romanization: 'annyeonghaseyo',
          ),
          Word(
            korean: '감사합니다',
            vietnamese: 'Cảm ơn',
            romanization: 'gamsahamnida',
          ),
          Word(
            korean: '죄송합니다',
            vietnamese: 'Xin lỗi',
            romanization: 'joesonghamnida',
          ),
          Word(korean: '네', vietnamese: 'Vâng/Dạ', romanization: 'ne'),
          Word(korean: '아니요', vietnamese: 'Không', romanization: 'aniyo'),
        ],
        examples: const [
          Example(
            korean: '안녕하세요, 저는 민준입니다.',
            vietnamese: 'Xin chào, tôi là Minjun.',
            highlightWord: '안녕하세요',
          ),
          Example(
            korean: '도와주셔서 감사합니다.',
            vietnamese: 'Cảm ơn bạn đã giúp đỡ.',
            highlightWord: '감사합니다',
          ),
          Example(
            korean: '늦어서 죄송합니다.',
            vietnamese: 'Xin lỗi vì đến muộn.',
            highlightWord: '죄송합니다',
          ),
          Example(
            korean: '네, 알겠습니다.',
            vietnamese: 'Vâng, tôi hiểu rồi.',
            highlightWord: '네',
          ),
          Example(
            korean: '아니요, 괜찮아요.',
            vietnamese: 'Không, không sao đâu.',
            highlightWord: '아니요',
          ),
        ],
        story: '''민준: 안녕하세요! 저는 민준입니다.
수아: 안녕하세요! 반가워요.
민준: 커피 드릴까요?
수아: 네, 감사합니다!
민준: 설탕 넣을까요?
수아: 아니요, 괜찮아요.
민준: 앗, 커피를 쏟았어요. 죄송합니다!
수아: 아니요, 괜찮아요!''',
        storyTranslation: '''Minjun: Xin chào! Tôi là Minjun.
Sua: Xin chào! Rất vui được gặp.
Minjun: Bạn uống cà phê nhé?
Sua: Vâng, cảm ơn!
Minjun: Cho đường vào nhé?
Sua: Không, không cần đâu.
Minjun: Ôi, tôi làm đổ cà phê rồi. Xin lỗi!
Sua: Không, không sao đâu!''',
        questions: const [
          Question(
            type: QuestionType.multipleChoice,
            question: '안녕하세요',
            options: ['Xin chào', 'Tạm biệt', 'Cảm ơn', 'Xin lỗi'],
            correctAnswer: 'Xin chào',
          ),
          Question(
            type: QuestionType.multipleChoice,
            question: '감사합니다',
            options: ['Xin lỗi', 'Cảm ơn', 'Xin chào', 'Không'],
            correctAnswer: 'Cảm ơn',
          ),
          Question(
            type: QuestionType.fillBlank,
            question: '___ (Xin lỗi vì đến muộn)',
            options: ['죄송합니다'],
            correctAnswer: '죄송합니다',
            hint: 'joesonghamnida',
          ),
        ],
      ),
      Lesson(
        id: 'greetings_2',
        topicId: 'greetings',
        name: 'Tạm biệt và Hỏi thăm',
        lessonNumber: 2,
        words: const [
          Word(
            korean: '안녕히 가세요',
            vietnamese: 'Tạm biệt (người đi)',
            romanization: 'annyeonghi gaseyo',
          ),
          Word(
            korean: '안녕히 계세요',
            vietnamese: 'Tạm biệt (người ở)',
            romanization: 'annyeonghi gyeseyo',
          ),
          Word(
            korean: '어떻게 지내세요?',
            vietnamese: 'Bạn khỏe không?',
            romanization: 'eotteoke jinaeseyo?',
          ),
          Word(
            korean: '잘 지내요',
            vietnamese: 'Tôi khỏe',
            romanization: 'jal jinaeyo',
          ),
          Word(
            korean: '또 만나요',
            vietnamese: 'Hẹn gặp lại',
            romanization: 'tto mannayo',
          ),
        ],
        examples: const [
          Example(
            korean: '수업 끝났어요. 안녕히 가세요!',
            vietnamese: 'Lớp học kết thúc rồi. Tạm biệt!',
            highlightWord: '안녕히 가세요',
          ),
          Example(
            korean: '저 먼저 갈게요. 안녕히 계세요!',
            vietnamese: 'Tôi đi trước nhé. Tạm biệt!',
            highlightWord: '안녕히 계세요',
          ),
          Example(
            korean: '오랜만이에요! 어떻게 지내세요?',
            vietnamese: 'Lâu quá không gặp! Bạn khỏe không?',
            highlightWord: '어떻게 지내세요?',
          ),
          Example(
            korean: '저는 잘 지내요, 감사합니다.',
            vietnamese: 'Tôi khỏe, cảm ơn bạn.',
            highlightWord: '잘 지내요',
          ),
          Example(
            korean: '오늘 재밌었어요. 또 만나요!',
            vietnamese: 'Hôm nay vui quá. Hẹn gặp lại!',
            highlightWord: '또 만나요',
          ),
        ],
        story: '''수아: 안녕하세요! 어떻게 지내세요?
민준: 잘 지내요, 감사합니다! 수아씨는요?
수아: 저도 잘 지내요!
민준: 좋아요! 이제 저 가야 해요.
수아: 네, 안녕히 가세요!
민준: 안녕히 계세요! 또 만나요!''',
        storyTranslation: '''Sua: Xin chào! Bạn khỏe không?
Minjun: Tôi khỏe, cảm ơn! Còn Sua?
Sua: Tôi cũng khỏe!
Minjun: Tốt! Giờ tôi phải đi rồi.
Sua: Vâng, tạm biệt!
Minjun: Tạm biệt! Hẹn gặp lại!''',
        questions: const [
          Question(
            type: QuestionType.multipleChoice,
            question: '안녕히 가세요',
            options: [
              'Tạm biệt (người đi)',
              'Tạm biệt (người ở)',
              'Xin chào',
              'Hẹn gặp lại',
            ],
            correctAnswer: 'Tạm biệt (người đi)',
          ),
          Question(
            type: QuestionType.multipleChoice,
            question: '어떻게 지내세요?',
            options: [
              'Bạn khỏe không?',
              'Bạn đi đâu?',
              'Bạn tên gì?',
              'Bạn bao nhiêu tuổi?',
            ],
            correctAnswer: 'Bạn khỏe không?',
          ),
        ],
      ),
    ],
  ),

  // ===== CHỦ ĐỀ 2: GIA ĐÌNH =====
  Topic(
    id: 'family',
    name: 'Gia đình',
    koreanName: '가족',
    description: 'Học các từ vựng về gia đình',
    emoji: '👨‍👩‍👧‍👦',
    lessons: [
      Lesson(
        id: 'family_1',
        topicId: 'family',
        name: 'Thành viên gia đình',
        lessonNumber: 1,
        words: const [
          Word(korean: '아버지', vietnamese: 'Bố', romanization: 'abeoji'),
          Word(korean: '어머니', vietnamese: 'Mẹ', romanization: 'eomeoni'),
          Word(
            korean: '형',
            vietnamese: 'Anh trai (nam gọi)',
            romanization: 'hyeong',
          ),
          Word(
            korean: '누나',
            vietnamese: 'Chị gái (nam gọi)',
            romanization: 'nuna',
          ),
          Word(
            korean: '동생',
            vietnamese: 'Em (trai/gái)',
            romanization: 'dongsaeng',
          ),
        ],
        examples: const [
          Example(
            korean: '제 아버지는 의사예요.',
            vietnamese: 'Bố tôi là bác sĩ.',
            highlightWord: '아버지',
          ),
          Example(
            korean: '어머니가 요리를 해요.',
            vietnamese: 'Mẹ đang nấu ăn.',
            highlightWord: '어머니',
          ),
          Example(
            korean: '형이 축구를 좋아해요.',
            vietnamese: 'Anh trai thích bóng đá.',
            highlightWord: '형',
          ),
          Example(
            korean: '누나는 대학생이에요.',
            vietnamese: 'Chị gái là sinh viên đại học.',
            highlightWord: '누나',
          ),
          Example(
            korean: '동생이 귀여워요.',
            vietnamese: 'Em rất dễ thương.',
            highlightWord: '동생',
          ),
        ],
        story: '''민준: 우리 가족을 소개할게요!
민준: 아버지는 회사원이에요.
민준: 어머니는 선생님이에요.
민준: 형은 대학생이에요.
민준: 누나는 고등학생이에요.
민준: 그리고 저는 동생이에요!''',
        storyTranslation: '''Minjun: Tôi sẽ giới thiệu gia đình mình!
Minjun: Bố là nhân viên công ty.
Minjun: Mẹ là giáo viên.
Minjun: Anh trai là sinh viên đại học.
Minjun: Chị gái là học sinh cấp 3.
Minjun: Còn tôi là em út!''',
        questions: const [
          Question(
            type: QuestionType.multipleChoice,
            question: '아버지',
            options: ['Bố', 'Mẹ', 'Anh', 'Em'],
            correctAnswer: 'Bố',
          ),
          Question(
            type: QuestionType.multipleChoice,
            question: '어머니',
            options: ['Bố', 'Mẹ', 'Chị', 'Em'],
            correctAnswer: 'Mẹ',
          ),
        ],
      ),
    ],
  ),

  // ===== CHỦ ĐỀ 3: THỨC ĂN =====
  Topic(
    id: 'food',
    name: 'Thức ăn',
    koreanName: '음식',
    description: 'Học các từ vựng về đồ ăn Hàn Quốc',
    emoji: '🍜',
    lessons: [
      Lesson(
        id: 'food_1',
        topicId: 'food',
        name: 'Món ăn phổ biến',
        lessonNumber: 1,
        words: const [
          Word(korean: '김치', vietnamese: 'Kim chi', romanization: 'gimchi'),
          Word(korean: '밥', vietnamese: 'Cơm', romanization: 'bap'),
          Word(
            korean: '불고기',
            vietnamese: 'Thịt nướng Bulgogi',
            romanization: 'bulgogi',
          ),
          Word(
            korean: '비빔밥',
            vietnamese: 'Cơm trộn Bibimbap',
            romanization: 'bibimbap',
          ),
          Word(korean: '라면', vietnamese: 'Mì ramen', romanization: 'ramyeon'),
        ],
        examples: const [
          Example(
            korean: '김치가 너무 매워요.',
            vietnamese: 'Kim chi rất cay.',
            highlightWord: '김치',
          ),
          Example(
            korean: '밥 먹었어요?',
            vietnamese: 'Bạn ăn cơm chưa?',
            highlightWord: '밥',
          ),
          Example(
            korean: '불고기 한 인분 주세요.',
            vietnamese: 'Cho tôi một phần Bulgogi.',
            highlightWord: '불고기',
          ),
          Example(
            korean: '비빔밥은 건강해요.',
            vietnamese: 'Bibimbap tốt cho sức khỏe.',
            highlightWord: '비빔밥',
          ),
          Example(
            korean: '라면 끓여줄까요?',
            vietnamese: 'Tôi nấu mì cho bạn nhé?',
            highlightWord: '라면',
          ),
        ],
        story: '''웨이터: 어서오세요! 뭐 드시겠어요?
민준: 비빔밥 하나 주세요.
수아: 저는 불고기요!
웨이터: 밥은 어떻게 해드릴까요?
민준: 많이 주세요!
웨이터: 김치도 드릴까요?
수아: 네, 김치 좋아해요!
민준: 저도요! 그리고 라면도 하나 추가요!''',
        storyTranslation: '''Phục vụ: Xin mời vào! Quý khách dùng gì ạ?
Minjun: Cho tôi một phần bibimbap.
Sua: Tôi lấy bulgogi!
Phục vụ: Cơm như thế nào ạ?
Minjun: Nhiều vào ạ!
Phục vụ: Cho kim chi luôn không ạ?
Sua: Vâng, tôi thích kim chi!
Minjun: Tôi cũng vậy! Và thêm một tô mì nữa!''',
        questions: const [
          Question(
            type: QuestionType.multipleChoice,
            question: '김치',
            options: ['Kim chi', 'Cơm', 'Mì', 'Thịt nướng'],
            correctAnswer: 'Kim chi',
          ),
          Question(
            type: QuestionType.multipleChoice,
            question: '밥',
            options: ['Mì', 'Cơm', 'Bánh', 'Canh'],
            correctAnswer: 'Cơm',
          ),
          Question(
            type: QuestionType.fillBlank,
            question: '___ 먹었어요? (Bạn ăn ___ chưa?)',
            options: ['밥'],
            correctAnswer: '밥',
            hint: 'bap - cơm',
          ),
        ],
      ),
    ],
  ),
];
