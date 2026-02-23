import 'dart:convert';
import 'package:http/http.dart' as http;

abstract class ChatService {
  Future<String> sendMessage(String message, List<String> history);
  Future<String> generateCV(List<String> history);
}

class GroqService implements ChatService {
  // We use String.fromEnvironment to read the key injected during build.
  // This value is never in the source code.
  static const String _apiKey = String.fromEnvironment('GROQ_API_KEY');

  final String systemPrompt;
  final String model;

  GroqService({
    required this.systemPrompt,
    this.model = 'llama-3.3-70b-versatile',
  });

  @override
  Future<String> sendMessage(String message, List<String> history) async {
    if (_apiKey.isEmpty) {
      throw Exception(
        'Groq API Key identifies as empty. Did you build with --dart-define=GROQ_API_KEY=your_key?',
      );
    }

    final List<Map<String, String>> messages = [
      {'role': 'system', 'content': systemPrompt},
    ];

    for (var msg in history) {
      if (msg.startsWith('You: ')) {
        messages.add({
          'role': 'user',
          'content': msg.replaceFirst('You: ', ''),
        });
      } else if (msg.startsWith('AI: ')) {
        messages.add({
          'role': 'assistant',
          'content': msg.replaceFirst('AI: ', ''),
        });
      }
    }

    messages.add({'role': 'user', 'content': message});

    final response = await http.post(
      Uri.parse('https://api.groq.com/openai/v1/chat/completions'),
      headers: {
        'Authorization': 'Bearer $_apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'model': model, 'messages': messages}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      return data['choices'][0]['message']['content'];
    } else {
      throw Exception('Groq Error: ${response.statusCode} - ${response.body}');
    }
  }

  @override
  Future<String> generateCV(List<String> history) async {
    if (_apiKey.isEmpty) {
      throw Exception('Groq API Key identifies as empty.');
    }

    final historyPrompt = history.join('\n');
    final prompt =
        '''
    بناءً على المحادثة دي:
    $historyPrompt
    
    طلعلي البيانات في شكل JSON بالظبط زي الفورمات ده، وماتتكلمش ولا كلمة زيادة:
    
    {
      "fullName": "الاسم",
      "email": "البريد الإلكتروني",
      "phone": "رقم التليفون",
      "country": "الدولة",
      "city": "المدينة",
      "jobTitle": "المسمى الوظيفي الحالي",
      "linkedin": "رابط لينكد إن",
      "github": "رابط جيت هاب",
      "summary": "ملخص احترافي",
      "skills": ["مهارة 1", "مهارة 2"],
      "experience": [
        {
          "company": "اسم الشركة",
          "role": "الدور",
          "duration": "المدة",
          "description": "الوصف",
          "portfolioItems": ["رابط 1", "رابط 2"]
        }
      ],
      "education": [
        {
          "degree": "الدرجة العلمية",
          "institution": "المؤسسة التعليمية",
          "dateRange": "الفترة الزمنية"
        }
      ],
      "languages": [
        {
          "name": "اللغة",
          "level": "المستوى"
        }
      ],
      "projects": []
    }
    
    ملاحظات هامة:
    - إذا لم يذكر المستخدم "الملخص المهني" أو "المهارات" في المحادثة، اتركهم فارغين (سيقوم بإضافتهم لاحقاً).
    - استخرج أي روابط أو ملفات ذكرها المستخدم بعد كل خبرة عملية وضعها في قائمة "portfolioItems" الخاصة بتلك الخبرة.
    - استخرج أي روابط مشاريع عامة وضعها في قائمة "projects" ككائنات تحتوي على (title, role, urls, description).
    ''';

    final response = await http.post(
      Uri.parse('https://api.groq.com/openai/v1/chat/completions'),
      headers: {
        'Authorization': 'Bearer $_apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'model': model,
        'messages': [
          {
            'role': 'system',
            'content': 'You are a helpful assistant that outputs JSON only.',
          },
          {'role': 'user', 'content': prompt},
        ],
        'response_format': {'type': 'json_object'},
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      return data['choices'][0]['message']['content'];
    } else {
      throw Exception('Groq Error: ${response.statusCode}');
    }
  }
}
