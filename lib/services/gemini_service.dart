import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_web/config/api_keys.dart';

class GeminiService {
  static const String _apiKey = ApiKeys.geminiApiKey;
  static const String _model = 'gemini-flash-latest';
  static const String _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/$_model:generateContent';

  // Firestore REST API
  static const String _firestoreProject = 'tolgatokcom';
  static const String _firestoreUrl =
      'https://firestore.googleapis.com/v1/projects/$_firestoreProject/databases/(default)/documents/ai_questions';

  // Rate limiting
  final List<DateTime> _requestTimes = [];
  static const int _maxRequestsPerMinute = 5;

  static const String _systemPrompt = '''
Sen Tolga Tok'un kişisel portfolyo web sitesindeki yapay zeka asistanısın.
Bu site bir macOS masaüstü simülasyonu olarak Flutter Web ile geliştirilmiştir.

Tolga hakkında bilgiler:
- İsim: Tolga Tok
- Rol: AI ve Mobil Geliştirici
- Yetenekler: Flutter, Dart, Firebase, REST API, Git, UI/UX, Makine Öğrenmesi, Pandas, NumPy
- İlgi alanları: Yapay zeka, makine öğrenmesi, veri bilimi, mobil uygulama geliştirme
- Flutter ile son kullanıcı için mobil uygulamalar geliştiriyor
- Kalan zamanlarında AI/ML ve veri odaklı sistemler üzerine kendini geliştiriyor
- Şu anda Erkpa Gıda Dış Ticaret A.ş de çalışmakta.
''';

  Future<String> ask(String question) async {
    // Rate limiting kontrolü
    final now = DateTime.now();
    _requestTimes.removeWhere((time) => now.difference(time).inSeconds > 60);

    if (_requestTimes.length >= _maxRequestsPerMinute) {
      return 'Hata: Çok fazla istek gönderildi. Lütfen biraz bekleyin.';
    }

    _requestTimes.add(now);

    // Soruyu Firestore'a kaydet (arka planda)
    _saveQuestion(question);

    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'X-goog-api-key': _apiKey,
        },
        body: jsonEncode({
          'system_instruction': {
            'parts': [
              {'text': _systemPrompt},
            ],
          },
          'contents': [
            {
              'parts': [
                {'text': question},
              ],
            },
          ],
          'generationConfig': {'maxOutputTokens': 1024, 'temperature': 0.7},
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final text = data['candidates']?[0]?['content']?['parts']?[0]?['text'];
        return text ?? 'Yanıt alınamadı.';
      } else {
        final error = jsonDecode(response.body);
        final msg = error['error']?['message'] ?? 'Bilinmeyen hata';
        return 'API Hatası [${response.statusCode}]: $msg';
      }
    } catch (e) {
      return 'Bağlantı hatası: $e';
    }
  }

  Future<void> _saveQuestion(String question) async {
    try {
      await http.post(
        Uri.parse(_firestoreUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'fields': {
            'question': {'stringValue': question},
            'timestamp': {'timestampValue': DateTime.now().toUtc().toIso8601String()},
          },
        }),
      );
    } catch (_) {
      // Kayıt başarısız olursa sessizce devam et
    }
  }
}
