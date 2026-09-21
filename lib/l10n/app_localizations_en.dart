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

  @override
  String get newFolderDialogTitle => 'New folder';

  @override
  String get folderNameLabel => 'Folder name';

  @override
  String get renameFolderDialogTitle => 'Rename folder';

  @override
  String get renameFolderTooltip => 'Rename folder';

  @override
  String get deleteFolderTooltip => 'Delete folder';

  @override
  String get deleteFolderDialogTitle => 'Delete folder?';

  @override
  String deleteFolderDialogBody(String folderName) {
    return 'This deletes \"$folderName\". Its projects move back to the main list — they aren\'t deleted.';
  }

  @override
  String get folderLabel => 'Folder';

  @override
  String get noFolderOption => 'None';

  @override
  String get viewAsListTooltip => 'View as list';

  @override
  String get viewAsGridTooltip => 'View as grid';

  @override
  String get aboutTooltip => 'About';

  @override
  String get aboutTitle => 'About';

  @override
  String appVersionLabel(String version) {
    return 'Version $version';
  }

  @override
  String get authorWebsiteTooltip => 'Visit my website';

  @override
  String get githubTooltip => 'View on GitHub';

  @override
  String get buyMeACoffeeTooltip => 'Buy me a coffee';

  @override
  String get legalMenuLabel => 'Legal';

  @override
  String get changelogMenuLabel => 'Changelog';

  @override
  String get donateMenuLabel => 'Support this project';

  @override
  String get contributingMenuLabel => 'Contributing';

  @override
  String get legalTitle => 'Legal';

  @override
  String get legalPlaceholderText =>
      'This section is a placeholder. It will be replaced with the app\'s actual privacy policy and terms of use before a public release.';

  @override
  String get changelogTitle => 'Changelog';

  @override
  String get donateTitle => 'Support this project';

  @override
  String get donateIntro =>
      'This app has no ads and no subscription. If you\'d like to help cover the cost of publishing it, here\'s where that goes:';

  @override
  String get googleGoalLabel => 'Google Play registration (one-time)';

  @override
  String get appleGoalLabel => 'Apple Developer Program (renews yearly)';

  @override
  String donateAmountLabel(String raised, String goal) {
    return '$raised € / $goal €';
  }

  @override
  String get buyMeACoffeeButtonLabel => 'Buy me a coffee';
}
