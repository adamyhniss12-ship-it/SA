import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'places_screen.dart';
import 'quiz_screen.dart';
import 'rating_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  void _initializeVideo() async {
    _controller = VideoPlayerController.asset('assets/videos/mm.mp4');

    try {
      await _controller.initialize();
      // التحقق من أن المستخدم لا يزال في الصفحة قبل تشغيل الفيديو أو تحديث الواجهة
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
        await _controller.setLooping(true);
        await _controller
            .setVolume(0); // كتم الصوت مهم جداً لضمان التشغيل التلقائي
        await _controller.play();
      }
    } catch (e) {
      debugPrint("خطأ في تهيئة الفيديو: $e");
    }
  }

  @override
  void dispose() {
    // يجب إيقاف الفيديو وتفريغ الذاكرة فوراً عند إغلاق الصفحة
    _controller.pause();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: const Color(0xFF8B4513),
        title:
            const Text('Jordan Journey', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // قسم الفيديو
            Container(
              width: double.infinity,
              height: 250,
              color: Colors.black,
              child: _isInitialized
                  ? AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    )
                  : const Center(
                      child: CircularProgressIndicator(color: Colors.white)),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text(
                    'اكتشف جمال الأردن',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF8B4513)),
                  ),
                  const SizedBox(height: 30),
                  _buildMenuButton(
                      context,
                      'المعالم السياحية',
                      const Color(0xFF8B4513),
                      () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PlacesScreen()))),
                  const SizedBox(height: 15),
                  _buildMenuButton(
                      context,
                      'اختبر معلوماتك',
                      const Color(0xFF4CAF50),
                      () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const QuizScreen()))),
                  const SizedBox(height: 15),
                  _buildMenuButton(
                      context,
                      'قيّم التطبيق',
                      const Color(0xFF2196F3),
                      () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RatingScreen()))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton(
      BuildContext context, String title, Color color, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: onPressed,
        child: Text(title,
            style: const TextStyle(color: Colors.white, fontSize: 18)),
      ),
    );
  }
}
