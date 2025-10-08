// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'gamification_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GamificationEntity {

 List<DifficultyCriteriaEntity> get difficultyCriteria; List<LevelEntity> get levels;
/// Create a copy of GamificationEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GamificationEntityCopyWith<GamificationEntity> get copyWith => _$GamificationEntityCopyWithImpl<GamificationEntity>(this as GamificationEntity, _$identity);

  /// Serializes this GamificationEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GamificationEntity&&const DeepCollectionEquality().equals(other.difficultyCriteria, difficultyCriteria)&&const DeepCollectionEquality().equals(other.levels, levels));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(difficultyCriteria),const DeepCollectionEquality().hash(levels));

@override
String toString() {
  return 'GamificationEntity(difficultyCriteria: $difficultyCriteria, levels: $levels)';
}


}

/// @nodoc
abstract mixin class $GamificationEntityCopyWith<$Res>  {
  factory $GamificationEntityCopyWith(GamificationEntity value, $Res Function(GamificationEntity) _then) = _$GamificationEntityCopyWithImpl;
@useResult
$Res call({
 List<DifficultyCriteriaEntity> difficultyCriteria, List<LevelEntity> levels
});




}
/// @nodoc
class _$GamificationEntityCopyWithImpl<$Res>
    implements $GamificationEntityCopyWith<$Res> {
  _$GamificationEntityCopyWithImpl(this._self, this._then);

  final GamificationEntity _self;
  final $Res Function(GamificationEntity) _then;

/// Create a copy of GamificationEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? difficultyCriteria = null,Object? levels = null,}) {
  return _then(_self.copyWith(
difficultyCriteria: null == difficultyCriteria ? _self.difficultyCriteria : difficultyCriteria // ignore: cast_nullable_to_non_nullable
as List<DifficultyCriteriaEntity>,levels: null == levels ? _self.levels : levels // ignore: cast_nullable_to_non_nullable
as List<LevelEntity>,
  ));
}

}


/// Adds pattern-matching-related methods to [GamificationEntity].
extension GamificationEntityPatterns on GamificationEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GamificationEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GamificationEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GamificationEntity value)  $default,){
final _that = this;
switch (_that) {
case _GamificationEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GamificationEntity value)?  $default,){
final _that = this;
switch (_that) {
case _GamificationEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<DifficultyCriteriaEntity> difficultyCriteria,  List<LevelEntity> levels)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GamificationEntity() when $default != null:
return $default(_that.difficultyCriteria,_that.levels);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<DifficultyCriteriaEntity> difficultyCriteria,  List<LevelEntity> levels)  $default,) {final _that = this;
switch (_that) {
case _GamificationEntity():
return $default(_that.difficultyCriteria,_that.levels);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<DifficultyCriteriaEntity> difficultyCriteria,  List<LevelEntity> levels)?  $default,) {final _that = this;
switch (_that) {
case _GamificationEntity() when $default != null:
return $default(_that.difficultyCriteria,_that.levels);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GamificationEntity implements GamificationEntity {
  const _GamificationEntity({required final  List<DifficultyCriteriaEntity> difficultyCriteria, required final  List<LevelEntity> levels}): _difficultyCriteria = difficultyCriteria,_levels = levels;
  factory _GamificationEntity.fromJson(Map<String, dynamic> json) => _$GamificationEntityFromJson(json);

 final  List<DifficultyCriteriaEntity> _difficultyCriteria;
@override List<DifficultyCriteriaEntity> get difficultyCriteria {
  if (_difficultyCriteria is EqualUnmodifiableListView) return _difficultyCriteria;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_difficultyCriteria);
}

 final  List<LevelEntity> _levels;
@override List<LevelEntity> get levels {
  if (_levels is EqualUnmodifiableListView) return _levels;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_levels);
}


/// Create a copy of GamificationEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GamificationEntityCopyWith<_GamificationEntity> get copyWith => __$GamificationEntityCopyWithImpl<_GamificationEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GamificationEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GamificationEntity&&const DeepCollectionEquality().equals(other._difficultyCriteria, _difficultyCriteria)&&const DeepCollectionEquality().equals(other._levels, _levels));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_difficultyCriteria),const DeepCollectionEquality().hash(_levels));

@override
String toString() {
  return 'GamificationEntity(difficultyCriteria: $difficultyCriteria, levels: $levels)';
}


}

/// @nodoc
abstract mixin class _$GamificationEntityCopyWith<$Res> implements $GamificationEntityCopyWith<$Res> {
  factory _$GamificationEntityCopyWith(_GamificationEntity value, $Res Function(_GamificationEntity) _then) = __$GamificationEntityCopyWithImpl;
@override @useResult
$Res call({
 List<DifficultyCriteriaEntity> difficultyCriteria, List<LevelEntity> levels
});




}
/// @nodoc
class __$GamificationEntityCopyWithImpl<$Res>
    implements _$GamificationEntityCopyWith<$Res> {
  __$GamificationEntityCopyWithImpl(this._self, this._then);

  final _GamificationEntity _self;
  final $Res Function(_GamificationEntity) _then;

/// Create a copy of GamificationEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? difficultyCriteria = null,Object? levels = null,}) {
  return _then(_GamificationEntity(
difficultyCriteria: null == difficultyCriteria ? _self._difficultyCriteria : difficultyCriteria // ignore: cast_nullable_to_non_nullable
as List<DifficultyCriteriaEntity>,levels: null == levels ? _self._levels : levels // ignore: cast_nullable_to_non_nullable
as List<LevelEntity>,
  ));
}


}

// dart format on
