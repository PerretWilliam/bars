// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audio.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Audio _$AudioFromJson(Map<String, dynamic> json) => _Audio(
  id: (json['id'] as num).toInt(),
  projetId: (json['projetId'] as num).toInt(),
  cheminLocal: json['cheminLocal'] as String,
  dureeMs: (json['dureeMs'] as num).toInt(),
);

Map<String, dynamic> _$AudioToJson(_Audio instance) => <String, dynamic>{
  'id': instance.id,
  'projetId': instance.projetId,
  'cheminLocal': instance.cheminLocal,
  'dureeMs': instance.dureeMs,
};
