import 'package:flutter/material.dart';

class PlacesScreen extends StatelessWidget {
  final List<Map<String, String>> places = [
    {
      'name': 'البتراء',
      'image': 'assets/images/petra.jpg',
      'location': 'محافظة معان - جنوب الأردن',
      'description':
          'البتراء مدينة أثرية منحوتة في الصخر الوردي. كانت عاصمة مملكة الأنباط. تُعدّ من عجائب الدنيا السبع الجديدة وموقع تراث عالمي لليونسكو.',
    },
    {
      'name': 'البحر الميت',
      'image': 'assets/images/dead_sea.jpg',
      'location': 'غور الأردن - غرب الأردن',
      'description':
          'البحر الميت هو أخفض نقطة على سطح الأرض. ملوحته عالية جداً لدرجة أنك تطفو على سطحه تلقائياً. طينه مفيد جداً للبشرة.',
    },
    {
      'name': 'وادي رم',
      'image': 'assets/images/wadi_rum.jpg',
      'location': 'محافظة العقبة - جنوب الأردن',
      'description':
          'وادي رم يُعرف بـ وادي القمر لمشاهده الصحراوية الرائعة. يتميز بالجبال الرملية الحمراء الضخمة. استُخدم كخلفية لأفلام عالمية مشهورة.',
    },
    {
      'name': 'قلعة الكرك',
      'image': 'assets/images/karak_castle.jpg',
      'location': 'مدينة الكرك - وسط الأردن',
      'description':
          'قلعة الكرك قلعة صليبية بُنيت في القرن الثاني عشر. تقع على هضبة مرتفعة وتطل على البحر الميت. تُعدّ من أكبر القلاع في الشرق الأوسط.',
    },
    {
      'name': 'جرش',
      'image': 'assets/images/jerash.jpg',
      'location': 'محافظة جرش - شمال الأردن',
      'description':
          'جرش مدينة أثرية رومانية محفوظة بشكل ممتاز. تضم معابد ومسارح وأعمدة رومانية رائعة. تُعدّ من أفضل المواقع الرومانية خارج إيطاليا.',
    },
  ];

  PlacesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF8B4513),
        centerTitle: true,
        title: const Text(
          'المعالم السياحية',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Directionality( // لضمان اتجاه النص من اليمين لليسار في كل الشاشة
        textDirection: TextDirection.rtl,
        child: ListView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: places.length,
          itemBuilder: (context, index) {
            return _buildPlaceCard(context, places[index]);
          },
        ),
      ),
    );
  }

  Widget _buildPlaceCard(BuildContext context, Map<String, String> place) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch, // التمدد لملء العرض
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.asset(
              place['image']!,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  place['name']!,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF8B4513),
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.grey, size: 16),
                    const SizedBox(width: 5),
                    Expanded( // يمنع خروج النص عن الشاشة إذا كان اسم الموقع طويلاً
                      child: Text(
                        place['location']!,
                        style: const TextStyle(color: Colors.grey, fontSize: 14),
                        overflow: TextOverflow.ellipsis, // يضع نقاط إذا طال النص جداً
                      ),
                    ),
                  ],
                ),
                const Divider(height: 20),
                Text(
                  place['description']!,
                  style: const TextStyle(
                    fontSize: 15,
                    height: 1.6, // تباعد الأسطر يجعل القراءة أسهل على الموبايل
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.justify, // توزيع النص بشكل متناسق
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}