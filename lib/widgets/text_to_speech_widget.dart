import 'package:speech_to_text/speech_to_text.dart';

class SpeechApi {
  static final _speech = SpeechToText();

  static Future<bool> startRecording({
    required Function(String text, double confidence) onResult,
    required Function(String text) statusChange,
  }) async {
    final micAvailable =
        await _speech.initialize(onStatus: (status) => statusChange(status));

    if (micAvailable) {
      _speech.listen(
          onResult: (value) =>
              onResult(value.recognizedWords, value.confidence));
    }
    return micAvailable;
  }
}
