// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ligne.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Ligne {

 int get id; int get projetId; String get texte; int get ordre; String? get langueDetectee; int? get timecodeMs;
/// Create a copy of Ligne
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LigneCopyWith<Ligne> get copyWith => _$LigneCopyWithImpl<Ligne>(this as Ligne, _$identity);

  /// Serializes this Ligne to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Ligne;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Ligne&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.projetId, _this.projetId) || other.projetId == _this.projetId)&&(identical(other.texte, _this.texte) || other.texte == _this.texte)&&(identical(other.ordre, _this.ordre) || other.ordre == _this.ordre)&&(identical(other.langueDetectee, _this.langueDetectee) || other.langueDetectee == _this.langueDetectee)&&(identical(other.timecodeMs, _this.timecodeMs) || other.timecodeMs == _this.timecodeMs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Ligne;
  return Object.hash(runtimeType,_this.id,_this.projetId,_this.texte,_this.ordre,_this.langueDetectee,_this.timecodeMs);
}

@override
String toString() {
  final _this = this as Ligne;
  return 'Ligne(id: ${_this.id}, projetId: ${_this.projetId}, texte: ${_this.texte}, ordre: ${_this.ordre}, langueDetectee: ${_this.langueDetectee}, timecodeMs: ${_this.timecodeMs})';
}


}

/// @nodoc
abstract mixin class $LigneCopyWith<$Res>  {
  factory $LigneCopyWith(Ligne value, $Res Function(Ligne) _then) = _$LigneCopyWithImpl;
@useResult
$Res call({
 int id, int projetId, String texte, int ordre, String? langueDetectee, int? timecodeMs
});




}
/// @nodoc
class _$LigneCopyWithImpl<$Res>
    implements $LigneCopyWith<$Res> {
  _$LigneCopyWithImpl(this._self, this._then);

  final Ligne _self;
  final $Res Function(Ligne) _then;

/// Create a copy of Ligne
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? projetId = null,Object? texte = null,Object? ordre = null,Object? langueDetectee = freezed,Object? timecodeMs = freezed,}) {
  return _then(Ligne(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,projetId: null == projetId ? _self.projetId : projetId // ignore: cast_nullable_to_non_nullable
as int,texte: null == texte ? _self.texte : texte // ignore: cast_nullable_to_non_nullable
as String,ordre: null == ordre ? _self.ordre : ordre // ignore: cast_nullable_to_non_nullable
as int,langueDetectee: freezed == langueDetectee ? _self.langueDetectee : langueDetectee // ignore: cast_nullable_to_non_nullable
as String?,timecodeMs: freezed == timecodeMs ? _self.timecodeMs : timecodeMs // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [Ligne].
extension LignePatterns on Ligne {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Ligne value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Ligne() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Ligne value)  $default,){
final _that = this;
switch (_that) {
case _Ligne():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Ligne value)?  $default,){
final _that = this;
switch (_that) {
case _Ligne() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int projetId,  String texte,  int ordre,  String? langueDetectee,  int? timecodeMs)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Ligne() when $default != null:
return $default(_that.id,_that.projetId,_that.texte,_that.ordre,_that.langueDetectee,_that.timecodeMs);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int projetId,  String texte,  int ordre,  String? langueDetectee,  int? timecodeMs)  $default,) {final _that = this;
switch (_that) {
case _Ligne():
return $default(_that.id,_that.projetId,_that.texte,_that.ordre,_that.langueDetectee,_that.timecodeMs);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int projetId,  String texte,  int ordre,  String? langueDetectee,  int? timecodeMs)?  $default,) {final _that = this;
switch (_that) {
case _Ligne() when $default != null:
return $default(_that.id,_that.projetId,_that.texte,_that.ordre,_that.langueDetectee,_that.timecodeMs);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Ligne implements Ligne {
  const _Ligne({required this.id, required this.projetId, required this.texte, required this.ordre, this.langueDetectee, this.timecodeMs});
  factory _Ligne.fromJson(Map<String, dynamic> json) => _$LigneFromJson(json);

@override final  int id;
@override final  int projetId;
@override final  String texte;
@override final  int ordre;
@override final  String? langueDetectee;
@override final  int? timecodeMs;

/// Create a copy of Ligne
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LigneCopyWith<_Ligne> get copyWith => __$LigneCopyWithImpl<_Ligne>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LigneToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Ligne&&(identical(other.id, id) || other.id == id)&&(identical(other.projetId, projetId) || other.projetId == projetId)&&(identical(other.texte, texte) || other.texte == texte)&&(identical(other.ordre, ordre) || other.ordre == ordre)&&(identical(other.langueDetectee, langueDetectee) || other.langueDetectee == langueDetectee)&&(identical(other.timecodeMs, timecodeMs) || other.timecodeMs == timecodeMs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,projetId,texte,ordre,langueDetectee,timecodeMs);
}

@override
String toString() {
    return 'Ligne(id: $id, projetId: $projetId, texte: $texte, ordre: $ordre, langueDetectee: $langueDetectee, timecodeMs: $timecodeMs)';
}


}

/// @nodoc
abstract mixin class _$LigneCopyWith<$Res> implements $LigneCopyWith<$Res> {
  factory _$LigneCopyWith(_Ligne value, $Res Function(_Ligne) _then) = __$LigneCopyWithImpl;
@override @useResult
$Res call({
 int id, int projetId, String texte, int ordre, String? langueDetectee, int? timecodeMs
});




}
/// @nodoc
class __$LigneCopyWithImpl<$Res>
    implements _$LigneCopyWith<$Res> {
  __$LigneCopyWithImpl(this._self, this._then);

  final _Ligne _self;
  final $Res Function(_Ligne) _then;

/// Create a copy of Ligne
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? projetId = null,Object? texte = null,Object? ordre = null,Object? langueDetectee = freezed,Object? timecodeMs = freezed,}) {
  return _then(_Ligne(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,projetId: null == projetId ? _self.projetId : projetId // ignore: cast_nullable_to_non_nullable
as int,texte: null == texte ? _self.texte : texte // ignore: cast_nullable_to_non_nullable
as String,ordre: null == ordre ? _self.ordre : ordre // ignore: cast_nullable_to_non_nullable
as int,langueDetectee: freezed == langueDetectee ? _self.langueDetectee : langueDetectee // ignore: cast_nullable_to_non_nullable
as String?,timecodeMs: freezed == timecodeMs ? _self.timecodeMs : timecodeMs // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
