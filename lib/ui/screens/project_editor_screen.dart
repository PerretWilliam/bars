import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_waveform/just_waveform.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../data/app_database.dart';
import '../../providers/audio_provider.dart';
import '../../providers/lignes_provider.dart';
import '../../providers/notepad_provider.dart';
import '../../providers/projets_provider.dart';
import '../../services/language_detector.dart';
import '../../services/waveform_extractor.dart';
import '../widgets/rhyme_suggestions_panel.dart';
import '../widgets/waveform_view.dart';

class ProjectEditorScreen extends ConsumerWidget {
  const ProjectEditorScreen({required this.projetId, super.key});

  final int projetId;

  Future<void> _addLine(WidgetRef ref) async {
    final lignes = await ref.read(lignesForProjetProvider(projetId).future);
    await ref
        .read(lignesControllerProvider)
        .addLigne(projetId: projetId, ordre: lignes.length);
  }

  Future<void> _importAudio(BuildContext context, WidgetRef ref) async {
    final files = await FilePicker.pickFiles(type: FileType.audio);
    if (files.isEmpty) return;
    final path = files.single.path;
    if (path == null) return;
    if (context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Importing audio…')));
    }
    await ref.read(audioControllerProvider).importAudio(projetId, path);
  }

  Future<void> _exportProject(WidgetRef ref) async {
    final export = await ref
        .read(projectBundleServiceProvider)
        .exportProject(projetId);
    await FilePicker.saveFile(fileName: export.fileName, bytes: export.bytes);
  }

  Future<void> _openProdLink(String lienProd) async {
    final url = Uri.tryParse(lienProd);
    if (url == null) return;
    await launchUrl(url, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lignesAsync = ref.watch(lignesForProjetProvider(projetId));
    final audio = ref.watch(audioForProjetProvider(projetId)).value;
    final controller = ref.read(lignesControllerProvider);
    final showTimecode = ref.watch(timecodeVisibleProvider);
    final lienProd = ref.watch(projetProvider(projetId)).value?.lienProd;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notepad'),
        actions: [
          IconButton(
            icon: Icon(showTimecode ? LucideIcons.eye : LucideIcons.eye_off),
            tooltip: showTimecode ? 'Hide timecodes' : 'Show timecodes',
            onPressed: () =>
                ref.read(timecodeVisibleProvider.notifier).toggle(),
          ),
          IconButton(
            icon: const Icon(LucideIcons.play),
            tooltip: 'Rap mode',
            onPressed: () => context.push('/project/$projetId/rap'),
          ),
        ],
      ),
      body: Column(
        children: [
          if (audio != null) _AudioSection(projetId: projetId, audio: audio),
          Expanded(
            child: lignesAsync.when(
              data: (lignes) {
                if (lignes.isEmpty) {
                  return const Center(
                    child: Text('No lines yet. Tap + to start.'),
                  );
                }
                return ReorderableListView.builder(
                  physics: const ClampingScrollPhysics(),
                  // The default long-press-anywhere drag would compete with
                  // Dismissible's swipe-to-delete gesture below, so dragging
                  // is only started from the explicit handle icon.
                  buildDefaultDragHandles: false,
                  itemCount: lignes.length,
                  itemBuilder: (context, index) {
                    final ligne = lignes[index];
                    return Dismissible(
                      key: ValueKey(ligne.id),
                      direction: DismissDirection.startToEnd,
                      background: const _SwipeDeleteBackground(),
                      onDismissed: (_) => controller.deleteLigne(ligne.id),
                      child: _LigneTile(
                        ligne: ligne,
                        index: index,
                        hasAudio: audio != null,
                        showTimecode: showTimecode,
                        isOutOfOrder: _isOutOfOrder(lignes, index),
                        onTexteChanged: (texte) =>
                            controller.updateTexte(ligne.id, texte),
                        onLangueDetected: (langue) =>
                            controller.updateLangueDetectee(ligne.id, langue),
                        onTimecodeChanged: (ms) =>
                            controller.updateTimecode(ligne.id, ms),
                      ),
                    );
                  },
                  onReorderItem: (index, newIndex) {
                    final reordered = [...lignes];
                    final moved = reordered.removeAt(index);
                    reordered.insert(newIndex, moved);
                    controller.reorder(reordered);
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) =>
                  Center(child: Text('Something went wrong: $error')),
            ),
          ),
        ],
      ),
      floatingActionButton: _AddFab(
        onAddLine: () => _addLine(ref),
        onImportAudio: () => _importAudio(context, ref),
        onProjectInfo: () => context.push('/project/$projetId/info'),
        onExportProject: () => _exportProject(ref),
        onDictionaries: () => context.push('/dictionaries'),
        onOpenProd: lienProd == null ? null : () => _openProdLink(lienProd),
      ),
    );
  }
}

/// Whether `lignes[index]`'s timecode is out of chronological order relative
/// to the nearest preceding and following lines that have one set. Lines
/// without a timecode never count as out of order.
bool _isOutOfOrder(List<Ligne> lignes, int index) {
  final current = lignes[index].timecodeMs;
  if (current == null) return false;

  for (var i = index - 1; i >= 0; i--) {
    final previous = lignes[i].timecodeMs;
    if (previous != null) return current < previous;
  }
  return false;
}

/// A `+` FAB that adds a line on a plain tap; long-pressing reveals
/// secondary mini-FABs for the project's other actions, Google Keep-style.
class _AddFab extends StatefulWidget {
  const _AddFab({
    required this.onAddLine,
    required this.onImportAudio,
    required this.onProjectInfo,
    required this.onExportProject,
    required this.onDictionaries,
    this.onOpenProd,
  });

