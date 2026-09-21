// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'audio.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Audio {

 int get id; int get projetId; String get cheminLocal; int get dureeMs;
/// Create a copy of Audio
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AudioCopyWith<Audio> get copyWith => _$AudioCopyWithImpl<Audio>(this as Audio, _$identity);

  /// Serializes this Audio to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Audio;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Audio&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.projetId, _this.projetId) || other.projetId == _this.projetId)&&(identical(other.cheminLocal, _this.cheminLocal) || other.cheminLocal == _this.cheminLocal)&&(identical(other.dureeMs, _this.dureeMs) || other.dureeMs == _this.dureeMs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Audio;
  return Object.hash(runtimeType,_this.id,_this.projetId,_this.cheminLocal,_this.dureeMs);
}

@override
String toString() {
  final _this = this as Audio;
  return 'Audio(id: ${_this.id}, projetId: ${_this.projetId}, cheminLocal: ${_this.cheminLocal}, dureeMs: ${_this.dureeMs})';
}


}

/// @nodoc
abstract mixin class $AudioCopyWith<$Res>  {
  factory $AudioCopyWith(Audio value, $Res Function(Audio) _then) = _$AudioCopyWithImpl;
@useResult
$Res call({
 int id, int projetId, String cheminLocal, int dureeMs
});




}
/// @nodoc
class _$AudioCopyWithImpl<$Res>
    implements $AudioCopyWith<$Res> {
  _$AudioCopyWithImpl(this._self, this._then);

  final Audio _self;
  final $Res Function(Audio) _then;

/// Create a copy of Audio
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? projetId = null,Object? cheminLocal = null,Object? dureeMs = null,}) {
  return _then(Audio(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,projetId: null == projetId ? _self.projetId : projetId // ignore: cast_nullable_to_non_nullable
as int,cheminLocal: null == cheminLocal ? _self.cheminLocal : cheminLocal // ignore: cast_nullable_to_non_nullable
as String,dureeMs: null == dureeMs ? _self.dureeMs : dureeMs // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Audio].
extension AudioPatterns on Audio {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Audio value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Audio() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Audio value)  $default,){
final _that = this;
switch (_that) {
case _Audio():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Audio value)?  $default,){
final _that = this;
switch (_that) {
case _Audio() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int projetId,  String cheminLocal,  int dureeMs)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Audio() when $default != null:
return $default(_that.id,_that.projetId,_that.cheminLocal,_that.dureeMs);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int projetId,  String cheminLocal,  int dureeMs)  $default,) {final _that = this;
switch (_that) {
case _Audio():
return $default(_that.id,_that.projetId,_that.cheminLocal,_that.dureeMs);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int projetId,  String cheminLocal,  int dureeMs)?  $default,) {final _that = this;
switch (_that) {
case _Audio() when $default != null:
return $default(_that.id,_that.projetId,_that.cheminLocal,_that.dureeMs);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Audio implements Audio {
  const _Audio({required this.id, required this.projetId, required this.cheminLocal, required this.dureeMs});
  factory _Audio.fromJson(Map<String, dynamic> json) => _$AudioFromJson(json);

@override final  int id;
@override final  int projetId;
@override final  String cheminLocal;
@override final  int dureeMs;

/// Create a copy of Audio
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AudioCopyWith<_Audio> get copyWith => __$AudioCopyWithImpl<_Audio>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AudioToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Audio&&(identical(other.id, id) || other.id == id)&&(identical(other.projetId, projetId) || other.projetId == projetId)&&(identical(other.cheminLocal, cheminLocal) || other.cheminLocal == cheminLocal)&&(identical(other.dureeMs, dureeMs) || other.dureeMs == dureeMs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,projetId,cheminLocal,dureeMs);
}

@override
String toString() {
    return 'Audio(id: $id, projetId: $projetId, cheminLocal: $cheminLocal, dureeMs: $dureeMs)';
}


}

/// @nodoc
abstract mixin class _$AudioCopyWith<$Res> implements $AudioCopyWith<$Res> {
  factory _$AudioCopyWith(_Audio value, $Res Function(_Audio) _then) = __$AudioCopyWithImpl;
@override @useResult
$Res call({
 int id, int projetId, String cheminLocal, int dureeMs
});




}
/// @nodoc
class __$AudioCopyWithImpl<$Res>
    implements _$AudioCopyWith<$Res> {
  __$AudioCopyWithImpl(this._self, this._then);

  final _Audio _self;
  final $Res Function(_Audio) _then;

/// Create a copy of Audio
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? projetId = null,Object? cheminLocal = null,Object? dureeMs = null,}) {
  return _then(_Audio(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,projetId: null == projetId ? _self.projetId : projetId // ignore: cast_nullable_to_non_nullable
as int,cheminLocal: null == cheminLocal ? _self.cheminLocal : cheminLocal // ignore: cast_nullable_to_non_nullable
as String,dureeMs: null == dureeMs ? _self.dureeMs : dureeMs // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
