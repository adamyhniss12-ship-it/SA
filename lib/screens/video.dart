import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoHeader extends StatefulWidget {
  const VideoHeader({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _VideoHeaderState createState() => _VideoHeaderState();
}

class _VideoHeaderState extends State<VideoHeader> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    // ضع رابط الفيديو الخاص بك هنا
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(
          'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'),
    )..initialize().then((_) {
        setState(() {}); // لتحديث الشاشة بعد تحميل الفيديو
        _controller.setLooping(true); // تكرار الفيديو
        _controller.play(); // تشغيل تلقائي
        _controller.setVolume(0);
      });
  }

  @override
  void dispose() {
    _controller.dispose(); // تنظيف الذاكرة
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          )
        // ignore: sized_box_for_whitespace
        : Container(
            height: 200,
            child: const Center(child: CircularProgressIndicator()), // مؤشر تحميل
          );
  }
}
