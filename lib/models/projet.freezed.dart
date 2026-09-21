// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'projet.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Projet {

 int get id; String get nom; String get langueParDefaut; DateTime get createdAt;
/// Create a copy of Projet
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjetCopyWith<Projet> get copyWith => _$ProjetCopyWithImpl<Projet>(this as Projet, _$identity);

  /// Serializes this Projet to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Projet;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Projet&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.nom, _this.nom) || other.nom == _this.nom)&&(identical(other.langueParDefaut, _this.langueParDefaut) || other.langueParDefaut == _this.langueParDefaut)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Projet;
  return Object.hash(runtimeType,_this.id,_this.nom,_this.langueParDefaut,_this.createdAt);
}

@override
String toString() {
  final _this = this as Projet;
  return 'Projet(id: ${_this.id}, nom: ${_this.nom}, langueParDefaut: ${_this.langueParDefaut}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $ProjetCopyWith<$Res>  {
  factory $ProjetCopyWith(Projet value, $Res Function(Projet) _then) = _$ProjetCopyWithImpl;
@useResult
$Res call({
 int id, String nom, String langueParDefaut, DateTime createdAt
});




}
/// @nodoc
class _$ProjetCopyWithImpl<$Res>
    implements $ProjetCopyWith<$Res> {
  _$ProjetCopyWithImpl(this._self, this._then);

  final Projet _self;
  final $Res Function(Projet) _then;

/// Create a copy of Projet
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? nom = null,Object? langueParDefaut = null,Object? createdAt = null,}) {
  return _then(Projet(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,nom: null == nom ? _self.nom : nom // ignore: cast_nullable_to_non_nullable
as String,langueParDefaut: null == langueParDefaut ? _self.langueParDefaut : langueParDefaut // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [Projet].
extension ProjetPatterns on Projet {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Projet value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Projet() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Projet value)  $default,){
final _that = this;
switch (_that) {
case _Projet():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Projet value)?  $default,){
final _that = this;
switch (_that) {
case _Projet() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String nom,  String langueParDefaut,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Projet() when $default != null:
return $default(_that.id,_that.nom,_that.langueParDefaut,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String nom,  String langueParDefaut,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _Projet():
return $default(_that.id,_that.nom,_that.langueParDefaut,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String nom,  String langueParDefaut,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _Projet() when $default != null:
return $default(_that.id,_that.nom,_that.langueParDefaut,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Projet implements Projet {
  const _Projet({required this.id, required this.nom, required this.langueParDefaut, required this.createdAt});
  factory _Projet.fromJson(Map<String, dynamic> json) => _$ProjetFromJson(json);

@override final  int id;
@override final  String nom;
@override final  String langueParDefaut;
@override final  DateTime createdAt;

/// Create a copy of Projet
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProjetCopyWith<_Projet> get copyWith => __$ProjetCopyWithImpl<_Projet>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProjetToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Projet&&(identical(other.id, id) || other.id == id)&&(identical(other.nom, nom) || other.nom == nom)&&(identical(other.langueParDefaut, langueParDefaut) || other.langueParDefaut == langueParDefaut)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,nom,langueParDefaut,createdAt);
}

@override
String toString() {
    return 'Projet(id: $id, nom: $nom, langueParDefaut: $langueParDefaut, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$ProjetCopyWith<$Res> implements $ProjetCopyWith<$Res> {
  factory _$ProjetCopyWith(_Projet value, $Res Function(_Projet) _then) = __$ProjetCopyWithImpl;
@override @useResult
$Res call({
 int id, String nom, String langueParDefaut, DateTime createdAt
});




}
/// @nodoc
class __$ProjetCopyWithImpl<$Res>
    implements _$ProjetCopyWith<$Res> {
  __$ProjetCopyWithImpl(this._self, this._then);

  final _Projet _self;
  final $Res Function(_Projet) _then;

/// Create a copy of Projet
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? nom = null,Object? langueParDefaut = null,Object? createdAt = null,}) {
  return _then(_Projet(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,nom: null == nom ? _self.nom : nom // ignore: cast_nullable_to_non_nullable
as String,langueParDefaut: null == langueParDefaut ? _self.langueParDefaut : langueParDefaut // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
