enum DictionaryLanguage { fr, en }

class DictionarySource {
  const DictionarySource({
    required this.language,
    required this.url,
    required this.fileName,
  });

  final DictionaryLanguage language;
  final Uri url;
  final String fileName;
}

/// Official upstream sources, fetched on demand rather than bundled: this
/// keeps the app small and avoids redistributing third-party data ourselves,
/// while still letting the rhyme dictionaries be cached locally for offline
/// use once downloaded.
final dictionarySources = {
  DictionaryLanguage.fr: DictionarySource(
    language: DictionaryLanguage.fr,
    url: Uri.parse(
      'http://www.lexique.org/databases/Lexique383/Lexique383.tsv',
    ),
    fileName: 'lexique383.tsv',
  ),
  DictionaryLanguage.en: DictionarySource(
    language: DictionaryLanguage.en,
    url: Uri.parse(
      'https://raw.githubusercontent.com/cmusphinx/cmudict/master/cmudict.dict',
    ),
    fileName: 'cmudict.dict',
  ),
};
