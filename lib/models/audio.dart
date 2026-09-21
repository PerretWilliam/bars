import 'package:freezed_annotation/freezed_annotation.dart';

part 'audio.freezed.dart';
part 'audio.g.dart';

@freezed
abstract class Audio with _$Audio {
  const factory Audio({
    required int id,
    required int projetId,
    required String cheminLocal,
    required int dureeMs,
  }) = _Audio;

  factory Audio.fromJson(Map<String, dynamic> json) => _$AudioFromJson(json);
}
