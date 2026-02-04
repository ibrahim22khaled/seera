import 'ai_service.dart';

class MockGeminiService implements ChatService {
  int _messageCount = 0;

  @override
  Future<String> sendMessage(String message, List<String> history) async {
    await Future.delayed(const Duration(milliseconds: 500));

    _messageCount++;

    // Simulate conversation flow
    if (_messageCount == 1) {
      return 'أهلاً بيك يا بطل في سيرة! أنا معاك عشان نكتب الـ CV بتاعك. الأول قولي، تحب أناديك بإسم إيه؟';
    } else if (_messageCount == 2) {
      return 'تمام يا $message! إيه رقم التليفون بتاعك؟';
    } else if (_messageCount == 3) {
      return 'ممتاز! دلوقتي قولي، انت بتشتغل إيه؟ يعني المسمى الوظيفي إيه؟';
    } else if (_messageCount == 4) {
      return 'جميل! عندك مهارات إيه في الشغل ده؟';
    } else if (_messageCount == 5) {
      return 'رائع! اشتغلت فين قبل كده؟ قولي عن آخر شركة أو مكان شغل.';
    } else {
      return 'تمام يا ريس! لو خلصت، اضغط على زرار الطباعة فوق عشان نطلع الـ CV.';
    }
  }

  @override
  Future<String> generateCV(List<String> history) async {
    await Future.delayed(const Duration(milliseconds: 500));

    // Return mock JSON data
    return '''
{
  "fullName": "أحمد محمد علي",
  "phone": "01012345678",
  "jobTitle": "سائق محترف",
  "summary": "سائق محترف بخبرة 5 سنوات في قيادة السيارات الخاصة والنقل الخفيف. ملتزم بمواعيد العمل ولدي معرفة جيدة بطرق القاهرة والجيزة.",
  "skills": [
    "قيادة السيارات الخاصة",
    "معرفة جيدة بالطرق",
    "الالتزام بالمواعيد",
    "صيانة بسيطة للسيارات"
  ],
  "experience": [
    {
      "company": "شركة النقل السريع",
      "role": "سائق",
      "duration": "2019 - 2024",
      "description": "قيادة سيارات نقل البضائع الخفيفة وتوصيل الطلبات للعملاء في مواعيدها"
    },
    {
      "company": "مكتب المهندس خالد",
      "role": "سائق خاص",
      "duration": "2017 - 2019",
      "description": "سائق خاص للمهندس خالد وعائلته مع الالتزام الكامل بالمواعيد"
    }
  ]
}
''';
  }
}
