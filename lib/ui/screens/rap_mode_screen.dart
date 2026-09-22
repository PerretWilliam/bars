import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../data/app_database.dart';
import '../../l10n/app_localizations.dart';
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
    // Always re-center on the current line rather than only scrolling once
    // it's fully off-screen, so it stays in the same spot as playback
    // advances instead of drifting toward the viewport's edge.
    _itemScrollController.scrollTo(
      index: index,
      duration: const Duration(milliseconds: 300),
      alignment: 0.45,
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
    final l10n = AppLocalizations.of(context)!;
    final lignesAsync = ref.watch(lignesForProjetProvider(widget.projetId));
    final audio = ref.watch(audioForProjetProvider(widget.projetId)).value;
    final subMode = ref.watch(rapModeSubModeProvider);
    final fontSize = ref.watch(rapModeFontSizeProvider);
    final loop = ref.watch(rapModeLoopProvider);
    final positionMs = ref.watch(audioPositionProvider).inMilliseconds;

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
                    ? Center(
                        child: Text(
                          l10n.noLinesYetPreview,
                          style: const TextStyle(color: Colors.white54),
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
                          // A line with no timecode never becomes "current"
                          // as playback advances, so dimming it like an
                          // upcoming line would leave it gray forever —
                          // show it plain white instead.
                          final isDimmed =
                              ligne.timecodeMs != null && !isCurrent;
                          return GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () => _seekTo(ligne.timecodeMs),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: AnimatedDefaultTextStyle(
                                duration: const Duration(milliseconds: 250),
                                curve: Curves.easeOut,
                                style: TextStyle(
                                  color: isDimmed
                                      ? Colors.white38
                                      : Colors.white,
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
                    l10n.errorGenericMessage('$error'),
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
                    positionMs: positionMs,
                    durationMs: audio?.dureeMs,
                    onSeekMs: (ms) => _seekTo(ms),
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
    required this.positionMs,
    required this.durationMs,
    required this.onSeekMs,
    required this.onExit,
  });

  final RapModeSubMode subMode;
  final double fontSize;
  final bool loop;
  final VoidCallback onToggleLoop;
  final AudioPlayer? player;
  final bool virtualPlaying;
  final VoidCallback onToggleVirtualClock;
  final int positionMs;
  final int? durationMs;
  final ValueChanged<int> onSeekMs;
  final VoidCallback onExit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Pinned to the top as one block, independent of the scrolling
        // lyrics below: the icon row and the seek bar move together.
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(LucideIcons.x, color: Colors.white),
                    onPressed: onExit,
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(
                      LucideIcons.repeat,
                      color: loop ? Colors.deepPurpleAccent : Colors.white,
                    ),
                    tooltip: loop ? l10n.loopOnTooltip : l10n.loopOffTooltip,
                    onPressed: onToggleLoop,
                  ),
                  IconButton(
                    icon: const Icon(
                      LucideIcons.a_arrow_down,
                      color: Colors.white,
                    ),
                    onPressed: () =>
                        ref.read(rapModeFontSizeProvider.notifier).decrease(),
                  ),
                  IconButton(
                    icon: const Icon(
                      LucideIcons.a_arrow_up,
                      color: Colors.white,
                    ),
                    onPressed: () =>
                        ref.read(rapModeFontSizeProvider.notifier).increase(),
                  ),
                  IconButton(
                    icon: Icon(
                      subMode == RapModeSubMode.auto
                          ? LucideIcons.refresh_cw
                          : LucideIcons.hand,
                      color: Colors.white,
                    ),
                    tooltip: subMode == RapModeSubMode.auto
                        ? l10n.autoScrollTooltip
                        : l10n.manualScrollTooltip,
                    onPressed: () =>
                        ref.read(rapModeSubModeProvider.notifier).toggle(),
                  ),
                ],
              ),
            ),
            if (durationMs != null && durationMs! > 0) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 3,
                    overlayShape: SliderComponentShape.noOverlay,
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 6,
                    ),
                  ),
                  child: Slider(
                    value: positionMs.clamp(0, durationMs!).toDouble(),
                    min: 0,
                    max: durationMs!.toDouble(),
                    activeColor: Colors.deepPurpleAccent,
                    inactiveColor: Colors.white24,
                    onChanged: (value) => onSeekMs(value.toInt()),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatMs(positionMs),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      _formatMs(durationMs!),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
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
                      icon: Icon(
                        playing ? LucideIcons.pause : LucideIcons.play,
                      ),
                      onPressed: () =>
                          playing ? player!.pause() : player!.play(),
                    );
                  },
                )
              : IconButton.filled(
                  iconSize: 40,
                  tooltip: virtualPlaying
                      ? l10n.pauseVirtualClockTooltip
                      : l10n.startVirtualClockTooltip,
                  icon: Icon(
                    virtualPlaying ? LucideIcons.pause : LucideIcons.play,
                  ),
                  onPressed: onToggleVirtualClock,
                ),
        ),
      ],
    );
  }
}

String _formatMs(int ms) {
  final totalSeconds = ms ~/ 1000;
  final minutes = totalSeconds ~/ 60;
  final seconds = totalSeconds % 60;
  return '$minutes:${seconds.toString().padLeft(2, '0')}';
}
