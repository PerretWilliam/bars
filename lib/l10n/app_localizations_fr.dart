// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get projectsListTitle => 'Mes projets';

  @override
  String get noProjectsYetTitle => 'Aucun projet pour l\'instant';

  @override
  String get noProjectsYetBody =>
      'Appuie sur le bouton + pour écrire ton premier morceau.';

  @override
  String get importingProjectMessage => 'Importation du projet…';

  @override
  String get importProjectTooltip => 'Importer un projet';

  @override
  String get deleteProjectDialogTitle => 'Supprimer le projet ?';

  @override
  String deleteProjectDialogBody(String projectName) {
    return 'Ceci supprime définitivement « $projectName », ses lignes et son fichier audio.';
  }

  @override
  String get noLinesYetPreview => 'Aucune ligne pour l\'instant';

  @override
  String get newProjectTitle => 'Nouveau projet';

  @override
  String get projectNameLabel => 'Nom du projet';

  @override
  String get projectNameRequiredError => 'Merci de saisir un nom';

  @override
  String get defaultLanguageLabel => 'Langue par défaut';

  @override
  String get languageFrench => 'Français';

  @override
  String get languageEnglish => 'Anglais';

  @override
  String get createButton => 'Créer';

  @override
  String get projectInfoTitle => 'Infos du projet';

  @override
  String get projectNotFoundMessage => 'Projet introuvable.';

  @override
  String get prodLinkLabel => 'Lien de la prod (optionnel)';

  @override
  String get prodLinkHint => 'https://…';

  @override
  String get openLinkTooltip => 'Ouvrir le lien';

  @override
  String get invalidUrlError => 'Saisis une URL valide';

  @override
  String get saveButton => 'Enregistrer';

  @override
  String get notepadTitle => 'Bloc-notes';

  @override
  String get showTimecodesTooltip => 'Afficher les timecodes';

  @override
  String get hideTimecodesTooltip => 'Masquer les timecodes';

  @override
  String get rapModeTooltip => 'Mode rap';

  @override
  String get noLinesYetEditorMessage =>
      'Aucune ligne pour l\'instant. Appuie sur + pour commencer.';

  @override
  String get importingAudioMessage => 'Importation de l\'audio…';

  @override
  String get openProdLabel => 'Ouvrir la prod';

  @override
  String get rhymeDictionariesTitle => 'Dictionnaires de rimes';

  @override
  String get exportProjectLabel => 'Exporter le projet';

  @override
  String get importAudioFileLabel => 'Importer un fichier audio';

  @override
  String get removeAudioTooltip => 'Supprimer l\'audio';

  @override
  String get timecodeOutOfOrderTooltip =>
      'Antérieur au timecode de la ligne précédente';

  @override
  String get markCurrentTimeTooltip => 'Marquer à l\'instant de lecture actuel';

  @override
  String get timecodeHint => '--:--';

  @override
  String get frenchDictionaryTitle => 'Français (Lexique)';

  @override
  String get englishDictionaryTitle => 'Anglais (CMU)';

  @override
  String get dictionaryDownloadingMessage => 'Téléchargement…';

  @override
  String dictionaryDownloadingProgressMessage(int percent) {
    return 'Téléchargement… $percent %';
  }

  @override
  String get dictionaryImportingMessage =>
      'Importation dans la base de données…';

  @override
  String dictionaryFailedMessage(String error) {
    return 'Échec : $error';
  }

  @override
  String get dictionaryDownloadedMessage =>
      'Téléchargé — disponible hors ligne';

  @override
  String get dictionaryNotDownloadedMessage => 'Non téléchargé';

  @override
  String get dictionaryCheckingMessage => 'Vérification…';

  @override
  String get downloadButton => 'Télécharger';

  @override
  String get loopOnTooltip => 'Boucle activée (appuyer pour désactiver)';

  @override
  String get loopOffTooltip => 'Boucle désactivée (appuyer pour activer)';

  @override
  String get autoScrollTooltip =>
      'Défilement auto (appuyer pour passer en manuel)';

  @override
  String get manualScrollTooltip =>
      'Défilement manuel (appuyer pour passer en auto)';

  @override
  String get pauseVirtualClockTooltip =>
      'Mettre en pause le défilement automatique minuté';

  @override
  String get startVirtualClockTooltip =>
      'Démarrer le défilement automatique minuté (pas de fichier audio)';

  @override
  String get noRhymesFoundMessage => 'Aucune rime trouvée';

  @override
  String get cancelButton => 'Annuler';

  @override
  String get deleteButton => 'Supprimer';

  @override
  String errorGenericMessage(String error) {
    return 'Une erreur est survenue : $error';
  }
}
