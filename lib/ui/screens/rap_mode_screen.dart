import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../data/app_database.dart';
import '../../providers/audio_provider.dart';
import '../../providers/lignes_provider.dart';
import '../../providers/rap_mode_provider.dart';

class RapModeScreen extends ConsumerStatefulWidget {
  const RapModeScreen({required this.projetId, super.key});

  final int projetId;

  @override
  ConsumerState<RapModeScreen> createState() => _RapModeScreenState();
}

class _RapModeScreenState extends ConsumerState<RapModeScreen> {
  final _itemScrollController = ItemScrollController();
  AudioPlayer? _player;
  StreamSubscription<Duration>? _positionSub;
  String? _loadedAudioPath;
  int? _lastScrolledIndex;
  bool _controlsVisible = true;

  @override
  void initState() {
    super.initState();
    WakelockPlus.enable();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    _positionSub?.cancel();
    _player?.dispose();
    WakelockPlus.disable();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  Future<void> _ensurePlayerLoaded(Audio audio) async {
    if (_loadedAudioPath == audio.cheminLocal) return;
    _loadedAudioPath = audio.cheminLocal;
    final player = _player ??= AudioPlayer();
    await player.setFilePath(audio.cheminLocal);
    unawaited(_positionSub?.cancel());
    _positionSub = player.positionStream.listen(_onPosition);
  }

  void _onPosition(Duration position) {
    ref.read(audioPositionProvider.notifier).set(position);
    if (ref.read(rapModeSubModeProvider) != RapModeSubMode.auto) return;
    final lignes = ref.read(lignesForProjetProvider(widget.projetId)).value;
    if (lignes == null) return;
    final index = _activeIndex(lignes, position.inMilliseconds);
    if (index == -1 || index == _lastScrolledIndex) return;
    _lastScrolledIndex = index;
    if (_itemScrollController.isAttached) {
      _itemScrollController.scrollTo(
        index: index,
        duration: const Duration(milliseconds: 300),
        alignment: 0.4,
      );
    }
  }

  int _activeIndex(List<Ligne> lignes, int positionMs) {
    var active = -1;
    for (var i = 0; i < lignes.length; i++) {
      final timecodeMs = lignes[i].timecodeMs;
      if (timecodeMs != null && timecodeMs <= positionMs) active = i;
    }
    return active;
  }

  @override
  Widget build(BuildContext context) {
    final lignesAsync = ref.watch(lignesForProjetProvider(widget.projetId));
    final audio = ref.watch(audioForProjetProvider(widget.projetId)).value;
    final subMode = ref.watch(rapModeSubModeProvider);
    final fontSize = ref.watch(rapModeFontSizeProvider);

    if (audio != null) {
      unawaited(_ensurePlayerLoaded(audio));
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () => setState(() => _controlsVisible = !_controlsVisible),
        child: Stack(
          children: [
            Positioned.fill(
              child: lignesAsync.when(
                data: (lignes) => lignes.isEmpty
                    ? const Center(
                        child: Text(
                          'No lines yet',
                          style: TextStyle(color: Colors.white54),
                        ),
                      )
                    : ScrollablePositionedList.builder(
                        itemScrollController: _itemScrollController,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 96,
                        ),
                        itemCount: lignes.length,
                        itemBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            lignes[index].texte,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: fontSize,
                              fontWeight: FontWeight.w500,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stackTrace) => Center(
                  child: Text(
                    'Something went wrong: $error',
                    style: const TextStyle(color: Colors.white54),
                  ),
                ),
              ),
            ),
            AnimatedOpacity(
              opacity: _controlsVisible ? 1 : 0,
              duration: const Duration(milliseconds: 200),
              child: IgnorePointer(
                ignoring: !_controlsVisible,
                child: SafeArea(
                  child: _RapModeControls(
                    subMode: subMode,
                    fontSize: fontSize,
                    player: audio != null ? _player : null,
                    onExit: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RapModeControls extends ConsumerWidget {
  const _RapModeControls({
    required this.subMode,
    required this.fontSize,
    required this.player,
    required this.onExit,
  });

  final RapModeSubMode subMode;
  final double fontSize;
  final AudioPlayer? player;
  final VoidCallback onExit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: onExit,
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.text_decrease, color: Colors.white),
                onPressed: () =>
                    ref.read(rapModeFontSizeProvider.notifier).decrease(),
              ),
              IconButton(
                icon: const Icon(Icons.text_increase, color: Colors.white),
                onPressed: () =>
                    ref.read(rapModeFontSizeProvider.notifier).increase(),
              ),
              IconButton(
                icon: Icon(
                  subMode == RapModeSubMode.auto
                      ? Icons.sync
                      : Icons.pan_tool_alt_outlined,
                  color: Colors.white,
                ),
                tooltip: subMode == RapModeSubMode.auto
                    ? 'Auto-scroll (tap to switch to manual)'
                    : 'Manual scroll (tap to switch to auto)',
                onPressed: () =>
                    ref.read(rapModeSubModeProvider.notifier).toggle(),
              ),
            ],
          ),
        ),
        if (player != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: StreamBuilder<bool>(
              stream: player!.playingStream,
              builder: (context, snapshot) {
                final playing = snapshot.data ?? false;
                return IconButton.filled(
                  iconSize: 40,
                  icon: Icon(playing ? Icons.pause : Icons.play_arrow),
                  onPressed: () => playing ? player!.pause() : player!.play(),
                );
              },
            ),
          ),
      ],
    );
  }
}
