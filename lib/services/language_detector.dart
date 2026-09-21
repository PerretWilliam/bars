import 'package:flutter_langdetect/flutter_langdetect.dart' as langdetect;

/// Wraps flutter_langdetect: short lines don't carry enough signal for a
/// reliable guess, and the underlying detector throws on them.
const _minWordsForDetection = 3;

class LanguageDetector {
  static Future<void> init() => langdetect.initLangDetect();

  static String? detect(String text) {
    final wordCount = text
        .trim()
        .split(RegExp(r'\s+'))
        .where((w) => w.isNotEmpty)
        .length;
    if (wordCount < _minWordsForDetection) return null;
    try {
      return langdetect.detect(text);
    } catch (_) {
      return null;
    }
  }
}