  final VoidCallback onAddLine;
  final VoidCallback onImportAudio;
  final VoidCallback onProjectInfo;
  final VoidCallback onExportProject;
  final VoidCallback onDictionaries;

  /// Null when the project has no prod link set, hiding that mini-FAB.
  final VoidCallback? onOpenProd;

  @override
  State<_AddFab> createState() => _AddFabState();
}

class _AddFabState extends State<_AddFab> {
  bool _expanded = false;

  Widget _miniFab({
    required String heroTag,
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    void handlePressed() {
      setState(() => _expanded = false);
      onPressed();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Material(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: handlePressed,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                child: Text(label),
              ),
            ),
          ),
          const SizedBox(width: 12),
          FloatingActionButton.small(
            heroTag: heroTag,
            tooltip: label,
            onPressed: handlePressed,
            child: Icon(icon),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (_expanded) ...[
          if (widget.onOpenProd case final onOpenProd?)
            _miniFab(
              heroTag: 'openProdFab',
              label: 'Open prod',
              icon: LucideIcons.link,
              onPressed: onOpenProd,
            ),
          _miniFab(
            heroTag: 'dictionariesFab',
            label: 'Rhyme dictionaries',
            icon: LucideIcons.book_open,
            onPressed: widget.onDictionaries,
          ),
          _miniFab(
            heroTag: 'exportProjectFab',
            label: 'Export project',
            icon: LucideIcons.share_2,
            onPressed: widget.onExportProject,
          ),
          _miniFab(
            heroTag: 'projectInfoFab',
            label: 'Project info',
            icon: LucideIcons.info,
            onPressed: widget.onProjectInfo,
          ),
          _miniFab(
            heroTag: 'importAudioFab',
            label: 'Import audio file',
            icon: LucideIcons.file_music,
            onPressed: widget.onImportAudio,
          ),
        ],
        GestureDetector(
          onLongPress: () => setState(() => _expanded = !_expanded),
          child: FloatingActionButton(
            heroTag: 'addLineFab',
            onPressed: () {
              if (_expanded) {
                setState(() => _expanded = false);
              } else {
                widget.onAddLine();
              }
            },
            child: Icon(_expanded ? LucideIcons.x : LucideIcons.plus),
          ),
        ),
      ],
    );
  }
}

String _formatDuration(Duration d) {
  final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
  final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
  return '$minutes:$seconds';
}

