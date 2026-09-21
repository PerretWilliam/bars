// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'projet.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Projet _$ProjetFromJson(Map<String, dynamic> json) => _Projet(
  id: (json['id'] as num).toInt(),
  nom: json['nom'] as String,
  langueParDefaut: json['langueParDefaut'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$ProjetToJson(_Projet instance) => <String, dynamic>{
  'id': instance.id,
  'nom': instance.nom,
  'langueParDefaut': instance.langueParDefaut,
  'createdAt': instance.createdAt.toIso8601String(),
};
