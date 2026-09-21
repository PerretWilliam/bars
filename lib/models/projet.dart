import 'package:freezed_annotation/freezed_annotation.dart';

part 'projet.freezed.dart';
part 'projet.g.dart';

@freezed
abstract class Projet with _$Projet {
  const factory Projet({
    required int id,
    required String nom,
    required String langueParDefaut,
    required DateTime createdAt,
  }) = _Projet;

  factory Projet.fromJson(Map<String, dynamic> json) => _$ProjetFromJson(json);
}
