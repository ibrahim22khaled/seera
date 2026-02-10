import 'dart:convert';
import 'package:http/http.dart' as http;

abstract class ChatService {
  Future<String> sendMessage(String message, List<String> history);
  Future<String> generateCV(List<String> history);
}

class GroqService implements ChatService {
  final String apiKey;
  final String model;
  final String systemPrompt;

  GroqService({
    required this.apiKey,
    this.model = 'llama-3.3-70b-versatile',
    required this.systemPrompt,
  });

  @override
  Future<String> sendMessage(String message, List<String> history) async {
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
        'Authorization': 'Bearer $apiKey',
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
      "targetCountry": "الدولة المستهدفة للعمل",
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
      "languages": [
        {
          "name": "اللغة",
          "level": "المستوى"
        }
      ],
      "attachments": []
    }
    
    ملاحظات هامة:
    - إذا لم يذكر المستخدم "الملخص المهني" أو "المهارات" في المحادثة، اتركهم فارغين (سيقوم بإضافتهم لاحقاً).
    - استخرج أي روابط أو ملفات ذكرها المستخدم بعد كل خبرة عملية وضعها في قائمة "portfolioItems" الخاصة بتلك الخبرة.
    ''';

    final response = await http.post(
      Uri.parse('https://api.groq.com/openai/v1/chat/completions'),
      headers: {
        'Authorization': 'Bearer $apiKey',
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

class OpenRouterService implements ChatService {
  final String apiKey;
  final String model;
  final String systemPrompt;

  OpenRouterService({
    required this.apiKey,
    this.model =
        'google/gemini-2.0-flash-lite-preview-02-05:free', // Using a reliable free model
    required this.systemPrompt,
  });

  @override
  Future<String> sendMessage(String message, List<String> history) async {
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
      Uri.parse('https://openrouter.ai/api/v1/chat/completions'),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
        'HTTP-Referer': 'https://seera.app', // Optional for OpenRouter
        'X-Title': 'Seera App',
      },
      body: jsonEncode({'model': model, 'messages': messages}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      return data['choices'][0]['message']['content'];
    } else {
      throw Exception(
        'OpenRouter Error: ${response.statusCode} - ${response.body}',
      );
    }
  }

  @override
  Future<String> generateCV(List<String> history) async {
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
      "targetCountry": "الدولة المستهدفة للعمل",
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
      "languages": [
        {
          "name": "اللغة",
          "level": "المستوى"
        }
      ],
      "attachments": []
    }
    
    ملاحظات هامة:
    - إذا لم يذكر المستخدم "الملخص المهني" أو "المهارات" في المحادثة، اتركهم فارغين (سيقوم بإضافتهم لاحقاً).
    - استخرج أي روابط أو ملفات ذكرها المستخدم بعد كل خبرة عملية وضعها في قائمة "portfolioItems" الخاصة بتلك الخبرة.
    ''';

    final response = await http.post(
      Uri.parse('https://openrouter.ai/api/v1/chat/completions'),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'model': model,
        'messages': [
          {'role': 'user', 'content': prompt},
        ],
        'response_format': {'type': 'json_object'},
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      return data['choices'][0]['message']['content'];
    } else {
      throw Exception('OpenRouter Error: ${response.statusCode}');
    }
  }
}

class HuggingFaceService implements ChatService {
  final String apiKey;
  final String model;
  final String systemPrompt;

  HuggingFaceService({
    required this.apiKey,
    this.model = 'meta-llama/Llama-3.2-3B-Instruct', // Good free chat model
    required this.systemPrompt,
  });

  @override
  Future<String> sendMessage(String message, List<String> history) async {
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
      Uri.parse(
        'https://router.huggingface.co/hf-inference/v1/chat/completions',
      ),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'model': model,
        'messages': messages,
        'parameters': {'max_new_tokens': 500, 'return_full_text': false},
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      return data['choices'][0]['message']['content'];
    } else {
      throw Exception(
        'Hugging Face Error: ${response.statusCode} - ${response.body}',
      );
    }
  }

  @override
  Future<String> generateCV(List<String> history) async {
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
      "targetCountry": "الدولة المستهدفة للعمل",
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
      "languages": [
        {
          "name": "اللغة",
          "level": "المستوى"
        }
      ],
      "attachments": []
    }
    
    ملاحظات هامة:
    - إذا لم يذكر المستخدم "الملخص المهني" أو "المهارات" في المحادثة، اتركهم فارغين (سيقوم بإضافتهم لاحقاً).
    - استخرج أي روابط أو ملفات ذكرها المستخدم بعد كل خبرة عملية وضعها في قائمة "portfolioItems" الخاصة بتلك الخبرة.
    ''';

    final response = await http.post(
      Uri.parse(
        'https://router.huggingface.co/hf-inference/v1/chat/completions',
      ),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'model': model,
        'messages': [
          {'role': 'user', 'content': prompt},
        ],
        'response_format': {'type': 'json_object'},
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      return data['choices'][0]['message']['content'];
    } else {
      throw Exception('Hugging Face Error: ${response.statusCode}');
    }
  }
}

class FallbackChatService implements ChatService {
  final List<ChatService> services;
  int _currentServiceIndex = 0;

  FallbackChatService({required this.services}) : assert(services.isNotEmpty);

  ChatService get _currentService => services[_currentServiceIndex];

  @override
  Future<String> sendMessage(String message, List<String> history) async {
    final List<String> errors = [];
    for (int i = 0; i < services.length; i++) {
      try {
        return await _currentService.sendMessage(message, history);
      } catch (e) {
        errors.add('Service ${i + 1} (${_currentService.runtimeType}): $e');
        _switchToNextService();
      }
    }
    throw Exception('كل خدمات الذكاء الاصطناعي فشلت:\n${errors.join('\n')}');
  }

  @override
  Future<String> generateCV(List<String> history) async {
    final List<String> errors = [];
    for (int i = 0; i < services.length; i++) {
      try {
        return await _currentService.generateCV(history);
      } catch (e) {
        errors.add('Service ${i + 1} (${_currentService.runtimeType}): $e');
        _switchToNextService();
      }
    }
    throw Exception('كل خدمات الذكاء الاصطناعي فشلت:\n${errors.join('\n')}');
  }

  void _switchToNextService() {
    _currentServiceIndex = (_currentServiceIndex + 1) % services.length;
  }
}
