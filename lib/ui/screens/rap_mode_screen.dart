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
  final _itemPositionsListener = ItemPositionsListener.create();
  AudioPlayer? _player;
  StreamSubscription<Duration>? _positionSub;
  StreamSubscription<PlayerState>? _playerStateSub;
  String? _loadedAudioPath;
  int? _lastScrolledIndex;
  int? _currentLineIndex;
  bool _controlsVisible = true;

  Timer? _virtualClockTimer;
  Duration _virtualPosition = Duration.zero;
  bool _virtualPlaying = false;

  @override
  void initState() {
    super.initState();
    WakelockPlus.enable();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    _positionSub?.cancel();
    _playerStateSub?.cancel();
    _player?.dispose();
    _virtualClockTimer?.cancel();
    WakelockPlus.disable();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  /// Without an audio file, timecodes still exist (Phase 3 supports placing
  /// them manually), so auto-scroll falls back to a plain elapsed-time
  /// clock instead of a real playback position.
  void _toggleVirtualClock() {
    setState(() => _virtualPlaying = !_virtualPlaying);
    if (_virtualPlaying) {
      _virtualClockTimer = Timer.periodic(const Duration(milliseconds: 200), (
        _,
      ) {
        final lignes = ref.read(lignesForProjetProvider(widget.projetId)).value;
        final endMs = _lastTimecodeMs(lignes);
        var nextMs = _virtualPosition.inMilliseconds + 200;

        if (endMs != null && nextMs >= endMs) {
          if (ref.read(rapModeLoopProvider)) {
            nextMs = _firstTimecodeMs(lignes) ?? 0;
          } else {
            _virtualPosition = Duration(milliseconds: endMs);
            _onPosition(_virtualPosition);
            _virtualClockTimer?.cancel();
            if (mounted) setState(() => _virtualPlaying = false);
            return;
          }
        }
        _virtualPosition = Duration(milliseconds: nextMs);
        _onPosition(_virtualPosition);
      });
    } else {
      _virtualClockTimer?.cancel();
    }
  }

  void _toggleLoop() {
    ref.read(rapModeLoopProvider.notifier).toggle();
    final loop = ref.read(rapModeLoopProvider);
    _player?.setLoopMode(loop ? LoopMode.one : LoopMode.off);
  }

  /// Jumps playback (or the virtual clock) straight to a line's timecode.
  /// Lines without a timecode aren't seekable targets.
  void _seekTo(int? timecodeMs) {
    if (timecodeMs == null) return;
    final position = Duration(milliseconds: timecodeMs);
    if (_player != null) {
      _player!.seek(position);
    } else {
      _virtualPosition = position;
      _onPosition(position);
    }
  }

  Future<void> _ensurePlayerLoaded(Audio audio) async {
    if (_loadedAudioPath == audio.cheminLocal) return;
    _loadedAudioPath = audio.cheminLocal;
    final player = _player ??= AudioPlayer();
    await player.setLoopMode(
      ref.read(rapModeLoopProvider) ? LoopMode.one : LoopMode.off,
    );
    await player.setFilePath(audio.cheminLocal);
    unawaited(_positionSub?.cancel());
    _positionSub = player.positionStream.listen(_onPosition);
    unawaited(_playerStateSub?.cancel());
    _playerStateSub = player.playerStateStream.listen(_onPlayerState);
  }

  void _onPlayerState(PlayerState state) {
    if (state.processingState == ProcessingState.completed &&
        !ref.read(rapModeLoopProvider)) {
      _player?.pause();
    }
  }

  void _onPosition(Duration position) {
    if (!mounted) return;
    ref.read(audioPositionProvider.notifier).set(position);
    final lignes = ref.read(lignesForProjetProvider(widget.projetId)).value;
    if (lignes == null) return;
    final index = _activeIndex(lignes, position.inMilliseconds);
    if (index != -1 && index != _currentLineIndex) {
      setState(() => _currentLineIndex = index);
    }

    if (ref.read(rapModeSubModeProvider) != RapModeSubMode.auto) return;
    if (index == -1 || index == _lastScrolledIndex) return;
    _lastScrolledIndex = index;
    if (!_itemScrollController.isAttached) return;
    if (_isFullyVisible(index)) return;
    _itemScrollController.scrollTo(
      index: index,
      duration: const Duration(milliseconds: 300),
      alignment: 0.4,
    );
  }

  /// Avoids animating a scroll when the target line is already fully on
  /// screen (e.g. a short project where every line already fits).
  bool _isFullyVisible(int index) {
    return _itemPositionsListener.itemPositions.value.any(
      (p) =>
          p.index == index && p.itemLeadingEdge >= 0 && p.itemTrailingEdge <= 1,
    );
  }

  int _activeIndex(List<Ligne> lignes, int positionMs) {
    var active = -1;
    for (var i = 0; i < lignes.length; i++) {
      final timecodeMs = lignes[i].timecodeMs;
      if (timecodeMs != null && timecodeMs <= positionMs) active = i;
    }
    return active;
  }

  int? _lastTimecodeMs(List<Ligne>? lignes) {
    if (lignes == null) return null;
    int? last;
    for (final ligne in lignes) {
      final timecodeMs = ligne.timecodeMs;
      if (timecodeMs != null && (last == null || timecodeMs > last)) {
        last = timecodeMs;
      }
    }
    return last;
  }

  int? _firstTimecodeMs(List<Ligne>? lignes) {
    if (lignes == null) return null;
    int? first;
    for (final ligne in lignes) {
      final timecodeMs = ligne.timecodeMs;
      if (timecodeMs != null && (first == null || timecodeMs < first)) {
        first = timecodeMs;
      }
    }
    return first;
  }

  @override
  Widget build(BuildContext context) {
    final lignesAsync = ref.watch(lignesForProjetProvider(widget.projetId));
    final audio = ref.watch(audioForProjetProvider(widget.projetId)).value;
    final subMode = ref.watch(rapModeSubModeProvider);
    final fontSize = ref.watch(rapModeFontSizeProvider);
    final loop = ref.watch(rapModeLoopProvider);

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
                        itemPositionsListener: _itemPositionsListener,
                        padding: const EdgeInsets.fromLTRB(16, 140, 16, 96),
                        itemCount: lignes.length,
                        itemBuilder: (context, index) {
                          final ligne = lignes[index];
                          final isCurrent = index == _currentLineIndex;
                          return GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () => _seekTo(ligne.timecodeMs),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: AnimatedDefaultTextStyle(
                                duration: const Duration(milliseconds: 250),
                                curve: Curves.easeOut,
                                style: TextStyle(
                                  color: isCurrent
                                      ? Colors.white
                                      : Colors.white38,
                                  fontSize: fontSize,
                                  fontWeight: FontWeight.w600,
                                  height: 1.4,
                                  // A glow instead of a background pill, like
                                  // a karaoke-style highlight (YouTube
                                  // Music): shadows always present so the
                                  // style interpolates smoothly, fading via
                                  // alpha/blur rather than popping in.
                                  shadows: [
                                    Shadow(
                                      color: Colors.deepPurpleAccent.withValues(
                                        alpha: isCurrent ? 0.85 : 0,
                                      ),
                                      blurRadius: isCurrent ? 26 : 0,
                                    ),
                                    Shadow(
                                      color: Colors.white.withValues(
                                        alpha: isCurrent ? 0.55 : 0,
                                      ),
                                      blurRadius: isCurrent ? 14 : 0,
                                    ),
                                  ],
                                ),
                                child: Text(ligne.texte),
                              ),
                            ),
                          );
                        },
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
                    loop: loop,
                    onToggleLoop: _toggleLoop,
                    player: audio != null ? _player : null,
                    virtualPlaying: _virtualPlaying,
                    onToggleVirtualClock: _toggleVirtualClock,
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
    required this.loop,
    required this.onToggleLoop,
    required this.player,
    required this.virtualPlaying,
    required this.onToggleVirtualClock,
    required this.onExit,
  });

  final RapModeSubMode subMode;
  final double fontSize;
  final bool loop;
  final VoidCallback onToggleLoop;
  final AudioPlayer? player;
  final bool virtualPlaying;
  final VoidCallback onToggleVirtualClock;
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
                icon: Icon(
                  Icons.repeat,
                  color: loop ? Colors.deepPurpleAccent : Colors.white,
                ),
                tooltip: loop
                    ? 'Loop on (tap to disable)'
                    : 'Loop off (tap to enable)',
                onPressed: onToggleLoop,
              ),
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
        Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: player != null
              ? StreamBuilder<bool>(
                  stream: player!.playingStream,
                  builder: (context, snapshot) {
                    final playing = snapshot.data ?? false;
                    return IconButton.filled(
                      iconSize: 40,
                      icon: Icon(playing ? Icons.pause : Icons.play_arrow),
                      onPressed: () =>
                          playing ? player!.pause() : player!.play(),
                    );
                  },
                )
              : IconButton.filled(
                  iconSize: 40,
                  tooltip: virtualPlaying
                      ? 'Pause the timer-based auto-scroll'
                      : 'Start timer-based auto-scroll (no audio file)',
                  icon: Icon(virtualPlaying ? Icons.pause : Icons.play_arrow),
                  onPressed: onToggleVirtualClock,
                ),
        ),
      ],
    );
  }
}
