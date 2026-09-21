import 'package:freezed_annotation/freezed_annotation.dart';

part 'ligne.freezed.dart';
part 'ligne.g.dart';

@freezed
abstract class Ligne with _$Ligne {
  const factory Ligne({
    required int id,
    required int projetId,
    required String texte,
    required int ordre,
    String? langueDetectee,
    int? timecodeMs,
  }) = _Ligne;

  factory Ligne.fromJson(Map<String, dynamic> json) => _$LigneFromJson(json);
}
