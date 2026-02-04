import 'package:google_generative_ai/google_generative_ai.dart';
import 'ai_service.dart';

class GeminiService implements ChatService {
  final GenerativeModel _model;
  final String systemPrompt;

  GeminiService({
    required String apiKey,
    required this.systemPrompt,
    String modelName = 'gemini-1.5-flash-latest',
  }) : _model = GenerativeModel(model: modelName, apiKey: apiKey);

  List<Content> _mapHistoryToContent(List<String> history) {
    final List<Content> contents = [Content.system(systemPrompt)];

    for (var msg in history) {
      if (msg.startsWith('You: ')) {
        contents.add(Content.text(msg.replaceFirst('You: ', '')));
      } else if (msg.startsWith('AI: ')) {
        contents.add(Content.model([TextPart(msg.replaceFirst('AI: ', ''))]));
      }
    }
    return contents;
  }

  @override
  Future<String> sendMessage(String message, List<String> history) async {
    final contents = _mapHistoryToContent(history);
    contents.add(Content.text(message));

    final response = await _model.generateContent(contents);
    if (response.text == null) {
      throw Exception('Gemini returned empty response');
    }
    return response.text!;
  }

  @override
  Future<String> generateCV(List<String> history) async {
    final historyPrompt = history.join('\n');
    final prompt =
        '''
      بناءً على المحادثة دي:
      $historyPrompt
      
      طلعلي البيانات في شكل JSON بالظبط زي الفورمات ده، وماتتكلمش ولا كلمة زيادة.
      
      {
        "fullName": "الاسم",
        "phone": "رقم التليفون",
        "jobTitle": "المسمى الوظيفي",
        "summary": "ملخص احترافي عني",
        "skills": ["مهارة 1", "مهارة 2"],
        "experience": [
          {
            "company": "اسم الشركة",
            "role": "الدور",
            "duration": "المدة",
            "description": "الوصف"
          }
        ]
      }
      ''';

    final response = await _model.generateContent([
      Content.system('You are a helpful assistant that outputs JSON only.'),
      Content.text(prompt),
    ]);
    if (response.text == null) {
      throw Exception('Gemini returned empty response for CV');
    }
    return response.text!;
  }
}
