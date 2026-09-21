import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class AudioFileManager {
  /// Copies [sourcePath] into the app's documents directory (under an
  /// `audio` subfolder) so the project's audio survives independently of
  /// wherever the user originally picked it from, and returns the copy.
  Future<File> copyIntoAppStorage(String sourcePath) async {
    final dir = await getApplicationDocumentsDirectory();
    final audioDir = Directory(p.join(dir.path, 'audio'));
    await audioDir.create(recursive: true);
    final destination = File(
      p.join(
        audioDir.path,
        '${DateTime.now().microsecondsSinceEpoch}_${p.basename(sourcePath)}',
      ),
    );
    return File(sourcePath).copy(destination.path);
  }
}
