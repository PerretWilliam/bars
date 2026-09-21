import '../data/app_database.dart';

/// The `.rapproj` bundle format version, bumped only if the JSON shape
/// changes in a way that requires migration on import.
const projectBundleFormatVersion = 1;

/// Everything needed to fully restore a project: reuses the drift-generated
/// row classes' own `toJson`/`fromJson`, which already exist for every
/// table.
class ProjectBundle {
  const ProjectBundle({required this.projet, required this.lignes, this.audio});

  final Projet projet;
  final List<Ligne> lignes;
  final Audio? audio;

  Map<String, dynamic> toJson() => {
    'formatVersion': projectBundleFormatVersion,
    'projet': projet.toJson(),
    'lignes': lignes.map((l) => l.toJson()).toList(),
    'audio': audio?.toJson(),
  };

  factory ProjectBundle.fromJson(Map<String, dynamic> json) {
    return ProjectBundle(
      projet: Projet.fromJson(json['projet'] as Map<String, dynamic>),
      lignes: (json['lignes'] as List)
          .map((e) => Ligne.fromJson(e as Map<String, dynamic>))
          .toList(),
      audio: json['audio'] == null
          ? null
          : Audio.fromJson(json['audio'] as Map<String, dynamic>),
    );
  }
}
