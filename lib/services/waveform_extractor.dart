import 'dart:io';

import 'package:just_waveform/just_waveform.dart';

class WaveformExtractor {
  /// Extracts a [Waveform] from the audio file at [audioPath], caching the
  /// result next to it so repeated visits don't re-decode the whole file.
  Future<Waveform> extract(String audioPath) async {
    final waveFile = File('$audioPath.wave');
    if (await waveFile.exists()) {
      return JustWaveform.parse(waveFile);
    }
    final progress = JustWaveform.extract(
      audioInFile: File(audioPath),
      waveOutFile: waveFile,
    );
    final completed = await progress.firstWhere((p) => p.waveform != null);
    return completed.waveform!;
  }
}
