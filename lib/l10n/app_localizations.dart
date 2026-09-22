import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr'),
  ];

  /// AppBar title on the projects list screen
  ///
  /// In en, this message translates to:
  /// **'My projects'**
  String get projectsListTitle;

  /// Title shown when the projects list is empty
  ///
  /// In en, this message translates to:
  /// **'No projects yet'**
  String get noProjectsYetTitle;

  /// Body text shown when the projects list is empty
  ///
  /// In en, this message translates to:
  /// **'Tap the + button to start writing your first track.'**
  String get noProjectsYetBody;

  /// Snackbar shown while importing a .lrcproj bundle
  ///
  /// In en, this message translates to:
  /// **'Importing project…'**
  String get importingProjectMessage;

  /// Label/tooltip for the overflow-menu action that imports a .lrcproj bundle
  ///
  /// In en, this message translates to:
  /// **'Import project'**
  String get importProjectTooltip;

  /// Title of the confirmation dialog before deleting a project
  ///
  /// In en, this message translates to:
  /// **'Delete project?'**
  String get deleteProjectDialogTitle;

  /// Body of the confirmation dialog before deleting a project
  ///
  /// In en, this message translates to:
  /// **'This permanently deletes \"{projectName}\", its lines, and its audio file.'**
  String deleteProjectDialogBody(String projectName);

  /// Short placeholder shown where a project card or Rap mode would preview its lines
  ///
  /// In en, this message translates to:
  /// **'No lines yet'**
  String get noLinesYetPreview;

  /// AppBar title on the new project screen
  ///
  /// In en, this message translates to:
  /// **'New project'**
  String get newProjectTitle;

  /// Label for the project name text field
  ///
  /// In en, this message translates to:
  /// **'Project name'**
  String get projectNameLabel;

  /// Validation error when the project name field is left empty
  ///
  /// In en, this message translates to:
  /// **'Please enter a name'**
  String get projectNameRequiredError;

  /// Label for the default-language dropdown
  ///
  /// In en, this message translates to:
  /// **'Default language'**
  String get defaultLanguageLabel;

  /// Name of the French language, as shown in a language picker
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get languageFrench;

  /// Name of the English language, as shown in a language picker
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// Button that submits the new project form
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get createButton;

  /// AppBar title, and FAB label, for the project info/edit screen
  ///
  /// In en, this message translates to:
  /// **'Project info'**
  String get projectInfoTitle;

  /// Shown when the project info screen can't find the requested project
  ///
  /// In en, this message translates to:
  /// **'Project not found.'**
  String get projectNotFoundMessage;

  /// Label for the optional production/release link text field
  ///
  /// In en, this message translates to:
  /// **'Prod link (optional)'**
  String get prodLinkLabel;

  /// Placeholder hint for the production link text field
  ///
  /// In en, this message translates to:
  /// **'https://…'**
  String get prodLinkHint;

  /// Tooltip for the button that opens the production link in a browser
  ///
  /// In en, this message translates to:
  /// **'Open link'**
  String get openLinkTooltip;

  /// Validation error when the production link isn't a valid URL
  ///
  /// In en, this message translates to:
  /// **'Enter a valid URL'**
  String get invalidUrlError;

  /// Button that submits the project info form
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveButton;

  /// AppBar title on the notepad/line editor screen
  ///
  /// In en, this message translates to:
  /// **'Notepad'**
  String get notepadTitle;

  /// Tooltip to reveal per-line timecode inputs
  ///
  /// In en, this message translates to:
  /// **'Show timecodes'**
  String get showTimecodesTooltip;

  /// Tooltip to hide per-line timecode inputs
  ///
  /// In en, this message translates to:
  /// **'Hide timecodes'**
  String get hideTimecodesTooltip;

  /// Tooltip for the button that opens the full-screen Rap mode display
  ///
  /// In en, this message translates to:
  /// **'Rap mode'**
  String get rapModeTooltip;

  /// Shown in the notepad when a project has no lines yet
  ///
  /// In en, this message translates to:
  /// **'No lines yet. Tap + to start.'**
  String get noLinesYetEditorMessage;

  /// Snackbar shown while importing an audio file
  ///
  /// In en, this message translates to:
  /// **'Importing audio…'**
  String get importingAudioMessage;

  /// FAB label for opening the project's production/release link
  ///
  /// In en, this message translates to:
  /// **'Open prod'**
  String get openProdLabel;

  /// AppBar title, and FAB label, for the rhyme dictionaries screen
  ///
  /// In en, this message translates to:
  /// **'Rhyme dictionaries'**
  String get rhymeDictionariesTitle;

  /// FAB label for exporting the project as a .lrcproj bundle
  ///
  /// In en, this message translates to:
  /// **'Export project'**
  String get exportProjectLabel;

  /// FAB label for importing an audio file
  ///
  /// In en, this message translates to:
  /// **'Import audio file'**
  String get importAudioFileLabel;

  /// Tooltip for the button that removes the project's audio file
  ///
  /// In en, this message translates to:
  /// **'Remove audio'**
  String get removeAudioTooltip;

  /// Warning tooltip when a line's timecode is earlier than the previous line's
  ///
  /// In en, this message translates to:
  /// **'Earlier than the previous line\'s timecode'**
  String get timecodeOutOfOrderTooltip;

  /// Tooltip for the button that sets a line's timecode to the current playback position
  ///
  /// In en, this message translates to:
  /// **'Mark at current playback time'**
  String get markCurrentTimeTooltip;

  /// Placeholder shown in an empty timecode input
  ///
  /// In en, this message translates to:
  /// **'--:--'**
  String get timecodeHint;

  /// Title of the French rhyme dictionary entry
  ///
  /// In en, this message translates to:
  /// **'French (Lexique)'**
  String get frenchDictionaryTitle;

  /// Title of the English rhyme dictionary entry
  ///
  /// In en, this message translates to:
  /// **'English (CMU)'**
  String get englishDictionaryTitle;

  /// Status shown while a dictionary download's progress is unknown
  ///
  /// In en, this message translates to:
  /// **'Downloading…'**
  String get dictionaryDownloadingMessage;

  /// Status shown while a dictionary download's progress is known
  ///
  /// In en, this message translates to:
  /// **'Downloading… {percent}%'**
  String dictionaryDownloadingProgressMessage(int percent);

  /// Status shown while a downloaded dictionary is being imported
  ///
  /// In en, this message translates to:
  /// **'Importing into the database…'**
  String get dictionaryImportingMessage;

  /// Status shown when a dictionary download or import fails
  ///
  /// In en, this message translates to:
  /// **'Failed: {error}'**
  String dictionaryFailedMessage(String error);

  /// Status shown when a dictionary is already downloaded
  ///
  /// In en, this message translates to:
  /// **'Downloaded — available offline'**
  String get dictionaryDownloadedMessage;

  /// Status shown when a dictionary hasn't been downloaded yet
  ///
  /// In en, this message translates to:
  /// **'Not downloaded'**
  String get dictionaryNotDownloadedMessage;

  /// Status shown while checking whether a dictionary is downloaded
  ///
  /// In en, this message translates to:
  /// **'Checking…'**
  String get dictionaryCheckingMessage;

  /// Button that starts a dictionary download
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get downloadButton;

  /// Tooltip for the Rap mode loop toggle when loop is enabled
  ///
  /// In en, this message translates to:
  /// **'Loop on (tap to disable)'**
  String get loopOnTooltip;

  /// Tooltip for the Rap mode loop toggle when loop is disabled
  ///
  /// In en, this message translates to:
  /// **'Loop off (tap to enable)'**
  String get loopOffTooltip;

  /// Tooltip for the Rap mode scroll-mode toggle when in auto-scroll mode
  ///
  /// In en, this message translates to:
  /// **'Auto-scroll (tap to switch to manual)'**
  String get autoScrollTooltip;

  /// Tooltip for the Rap mode scroll-mode toggle when in manual-scroll mode
  ///
  /// In en, this message translates to:
  /// **'Manual scroll (tap to switch to auto)'**
  String get manualScrollTooltip;

  /// Tooltip for the play/pause button when driving auto-scroll by a timer instead of audio playback
  ///
  /// In en, this message translates to:
  /// **'Pause the timer-based auto-scroll'**
  String get pauseVirtualClockTooltip;

  /// Tooltip for the play/pause button when driving auto-scroll by a timer instead of audio playback
  ///
  /// In en, this message translates to:
  /// **'Start timer-based auto-scroll (no audio file)'**
  String get startVirtualClockTooltip;

  /// Shown in the rhyme suggestions panel when no rhymes match
  ///
  /// In en, this message translates to:
  /// **'No rhymes found'**
  String get noRhymesFoundMessage;

  /// Generic cancel button
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelButton;

  /// Generic delete button
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteButton;

  /// Generic error message shown when a data stream/provider fails, with the underlying error appended
  ///
  /// In en, this message translates to:
  /// **'Something went wrong: {error}'**
  String errorGenericMessage(String error);

  /// Title of the dialog that creates a new folder, and the mini-FAB's tooltip
  ///
  /// In en, this message translates to:
  /// **'New folder'**
  String get newFolderDialogTitle;

  /// Label for the folder name text field
  ///
  /// In en, this message translates to:
  /// **'Folder name'**
  String get folderNameLabel;

  /// Title of the dialog that renames a folder
  ///
  /// In en, this message translates to:
  /// **'Rename folder'**
  String get renameFolderDialogTitle;

  /// Tooltip for the AppBar action that renames the current folder
  ///
  /// In en, this message translates to:
  /// **'Rename folder'**
  String get renameFolderTooltip;

  /// Tooltip for the AppBar action that deletes the current folder
  ///
  /// In en, this message translates to:
  /// **'Delete folder'**
  String get deleteFolderTooltip;

  /// Title of the confirmation dialog before deleting a folder
  ///
  /// In en, this message translates to:
  /// **'Delete folder?'**
  String get deleteFolderDialogTitle;

  /// Body of the confirmation dialog before deleting a folder
  ///
  /// In en, this message translates to:
  /// **'This deletes \"{folderName}\". Its projects move back to the main list — they aren\'t deleted.'**
  String deleteFolderDialogBody(String folderName);

  /// Label for the folder-picker dropdown on the project info screen
  ///
  /// In en, this message translates to:
  /// **'Folder'**
  String get folderLabel;

  /// Option in the folder-picker dropdown meaning the project has no folder
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get noFolderOption;

  /// Tooltip for the overflow (⋮) menu button on the projects list AppBar
  ///
  /// In en, this message translates to:
  /// **'More options'**
  String get moreOptionsTooltip;

  /// Tooltip for the AppBar action that opens the About screen
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get aboutTooltip;

  /// AppBar title on the About screen
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get aboutTitle;

  /// Shows the app's version number
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String appVersionLabel(String version);

  /// Short tagline on the About screen, distinguishing the app from paid competitors
  ///
  /// In en, this message translates to:
  /// **'Free, unlimited, no account — and open source.'**
  String get aboutTagline;

  /// Tooltip for the link to the author's personal website
  ///
  /// In en, this message translates to:
  /// **'Visit my website'**
  String get authorWebsiteTooltip;

  /// Tooltip for the link to the app's GitHub repository
  ///
  /// In en, this message translates to:
  /// **'View on GitHub'**
  String get githubTooltip;

  /// Tooltip for the link to the author's Buy Me a Coffee page
  ///
  /// In en, this message translates to:
  /// **'Buy me a coffee'**
  String get buyMeACoffeeTooltip;

  /// Menu entry on the About screen linking to the Legal screen
  ///
  /// In en, this message translates to:
  /// **'Legal'**
  String get legalMenuLabel;

  /// Menu entry on the About screen linking to the Changelog screen
  ///
  /// In en, this message translates to:
  /// **'Changelog'**
  String get changelogMenuLabel;

  /// Menu entry on the About screen linking to the Donate screen
  ///
  /// In en, this message translates to:
  /// **'Support this project'**
  String get donateMenuLabel;

  /// Menu entry on the About screen linking out to the CONTRIBUTING.md file on GitHub
  ///
  /// In en, this message translates to:
  /// **'Contributing'**
  String get contributingMenuLabel;

  /// AppBar title on the Legal screen
  ///
  /// In en, this message translates to:
  /// **'Legal'**
  String get legalTitle;

  /// Legal screen section title
  ///
  /// In en, this message translates to:
  /// **'Publisher'**
  String get legalPublisherTitle;

  /// Legal screen section body
  ///
  /// In en, this message translates to:
  /// **'Bars is developed and published by William Perret. You can reach out via the project\'s GitHub repository or william-perret.fr.'**
  String get legalPublisherBody;

  /// Legal screen section title
  ///
  /// In en, this message translates to:
  /// **'Personal data'**
  String get legalDataTitle;

  /// Legal screen section body
  ///
  /// In en, this message translates to:
  /// **'Bars has no backend and no user accounts. Everything you create — projects, lyrics, timecodes, imported audio — stays stored locally on your device and is never sent to or stored on any server. The app doesn\'t use analytics, ads, or tracking of any kind.'**
  String get legalDataBody;

  /// Legal screen section title
  ///
  /// In en, this message translates to:
  /// **'Your content'**
  String get legalContentTitle;

  /// Legal screen section body
  ///
  /// In en, this message translates to:
  /// **'Lyrics and projects you write remain entirely your own. You can export them as .lrcproj files — a standard LRC document plus your audio, readable outside Bars too — or delete them at any time; nothing is retained anywhere else.'**
  String get legalContentBody;

  /// Legal screen section title
  ///
  /// In en, this message translates to:
  /// **'License'**
  String get legalLicenseTitle;

  /// Legal screen section body
  ///
  /// In en, this message translates to:
  /// **'Bars is open-source software released under the MIT license. Its source code is publicly available at github.com/PerretWilliam/bars.'**
  String get legalLicenseBody;

  /// Legal screen section title
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get legalContactTitle;

  /// Legal screen section body
  ///
  /// In en, this message translates to:
  /// **'For any question about this app, open an issue on GitHub or reach out via william-perret.fr.'**
  String get legalContactBody;

  /// AppBar title on the Changelog screen
  ///
  /// In en, this message translates to:
  /// **'Changelog'**
  String get changelogTitle;

  /// AppBar title on the Donate screen
  ///
  /// In en, this message translates to:
  /// **'Support this project'**
  String get donateTitle;

  /// Intro text on the Donate screen
  ///
  /// In en, this message translates to:
  /// **'This app has no ads and no subscription. If you\'d like to help cover the cost of publishing it, here\'s where that goes:'**
  String get donateIntro;

  /// Label for the Google Play donation goal
  ///
  /// In en, this message translates to:
  /// **'Google Play registration (one-time)'**
  String get googleGoalLabel;

  /// Label for the Apple Developer Program donation goal
  ///
  /// In en, this message translates to:
  /// **'Apple Developer Program (renews yearly)'**
  String get appleGoalLabel;

  /// Shows progress toward a donation goal, e.g. "12 € / 25 €"
  ///
  /// In en, this message translates to:
  /// **'{raised} € / {goal} €'**
  String donateAmountLabel(String raised, String goal);

  /// Button label linking to Buy Me a Coffee
  ///
  /// In en, this message translates to:
  /// **'Buy me a coffee'**
  String get buyMeACoffeeButtonLabel;

  /// Changelog bullet for version 1.0.0
  ///
  /// In en, this message translates to:
  /// **'Write, reorder, and delete lyric lines, with live rhyme suggestions in French and English'**
  String get changelog100Notepad;

  /// Changelog bullet for version 1.0.0
  ///
  /// In en, this message translates to:
  /// **'Timecoded mode: import an audio file and mark each line at its exact moment in the track'**
  String get changelog100Timecoded;

  /// Changelog bullet for version 1.0.0
  ///
  /// In en, this message translates to:
  /// **'Rap mode: a full-screen, auto-scrolling display synced to playback'**
  String get changelog100RapMode;

  /// Changelog bullet for version 1.0.0
  ///
  /// In en, this message translates to:
  /// **'Export and import projects as .rapproj bundles'**
  String get changelog100ExportImport;

  /// Changelog bullet for version 1.0.0
  ///
  /// In en, this message translates to:
  /// **'Light and dark theme, a full icon set, and a French/English localized UI'**
  String get changelog100ThemeAndIcons;

  /// Changelog bullet for version 1.0.0
  ///
  /// In en, this message translates to:
  /// **'Folders, a list/grid view toggle, and app info/legal/donate pages'**
  String get changelog100FoldersAndInfo;

  /// Changelog bullet for version 1.1.0
  ///
  /// In en, this message translates to:
  /// **'Projects now export as .lrcproj: a standard LRC lyrics file plus your audio, readable outside Bars too — replacing the old proprietary .rapproj format'**
  String get changelog110StandardFormat;

  /// Changelog bullet for version 1.1.0
  ///
  /// In en, this message translates to:
  /// **'Simplified the projects screen toolbar: import and app info now live in a single \"⋮\" menu, and the grid view was removed in favor of a single clear list'**
  String get changelog110CleanerToolbar;

  /// Changelog bullet for version 1.1.0
  ///
  /// In en, this message translates to:
  /// **'Made left/right spacing consistent across every screen'**
  String get changelog110ConsistentSpacing;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
