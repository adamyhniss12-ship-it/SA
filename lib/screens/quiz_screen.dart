import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  // مشغل الصوت
  AudioPlayer audioPlayer = AudioPlayer();

  // الأسئلة
  final List<Map<String, dynamic>> questions = [
    {
      'question': 'أين تقع مدينة البتراء الأثرية؟',
      'image': 'assets/images/petra.jpg',
      'options': [
        'محافظة معان',
        'محافظة الزرقاء',
        'محافظة إربد',
        'محافظة عجلون'
      ],
      'correct': 0,
    },
    {
      'question': 'ما هو البحر الميت؟',
      'image': 'assets/images/dead_sea.jpg',
      'options': [
        'أعلى نقطة على الأرض',
        'أخفض نقطة على الأرض',
        'أكبر بحيرة في آسيا',
        'أعمق بحر في العالم',
      ],
      'correct': 1,
    },
    {
      'question': 'بماذا يُعرف وادي رم؟',
      'image': 'assets/images/wadi_rum.jpg',
      'options': ['وادي النخيل', 'وادي القمر', 'وادي النجوم', 'وادي الذهب'],
      'correct': 1,
    },
    {
      'question': 'في أي قرن بُنيت قلعة الكرك؟',
      'image': 'assets/images/karak_castle.jpg',
      'options': [
        'القرن العاشر',
        'القرن الثاني عشر',
        'القرن الخامس عشر',
        'القرن السابع',
      ],
      'correct': 1,
    },
    {
      'question': 'بماذا تشتهر مدينة جرش؟',
      'image': 'assets/images/jerash.jpg',
      'options': [
        'المعابد الفرعونية',
        'الأسواق الإسلامية',
        'الآثار الرومانية',
        'القلاع الصليبية',
      ],
      'correct': 2,
    },
  ];

  int currentQuestion = 0; // رقم السؤال الحالي
  int score = 0; // النتيجة
  int? selectedAnswer; // الإجابة المختارة
  bool answered = false; // هل أجاب المستخدم؟
  bool quizFinished = false; // هل انتهى الاختبار؟

  // دالة تشغيل الصوت
  void playSound(bool isCorrect) async {
    if (isCorrect) {
      await audioPlayer.play(AssetSource('audio/correct.mp3'));
    } else {
      await audioPlayer.play(AssetSource('audio/wrong.mp3'));
    }
  }

  // دالة عند اختيار إجابة
  void selectAnswer(int index) {
    if (answered) return; // لو أجاب بالفعل لا تغير

    bool isCorrect = index == questions[currentQuestion]['correct'];

    setState(() {
      selectedAnswer = index;
      answered = true;
      if (isCorrect) score++;
    });

    // شغّل الصوت
    playSound(isCorrect);
  }

  // دالة السؤال التالي
  void nextQuestion() {
    if (currentQuestion < questions.length - 1) {
      setState(() {
        currentQuestion++;
        selectedAnswer = null;
        answered = false;
      });
    } else {
      setState(() {
        quizFinished = true;
      });
    }
  }

  // دالة إعادة الاختبار
  void restartQuiz() {
    setState(() {
      currentQuestion = 0;
      score = 0;
      selectedAnswer = null;
      answered = false;
      quizFinished = false;
    });
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (quizFinished) {
      return buildResultScreen();
    }
    return buildQuizScreen();
  }

  // شاشة الاختبار
  Widget buildQuizScreen() {
    Map<String, dynamic> q = questions[currentQuestion];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF4CAF50),
        title: Text(
          'السؤال ${currentQuestion + 1} من ${questions.length}',
          style: const TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // النتيجة الحالية
            Text(
              'النتيجة: $score',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            const SizedBox(height: 10),

            // صورة السؤال
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                q['image'],
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),

            // نص السؤال
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                q['question'],
                textAlign: TextAlign.right,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),

            // الخيارات
            ...List.generate(q['options'].length, (index) {
              return buildOptionButton(
                  index, q['options'][index], q['correct']);
            }),

            const SizedBox(height: 16),

            // زر التالي (يظهر فقط بعد الإجابة)
            if (answered)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: nextQuestion,
                child: Text(
                  currentQuestion < questions.length - 1
                      ? 'السؤال التالي'
                      : 'عرض النتيجة',
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // زر الخيار
  Widget buildOptionButton(int index, String text, int correctIndex) {
    Color buttonColor = Colors.white;
    Color textColor = Colors.black;

    if (answered) {
      if (index == correctIndex) {
        // الإجابة الصحيحة = أخضر
        buttonColor = Colors.green[100]!;
        textColor = Colors.green[800]!;
      } else if (index == selectedAnswer) {
        // الإجابة الخاطئة المختارة = أحمر
        buttonColor = Colors.red[100]!;
        textColor = Colors.red[800]!;
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          foregroundColor: textColor,
          side: BorderSide(color: Colors.grey[300]!),
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        onPressed: () => selectAnswer(index),
        child: Text(
          text,
          textAlign: TextAlign.right,
          style: const TextStyle(fontSize: 15),
        ),
      ),
    );
  }

  // شاشة النتيجة النهائية
  Widget buildResultScreen() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF4CAF50),
        title: const Text('النتيجة', style: TextStyle(color: Colors.white)),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.emoji_events, size: 80, color: Colors.amber),
              const SizedBox(height: 20),
              const Text(
                'انتهى الاختبار!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                'نتيجتك: $score من ${questions.length}',
                style: TextStyle(fontSize: 20, color: Colors.grey[700]),
              ),
              const SizedBox(height: 40),
              // زر إعادة الاختبار
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF50),
                  ),
                  onPressed: restartQuiz,
                  child: const Text(
                    'إعادة الاختبار',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // زر الرجوع
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'الرجوع للرئيسية',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
