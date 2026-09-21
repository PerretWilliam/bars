// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ligne.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Ligne _$LigneFromJson(Map<String, dynamic> json) => _Ligne(
  id: (json['id'] as num).toInt(),
  projetId: (json['projetId'] as num).toInt(),
  texte: json['texte'] as String,
  ordre: (json['ordre'] as num).toInt(),
  langueDetectee: json['langueDetectee'] as String?,
  timecodeMs: (json['timecodeMs'] as num?)?.toInt(),
);

Map<String, dynamic> _$LigneToJson(_Ligne instance) => <String, dynamic>{
  'id': instance.id,
  'projetId': instance.projetId,
  'texte': instance.texte,
  'ordre': instance.ordre,
  'langueDetectee': instance.langueDetectee,
  'timecodeMs': instance.timecodeMs,
};
