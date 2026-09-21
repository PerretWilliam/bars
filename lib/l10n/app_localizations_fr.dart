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

  @override
  String get newFolderDialogTitle => 'Nouveau dossier';

  @override
  String get folderNameLabel => 'Nom du dossier';

  @override
  String get renameFolderDialogTitle => 'Renommer le dossier';

  @override
  String get renameFolderTooltip => 'Renommer le dossier';

  @override
  String get deleteFolderTooltip => 'Supprimer le dossier';

  @override
  String get deleteFolderDialogTitle => 'Supprimer le dossier ?';

  @override
  String deleteFolderDialogBody(String folderName) {
    return 'Ceci supprime « $folderName ». Ses projets reviennent dans la liste principale — ils ne sont pas supprimés.';
  }

  @override
  String get folderLabel => 'Dossier';

  @override
  String get noFolderOption => 'Aucun';

  @override
  String get viewAsListTooltip => 'Afficher en liste';

  @override
  String get viewAsGridTooltip => 'Afficher en grille';

  @override
  String get aboutTooltip => 'À propos';

  @override
  String get aboutTitle => 'À propos';

  @override
  String appVersionLabel(String version) {
    return 'Version $version';
  }

  @override
  String get authorWebsiteTooltip => 'Visiter mon site';

  @override
  String get githubTooltip => 'Voir sur GitHub';

  @override
  String get buyMeACoffeeTooltip => 'M\'offrir un café';

  @override
  String get legalMenuLabel => 'Mentions légales';

  @override
  String get changelogMenuLabel => 'Historique des versions';

  @override
  String get donateMenuLabel => 'Soutenir le projet';

  @override
  String get contributingMenuLabel => 'Contribuer';

  @override
  String get legalTitle => 'Mentions légales';

  @override
  String get legalPlaceholderText =>
      'Cette section est un espace réservé. Elle sera remplacée par la vraie politique de confidentialité et les conditions d\'utilisation avant une publication publique.';

  @override
  String get changelogTitle => 'Historique des versions';

  @override
  String get donateTitle => 'Soutenir le projet';

  @override
  String get donateIntro =>
      'Cette app n\'a ni pub ni abonnement. Si tu veux aider à couvrir les frais de publication, voici à quoi ça sert :';

  @override
  String get googleGoalLabel => 'Inscription Google Play (unique)';

  @override
  String get appleGoalLabel => 'Apple Developer Program (annuel)';

  @override
  String donateAmountLabel(String raised, String goal) {
    return '$raised € / $goal €';
  }

  @override
  String get buyMeACoffeeButtonLabel => 'M\'offrir un café';

  @override
  String get changelog100Notepad =>
      'Écris, réordonne et supprime des lignes, avec des suggestions de rimes en direct en français et en anglais';

  @override
  String get changelog100Timecoded =>
      'Mode timecode : importe un fichier audio et marque chaque ligne à son instant exact dans le morceau';

  @override
  String get changelog100RapMode =>
      'Mode rap : un affichage plein écran à défilement automatique synchronisé sur la lecture';

  @override
  String get changelog100ExportImport =>
      'Exporte et importe des projets sous forme de bundles .rapproj';

  @override
  String get changelog100ThemeAndIcons =>
      'Thème clair et sombre, un jeu d\'icônes complet, et une interface traduite en français et en anglais';

  @override
  String get changelog100FoldersAndInfo =>
      'Dossiers, affichage en liste ou en grille, et pages d\'infos, mentions légales et don';
}
