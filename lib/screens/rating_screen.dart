import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class RatingScreen extends StatelessWidget {
  // رابط نموذج التقييم
  final String formUrl =
      'https://docs.google.com/forms/d/e/1FAIpQLSdUYnrRaFCPjyAgUNCgUEhRjkjmbV2A8MnjXWX2SQ8gVhPDog/viewform?usp=publish-editor';

  const RatingScreen({super.key});

  // دالة فتح الرابط
  void openForm(BuildContext context) async {
    Uri url = Uri.parse(formUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تعذر فتح الرابط')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF2196F3),
        title: const Text(
          'قيّم التطبيق',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // أيقونة
              const Icon(Icons.star, size: 80, color: Colors.amber),
              const SizedBox(height: 20),
              // عنوان
              const Text(
                'رأيك يهمنا!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              // وصف
              Text(
                'اضغط على الزر أدناه لفتح نموذج التقييم وتقييم تجربتك مع التطبيق',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: Colors.grey[600]),
              ),
              const SizedBox(height: 40),
              // زر فتح النموذج
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2196F3),
                  ),
                  onPressed: () => openForm(context),
                  child: const Text(
                    'افتح نموذج التقييم',
                    style: TextStyle(color: Colors.white, fontSize: 18),
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
