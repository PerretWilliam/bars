import 'package:flutter_test/flutter_test.dart';
import 'package:lyrics/services/rime_key.dart';

void main() {
  group('rimeKeyFr', () {
    test('words sharing a final nasal vowel rhyme', () {
      expect(rimeKeyFr('mEz§'), '§'); // maison
      expect(rimeKeyFr('S@s§'), '§'); // chanson
    });

    test('includes the coda consonant after the vowel', () {
      expect(rimeKeyFr('bl@'), '@'); // blanc
    });

    test('returns null when there is no vowel', () {
      expect(rimeKeyFr(''), isNull);
    });
  });

  group('rimeKeyEn', () {
    test('uses the primary-stressed vowel onward', () {
      // nation: N EY1 SH AH0 N, station: S T EY1 SH AH0 N
      expect(rimeKeyEn(['N', 'EY1', 'SH', 'AH0', 'N']), 'EY SH AH N');
      expect(rimeKeyEn(['S', 'T', 'EY1', 'SH', 'AH0', 'N']), 'EY SH AH N');
    });

    test('falls back to the last vowel when no primary stress exists', () {
      expect(rimeKeyEn(['AH0', 'M']), 'AH M');
    });

    test('returns null when there is no vowel phoneme', () {
      expect(rimeKeyEn(['S', 'T']), isNull);
    });
  });
}
