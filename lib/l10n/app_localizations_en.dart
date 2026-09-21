// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get projectsListTitle => 'My projects';

  @override
  String get noProjectsYetTitle => 'No projects yet';

  @override
  String get noProjectsYetBody =>
      'Tap the + button to start writing your first track.';

  @override
  String get importingProjectMessage => 'Importing project…';

  @override
  String get importProjectTooltip => 'Import project';

  @override
  String get deleteProjectDialogTitle => 'Delete project?';

  @override
  String deleteProjectDialogBody(String projectName) {
    return 'This permanently deletes \"$projectName\", its lines, and its audio file.';
  }

  @override
  String get noLinesYetPreview => 'No lines yet';

  @override
  String get newProjectTitle => 'New project';

  @override
  String get projectNameLabel => 'Project name';

  @override
  String get projectNameRequiredError => 'Please enter a name';

  @override
  String get defaultLanguageLabel => 'Default language';

  @override
  String get languageFrench => 'French';

  @override
  String get languageEnglish => 'English';

  @override
  String get createButton => 'Create';

  @override
  String get projectInfoTitle => 'Project info';

  @override
  String get projectNotFoundMessage => 'Project not found.';

  @override
  String get prodLinkLabel => 'Prod link (optional)';

  @override
  String get prodLinkHint => 'https://…';

  @override
  String get openLinkTooltip => 'Open link';

  @override
  String get invalidUrlError => 'Enter a valid URL';

  @override
  String get saveButton => 'Save';

  @override
  String get notepadTitle => 'Notepad';

  @override
  String get showTimecodesTooltip => 'Show timecodes';

  @override
  String get hideTimecodesTooltip => 'Hide timecodes';

  @override
  String get rapModeTooltip => 'Rap mode';

  @override
  String get noLinesYetEditorMessage => 'No lines yet. Tap + to start.';

  @override
  String get importingAudioMessage => 'Importing audio…';

  @override
  String get openProdLabel => 'Open prod';

  @override
  String get rhymeDictionariesTitle => 'Rhyme dictionaries';

  @override
  String get exportProjectLabel => 'Export project';

  @override
  String get importAudioFileLabel => 'Import audio file';

  @override
  String get removeAudioTooltip => 'Remove audio';

  @override
  String get timecodeOutOfOrderTooltip =>
      'Earlier than the previous line\'s timecode';

  @override
  String get markCurrentTimeTooltip => 'Mark at current playback time';

  @override
  String get timecodeHint => '--:--';

  @override
  String get frenchDictionaryTitle => 'French (Lexique)';

  @override
  String get englishDictionaryTitle => 'English (CMU)';

  @override
  String get dictionaryDownloadingMessage => 'Downloading…';

  @override
  String dictionaryDownloadingProgressMessage(int percent) {
    return 'Downloading… $percent%';
  }

  @override
  String get dictionaryImportingMessage => 'Importing into the database…';

  @override
  String dictionaryFailedMessage(String error) {
    return 'Failed: $error';
  }

  @override
  String get dictionaryDownloadedMessage => 'Downloaded — available offline';

  @override
  String get dictionaryNotDownloadedMessage => 'Not downloaded';

  @override
  String get dictionaryCheckingMessage => 'Checking…';

  @override
  String get downloadButton => 'Download';

  @override
  String get loopOnTooltip => 'Loop on (tap to disable)';

  @override
  String get loopOffTooltip => 'Loop off (tap to enable)';

  @override
  String get autoScrollTooltip => 'Auto-scroll (tap to switch to manual)';

  @override
  String get manualScrollTooltip => 'Manual scroll (tap to switch to auto)';

  @override
  String get pauseVirtualClockTooltip => 'Pause the timer-based auto-scroll';

  @override
  String get startVirtualClockTooltip =>
      'Start timer-based auto-scroll (no audio file)';

  @override
  String get noRhymesFoundMessage => 'No rhymes found';

  @override
  String get cancelButton => 'Cancel';

  @override
  String get deleteButton => 'Delete';

  @override
  String errorGenericMessage(String error) {
    return 'Something went wrong: $error';
  }
}
