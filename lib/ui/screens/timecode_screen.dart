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

class _NoAudioView extends ConsumerStatefulWidget {
  const _NoAudioView({required this.projetId, required this.lignes});

  final int projetId;
  final List<Ligne> lignes;

  @override
  ConsumerState<_NoAudioView> createState() => _NoAudioViewState();
}

class _NoAudioViewState extends ConsumerState<_NoAudioView> {
  final _stopwatch = Stopwatch();
  Timer? _ticker;
  Duration _elapsed = Duration.zero;
  bool _importing = false;

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

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

  void _toggleStopwatch() {
    setState(() {
      if (_stopwatch.isRunning) {
        _stopwatch.stop();
        _ticker?.cancel();
      } else {
        _stopwatch.start();
        _ticker = Timer.periodic(const Duration(milliseconds: 100), (_) {
          setState(() => _elapsed = _stopwatch.elapsed);
        });
      }
    });
  }

  void _markLine(int ligneId) {
    ref
        .read(lignesControllerProvider)
        .updateTimecode(ligneId, _stopwatch.elapsed.inMilliseconds);
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
                'No audio yet — mark lines manually using the timer below.',
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _formatDuration(_elapsed),
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(width: 16),
                  FilledButton.tonalIcon(
                    onPressed: _toggleStopwatch,
                    icon: Icon(
                      _stopwatch.isRunning ? Icons.pause : Icons.play_arrow,
                    ),
                    label: Text(
                      _stopwatch.isRunning ? 'Pause timer' : 'Start timer',
                    ),
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
                  tooltip: 'Mark at current time',
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
  static const _itemExtent = 64.0;

  late final AudioPlayer _player;
  final _waveformExtractor = WaveformExtractor();
  final _scrollController = ScrollController();
  StreamSubscription<Duration>? _positionSub;
  Waveform? _waveform;
  Duration _position = Duration.zero;
  int _lastScrolledIndex = -1;

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
      _syncScroll(position);
    });
    final waveform = await _waveformExtractor.extract(widget.audio.cheminLocal);
    if (mounted) setState(() => _waveform = waveform);
  }

  void _syncScroll(Duration position) {
    if (!_scrollController.hasClients) return;
    final index = _currentLineIndex(position);
    if (index == null || index == _lastScrolledIndex) return;
    _lastScrolledIndex = index;
    _scrollController.animateTo(
      index * _itemExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  int? _currentLineIndex(Duration position) {
    int? best;
    for (var i = 0; i < widget.lignes.length; i++) {
      final ms = widget.lignes[i].timecodeMs;
      if (ms != null && ms <= position.inMilliseconds) best = i;
    }
    return best;
  }

  @override
  void dispose() {
    _positionSub?.cancel();
    _player.dispose();
    _scrollController.dispose();
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
            controller: _scrollController,
            itemExtent: _itemExtent,
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
                  tooltip: 'Mark at current time',
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
