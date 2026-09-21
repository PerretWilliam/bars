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

  /// Snackbar shown while importing a .rapproj bundle
  ///
  /// In en, this message translates to:
  /// **'Importing project…'**
  String get importingProjectMessage;

  /// Tooltip for the mini-FAB that imports a .rapproj bundle
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

  /// FAB label for exporting the project as a .rapproj bundle
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