/// Parses a `mm:ss` or plain-seconds string into milliseconds, or null if
/// [input] isn't a valid non-negative timecode. In the `mm:ss` form, the
/// seconds part must be a real seconds value (0-59): "00:90" is rejected
/// rather than silently read as 90 seconds.
int? _parseTimecode(String input) {
  final parts = input.trim().split(':');
  if (parts.isEmpty || parts.length > 2) return null;
  final numbers = parts.map(int.tryParse).toList();
  if (numbers.contains(null)) return null;
  if (parts.length == 2 && (numbers[1]! < 0 || numbers[1]! > 59)) return null;
  final seconds = parts.length == 2
      ? numbers[0]! * 60 + numbers[1]!
      : numbers[0]!;
  if (seconds < 0) return null;
  return seconds * 1000;
}

/// Live-formats digit entry into `mm:ss` as the user types (a numeric
/// keypad has no `:` key), e.g. "1" "2" "3" "4" becomes "12:34".
class _TimecodeInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    final limited = digits.length > 4 ? digits.substring(0, 4) : digits;

    final buffer = StringBuffer();
    for (var i = 0; i < limited.length; i++) {
      if (i == 2) buffer.write(':');
      buffer.write(limited[i]);
    }

    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class _AudioSection extends ConsumerStatefulWidget {
  const _AudioSection({required this.projetId, required this.audio});

  final int projetId;
  final Audio audio;

  @override
  ConsumerState<_AudioSection> createState() => _AudioSectionState();
}

class _AudioSectionState extends ConsumerState<_AudioSection> {
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
  void didUpdateWidget(covariant _AudioSection oldWidget) {
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
      ref.read(audioPositionProvider.notifier).set(position);
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

  Future<void> _removeAudio() async {
    await _player.stop();
    await ref.read(audioControllerProvider).removeAudio(widget.projetId);
  }

  @override
  Widget build(BuildContext context) {
    final waveform = _waveform;
    final totalDuration = Duration(milliseconds: widget.audio.dureeMs);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Column(
        children: [
          SizedBox(
            height: 72,
            child: waveform == null
                ? const Center(child: CircularProgressIndicator())
                : WaveformView(
                    waveform: waveform,
                    position: _position,
                    duration: totalDuration,
                    onSeek: _player.seek,
                  ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StreamBuilder<bool>(
                stream: _player.playingStream,
                builder: (context, snapshot) {
                  final playing = snapshot.data ?? false;
                  return IconButton.filled(
                    icon: Icon(playing ? LucideIcons.pause : LucideIcons.play),
                    onPressed: () => playing ? _player.pause() : _player.play(),
                  );
                },
              ),
              const SizedBox(width: 12),
              Text(
                '${_formatDuration(_position)} / ${_formatDuration(totalDuration)}',
              ),
              const SizedBox(width: 12),
              IconButton(
                icon: const Icon(LucideIcons.trash),
                tooltip: 'Remove audio',
                onPressed: _removeAudio,
              ),
            ],
          ),
          const Divider(height: 16),
        ],
      ),
    );
  }
}

class _LigneTile extends ConsumerStatefulWidget {
  const _LigneTile({
    required this.ligne,
    required this.index,
    required this.hasAudio,
    required this.showTimecode,
    required this.isOutOfOrder,
    required this.onTexteChanged,
    required this.onLangueDetected,
    required this.onTimecodeChanged,
  });

  final Ligne ligne;
  final int index;
  final bool hasAudio;
  final bool showTimecode;
  final bool isOutOfOrder;
  final ValueChanged<String> onTexteChanged;
  final ValueChanged<String?> onLangueDetected;
  final ValueChanged<int?> onTimecodeChanged;

  @override
  ConsumerState<_LigneTile> createState() => _LigneTileState();
}

final _wordPattern = RegExp(r"[a-zA-ZÀ-ÿ']+");

class _LigneTileState extends ConsumerState<_LigneTile> {
  static const _detectionDebounce = Duration(milliseconds: 600);

