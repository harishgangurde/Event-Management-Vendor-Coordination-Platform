// lib/services/gemini_service.dart

import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  // YOUR API KEY
  static const String _apiKey = 'AIzaSyBbjoVMZ4-VTZolz7zTw_gLSerd4Af_NaM';

  late final GenerativeModel _model;
  late final ChatSession _chat;

  GeminiService() {
    // 💡 FINAL FIX: Pass the system instruction string directly to the GenerativeModel
    // This bypasses the potentially missing parameter in the GenerationConfig.
    _model = GenerativeModel(
      model: 'gemini-2.5-flash',
      apiKey: _apiKey,

      // Use the correct parameter for the system instruction, which must be a Content object.
      // NOTE: If the analyzer still complains about 'systemInstruction',
      // replace the parameter name 'systemInstruction' with just 'config' and try again.
      systemInstruction: Content.system(
        "You are Eventtoria AI, a professional, creative, and extremely helpful event planning assistant. Your purpose is to provide specific, actionable suggestions for event logistics, vendor sourcing, budget optimization, and creative themes. Always be polite, encouraging, and stay focused on event planning topics.",
      ),

      // We no longer need the GenerationConfig object itself:
      // config: GenerationConfig( ... )
    );

    _chat = _model.startChat();
  }

  Stream<String> sendMessageStream(String message) {
    return _chat
        .sendMessageStream(Content.text(message))
        .map((chunk) => chunk.text ?? '');
  }
}
