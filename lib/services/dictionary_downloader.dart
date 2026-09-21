import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import 'dictionary_source.dart';

typedef DownloadProgress = void Function(int received, int? total);

class DictionaryDownloader {
  /// Downloads [source] into the app's documents directory and returns the
  /// local file. If it was already downloaded, returns the cached file
  /// without re-fetching, so the dictionary works fully offline afterward.
  Future<File> ensureDownloaded(
    DictionarySource source, {
    DownloadProgress? onProgress,
  }) async {
    final file = await _localFile(source);
    if (await file.exists()) return file;
    return _download(source, file, onProgress);
  }

  Future<File> _download(
    DictionarySource source,
    File file,
    DownloadProgress? onProgress,
  ) async {
    final tempFile = File('${file.path}.part');
    final request = http.Request('GET', source.url);
    final response = await request.send();

    var received = 0;
    final sink = tempFile.openWrite();
    await for (final chunk in response.stream) {
      sink.add(chunk);
      received += chunk.length;
      onProgress?.call(received, response.contentLength);
    }
    await sink.close();
    return tempFile.rename(file.path);
  }

  Future<File> _localFile(DictionarySource source) async {
    final dir = await getApplicationDocumentsDirectory();
    final dictionariesDir = Directory('${dir.path}/dictionaries');
    await dictionariesDir.create(recursive: true);
    return File('${dictionariesDir.path}/${source.fileName}');
  }
}
