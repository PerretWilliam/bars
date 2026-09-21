/// Lexique's phonetic alphabet: one character per phoneme. Oral vowels plus
/// the schwa and the four nasal vowels (an/on/in/un), confirmed against
/// Lexique383 sample entries (e.g. "blanc" -> "bl@", "bon" -> "b§",
/// "matin" -> "mat5", "brun" -> "bR1", "le" -> "l°").
const _lexiqueVowels = {
  'a',
  'e',
  'E',
  'i',
  'o',
  'O',
  'u',
  'y',
  '2',
  '9',
  '°',
  '@',
  '§',
  '5',
  '1',
};

/// The true rime of a French word: from its last vowel sound to the end.
/// French word stress is regularly on the final syllable, so the last vowel
/// approximates the last stressed vowel.
String? rimeKeyFr(String phon) {
  for (var i = phon.length - 1; i >= 0; i--) {
    if (_lexiqueVowels.contains(phon[i])) {
      return phon.substring(i);
    }
  }
  return null;
}

/// CMU ARPAbet vowel phonemes carry a trailing stress digit (0 = none,
/// 1 = primary, 2 = secondary), e.g. "EY1", "AH0".
final _arpabetStressDigit = RegExp(r'[012]$');
final _arpabetVowel = RegExp(r'^[A-Z]+[012]$');

/// The true rime of an English word: from its primary-stressed vowel to the
/// end, falling back to the last vowel when no phoneme carries primary
/// stress. Stress digits are stripped from the key so secondary-stress
/// differences don't block an otherwise-matching rhyme.
String? rimeKeyEn(List<String> phonemes) {
  var vowelIndex = phonemes.indexWhere(
    (p) => _arpabetVowel.hasMatch(p) && p.endsWith('1'),
  );
  if (vowelIndex == -1) {
    vowelIndex = phonemes.lastIndexWhere((p) => _arpabetVowel.hasMatch(p));
  }
  if (vowelIndex == -1) return null;
  return phonemes
      .sublist(vowelIndex)
      .map((p) => p.replaceFirst(_arpabetStressDigit, ''))
      .join(' ');
}