  late final TextEditingController _textController;
  late final TextEditingController _timecodeController;
  final _focusNode = FocusNode();
  final _timecodeFocusNode = FocusNode();
  Timer? _debounce;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.ligne.texte);
    _timecodeController = TextEditingController(
      text: _timecodeText(widget.ligne.timecodeMs),
    );
    _focusNode.addListener(() {
      setState(() => _isFocused = _focusNode.hasFocus);
    });
  }

  @override
  void didUpdateWidget(covariant _LigneTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Don't clobber what the user is actively typing.
    if (!_timecodeFocusNode.hasFocus &&
        oldWidget.ligne.timecodeMs != widget.ligne.timecodeMs) {
      _timecodeController.text = _timecodeText(widget.ligne.timecodeMs);
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _textController.dispose();
    _timecodeController.dispose();
    _focusNode.dispose();
    _timecodeFocusNode.dispose();
    super.dispose();
  }

  static String _timecodeText(int? ms) =>
      ms == null ? '' : _formatDuration(Duration(milliseconds: ms));

  void _onTexteChanged(String texte) {
    widget.onTexteChanged(texte);
    // Recompute _lastWord immediately: waiting on the database round-trip
    // to trigger a rebuild would leave the rhyme panel a keystroke behind.
    setState(() {});
    _debounce?.cancel();
    _debounce = Timer(_detectionDebounce, () {
      widget.onLangueDetected(LanguageDetector.detect(texte));
    });
  }

  String? get _lastWord {
    final matches = _wordPattern.allMatches(_textController.text);
    if (matches.isEmpty) return null;
    return matches.last.group(0);
  }

  void _insertWord(String word) {
    final current = _textController.text;
    final separator = current.isEmpty || current.endsWith(' ') ? '' : ' ';
    final updated = '$current$separator$word';
    _textController.text = updated;
    _textController.selection = TextSelection.collapsed(offset: updated.length);
    widget.onTexteChanged(updated);
    setState(() {});
  }

  void _commitTimecode(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) {
      widget.onTimecodeChanged(null);
      return;
    }
    final ms = _parseTimecode(trimmed);
    if (ms == null) {
      // Invalid input: revert to the last known-good value.
      _timecodeController.text = _timecodeText(widget.ligne.timecodeMs);
      return;
    }
    widget.onTimecodeChanged(ms);
  }

  void _markNow() {
    final ms = ref.read(audioPositionProvider).inMilliseconds;
    _timecodeController.text = _formatDuration(Duration(milliseconds: ms));
    widget.onTimecodeChanged(ms);
  }

  @override
  Widget build(BuildContext context) {
    final lastWord = _lastWord;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ListTile(
          leading: ReorderableDragStartListener(
            index: widget.index,
            child: const Icon(LucideIcons.grip_vertical),
          ),
          title: TextField(
            controller: _textController,
            focusNode: _focusNode,
            decoration: const InputDecoration(border: InputBorder.none),
            minLines: 1,
            maxLines: null,
            onChanged: _onTexteChanged,
          ),
          subtitle: widget.ligne.langueDetectee == null
              ? null
              : Text(widget.ligne.langueDetectee!.toUpperCase()),
          trailing: widget.showTimecode
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.isOutOfOrder)
                      const Padding(
                        padding: EdgeInsets.only(right: 4),
                        child: Tooltip(
                          message: 'Earlier than the previous line\'s timecode',
                          child: Icon(
                            LucideIcons.triangle_alert,
                            size: 18,
                            color: Colors.orange,
                          ),
                        ),
                      ),
                    SizedBox(
                      width: 56,
                      child: TextField(
                        key: ValueKey('timecode-${widget.ligne.id}'),
                        controller: _timecodeController,
                        focusNode: _timecodeFocusNode,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        inputFormatters: [_TimecodeInputFormatter()],
                        decoration: const InputDecoration(
                          hintText: '--:--',
                          border: InputBorder.none,
                          isDense: true,
                        ),
                        onSubmitted: _commitTimecode,
                        onTapOutside: (_) =>
                            _commitTimecode(_timecodeController.text),
                      ),
                    ),
                    if (widget.hasAudio)
                      IconButton(
                        icon: const Icon(LucideIcons.flag, size: 20),
                        tooltip: 'Mark at current playback time',
                        visualDensity: VisualDensity.compact,
                        onPressed: _markNow,
                      ),
                  ],
                )
              : null,
        ),
        if (_isFocused && lastWord != null)
          RhymeSuggestionsPanel(
            word: lastWord,
            langue: widget.ligne.langueDetectee ?? 'fr',
            onSelect: _insertWord,
          ),
      ],
    );
  }
}

class _SwipeDeleteBackground extends StatelessWidget {
  const _SwipeDeleteBackground();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: const Icon(LucideIcons.trash, color: Colors.white),
    );
  }
}
