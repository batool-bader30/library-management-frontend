import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatService {
  final String _apiKey = "AIzaSyAWBLtHrWIn-RH5tWxRAblJOa_q9OOPdJw";

Stream<String> getAIStreamResponse(String userInput) async* {
  // استخدام v1beta مع streamGenerateContent و alt=sse هو المفتاح
  final url = Uri.parse(
    'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:streamGenerateContent?alt=sse&key=$_apiKey'
  );

  final client = http.Client();
  final request = http.Request("POST", url);
  request.headers['Content-Type'] = 'application/json';
  request.body = jsonEncode({
    "contents": [
      {
        "parts": [{"text": "أنت مساعد مكتبة ذكي لمشروع ReadHub. جاوب بعدة اسطر بدون تفاصيل كثير : $userInput"}]
      }
    ]
  });

  try {
    final response = await client.send(request);
    
    // فك التشفير تدريجياً
    await for (final chunk in response.stream.transform(utf8.decoder)) {
      // الـ SSE بتبعت البيانات بتبدأ بكلمة "data: "
      final lines = chunk.split('\n');
      for (var line in lines) {
        if (line.startsWith('data: ')) {
          final jsonString = line.substring(6);
          if (jsonString.trim() == '[DONE]') break; // نهاية البث
          
          final data = jsonDecode(jsonString);
          if (data['candidates'] != null) {
            final text = data['candidates'][0]['content']['parts'][0]['text'];
            yield text;
          }
        }
      }
    }
  } finally {
    client.close();
  }
}
}