import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_waveform/just_waveform.dart';

import '../../data/app_database.dart';
import '../../providers/audio_provider.dart';
import '../../providers/lignes_provider.dart';
import '../../services/waveform_extractor.dart';
import '../widgets/waveform_view.dart';

class TimecodeScreen extends ConsumerWidget {
  const TimecodeScreen({required this.projetId, super.key});

  final int projetId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioAsync = ref.watch(audioForProjetProvider(projetId));
    final lignesAsync = ref.watch(lignesForProjetProvider(projetId));

    return Scaffold(
      appBar: AppBar(title: const Text('Timecodes')),
      body: lignesAsync.when(
        data: (lignes) => audioAsync.when(
          data: (audio) => audio == null
              ? _NoAudioView(projetId: projetId, lignes: lignes)
              : _PlaybackSection(
                  projetId: projetId,
                  audio: audio,
                  lignes: lignes,
                ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) =>
              Center(child: Text('Something went wrong: $error')),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) =>
            Center(child: Text('Something went wrong: $error')),
      ),
    );
  }
}

String _formatDuration(Duration d) {
  final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
  final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
  return '$minutes:$seconds';
}

/// Parses a `mm:ss` or plain-seconds string into milliseconds, or null if
/// [input] isn't a valid non-negative timecode.
int? _parseTimecode(String input) {
  final parts = input.trim().split(':');
  if (parts.isEmpty || parts.length > 2) return null;
  final numbers = parts.map(int.tryParse).toList();
  if (numbers.contains(null)) return null;
  final seconds = parts.length == 2
      ? numbers[0]! * 60 + numbers[1]!
      : numbers[0]!;
  if (seconds < 0) return null;
  return seconds * 1000;
}

Future<void> _editTimecode(
  BuildContext context,
  WidgetRef ref,
  int ligneId,
  int? currentMs,
) async {
  final controller = TextEditingController(
    text: currentMs == null
        ? ''
        : _formatDuration(Duration(milliseconds: currentMs)),
  );
  final result = await showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Set timecode'),
      content: TextField(
        controller: controller,
        autofocus: true,
        decoration: const InputDecoration(hintText: 'mm:ss'),
      ),
      actions: [
        if (currentMs != null)
          TextButton(
            onPressed: () => Navigator.pop(context, ''),
            child: const Text('Clear'),
          ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, controller.text),
          child: const Text('Save'),
        ),
      ],
    ),
  );
  if (result == null) return;

  final controllerRef = ref.read(lignesControllerProvider);
  if (result.isEmpty) {
    await controllerRef.updateTimecode(ligneId, null);
    return;
  }
  final ms = _parseTimecode(result);
  if (ms == null) return;
  await controllerRef.updateTimecode(ligneId, ms);
}

class _NoAudioView extends ConsumerStatefulWidget {
  const _NoAudioView({required this.projetId, required this.lignes});

  final int projetId;
  final List<Ligne> lignes;

  @override
  ConsumerState<_NoAudioView> createState() => _NoAudioViewState();
}

class _NoAudioViewState extends ConsumerState<_NoAudioView> {
  bool _importing = false;

  Future<void> _pickAndImport() async {
    final files = await FilePicker.pickFiles(type: FileType.audio);
    if (files.isEmpty) return;
    final path = files.single.path;
    if (path == null) return;

    setState(() => _importing = true);
    try {
      await ref
          .read(audioControllerProvider)
          .importAudio(widget.projetId, path);
    } finally {
      if (mounted) setState(() => _importing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              FilledButton.icon(
                onPressed: _importing ? null : _pickAndImport,
                icon: _importing
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.audio_file_outlined),
                label: const Text('Import audio file'),
              ),
              const SizedBox(height: 8),
              Text(
                'No audio yet — tap a line below to set its timecode manually.',
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: ListView.builder(
            itemCount: widget.lignes.length,
            itemBuilder: (context, index) {
              final ligne = widget.lignes[index];
              return ListTile(
                title: Text(ligne.texte.isEmpty ? '(empty line)' : ligne.texte),
                subtitle: ligne.timecodeMs == null
                    ? null
                    : Text(
                        _formatDuration(
                          Duration(milliseconds: ligne.timecodeMs!),
                        ),
                      ),
                trailing: IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  tooltip: 'Set timecode',
                  onPressed: () =>
                      _editTimecode(context, ref, ligne.id, ligne.timecodeMs),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _PlaybackSection extends ConsumerStatefulWidget {
  const _PlaybackSection({
    required this.projetId,
    required this.audio,
    required this.lignes,
  });

  final int projetId;
  final Audio audio;
  final List<Ligne> lignes;

  @override
  ConsumerState<_PlaybackSection> createState() => _PlaybackSectionState();
}

class _PlaybackSectionState extends ConsumerState<_PlaybackSection> {
  late final AudioPlayer _player;
  final _waveformExtractor = WaveformExtractor();
  StreamSubscription<Duration>? _positionSub;
  Waveform? _waveform;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _loadAudio();
  }

  @override
  void didUpdateWidget(covariant _PlaybackSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.audio.cheminLocal != widget.audio.cheminLocal) {
      _loadAudio();
    }
  }

  Future<void> _loadAudio() async {
    await _player.setFilePath(widget.audio.cheminLocal);
    unawaited(_positionSub?.cancel());
    _positionSub = _player.positionStream.listen((position) {
      if (!mounted) return;
      setState(() => _position = position);
    });
    final waveform = await _waveformExtractor.extract(widget.audio.cheminLocal);
    if (mounted) setState(() => _waveform = waveform);
  }

  @override
  void dispose() {
    _positionSub?.cancel();
    _player.dispose();
    super.dispose();
  }

  void _markLine(int ligneId) {
    ref
        .read(lignesControllerProvider)
        .updateTimecode(ligneId, _position.inMilliseconds);
  }

  Future<void> _removeAudio() async {
    await _player.stop();
    await ref.read(audioControllerProvider).removeAudio(widget.projetId);
  }

  @override
  Widget build(BuildContext context) {
    final waveform = _waveform;
    final totalDuration = Duration(milliseconds: widget.audio.dureeMs);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              SizedBox(
                height: 80,
                child: waveform == null
                    ? const Center(child: CircularProgressIndicator())
                    : WaveformView(
                        waveform: waveform,
                        position: _position,
                        duration: totalDuration,
                        onSeek: _player.seek,
                      ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StreamBuilder<bool>(
                    stream: _player.playingStream,
                    builder: (context, snapshot) {
                      final playing = snapshot.data ?? false;
                      return IconButton.filled(
                        icon: Icon(playing ? Icons.pause : Icons.play_arrow),
                        onPressed: () =>
                            playing ? _player.pause() : _player.play(),
                      );
                    },
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '${_formatDuration(_position)} / ${_formatDuration(totalDuration)}',
                  ),
                  const SizedBox(width: 12),
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    tooltip: 'Remove audio',
                    onPressed: _removeAudio,
                  ),
                ],
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: ListView.builder(
            itemCount: widget.lignes.length,
            itemBuilder: (context, index) {
              final ligne = widget.lignes[index];
              return ListTile(
                title: Text(ligne.texte.isEmpty ? '(empty line)' : ligne.texte),
                subtitle: ligne.timecodeMs == null
                    ? null
                    : Text(
                        _formatDuration(
                          Duration(milliseconds: ligne.timecodeMs!),
                        ),
                      ),
                trailing: IconButton(
                  icon: const Icon(Icons.flag_outlined),
                  tooltip: 'Mark at current playback time',
                  onPressed: () => _markLine(ligne.id),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
