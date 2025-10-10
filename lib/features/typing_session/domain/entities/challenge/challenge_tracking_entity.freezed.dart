// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'challenge_tracking_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChallengeTrackingEntity {

 DifficultyEnum get difficulty; String get timestamp;
/// Create a copy of ChallengeTrackingEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChallengeTrackingEntityCopyWith<ChallengeTrackingEntity> get copyWith => _$ChallengeTrackingEntityCopyWithImpl<ChallengeTrackingEntity>(this as ChallengeTrackingEntity, _$identity);

  /// Serializes this ChallengeTrackingEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChallengeTrackingEntity&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,difficulty,timestamp);

@override
String toString() {
  return 'ChallengeTrackingEntity(difficulty: $difficulty, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class $ChallengeTrackingEntityCopyWith<$Res>  {
  factory $ChallengeTrackingEntityCopyWith(ChallengeTrackingEntity value, $Res Function(ChallengeTrackingEntity) _then) = _$ChallengeTrackingEntityCopyWithImpl;
@useResult
$Res call({
 DifficultyEnum difficulty, String timestamp
});




}
/// @nodoc
class _$ChallengeTrackingEntityCopyWithImpl<$Res>
    implements $ChallengeTrackingEntityCopyWith<$Res> {
  _$ChallengeTrackingEntityCopyWithImpl(this._self, this._then);

  final ChallengeTrackingEntity _self;
  final $Res Function(ChallengeTrackingEntity) _then;

/// Create a copy of ChallengeTrackingEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? difficulty = null,Object? timestamp = null,}) {
  return _then(_self.copyWith(
difficulty: null == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as DifficultyEnum,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ChallengeTrackingEntity].
extension ChallengeTrackingEntityPatterns on ChallengeTrackingEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChallengeTrackingEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChallengeTrackingEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChallengeTrackingEntity value)  $default,){
final _that = this;
switch (_that) {
case _ChallengeTrackingEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChallengeTrackingEntity value)?  $default,){
final _that = this;
switch (_that) {
case _ChallengeTrackingEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DifficultyEnum difficulty,  String timestamp)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChallengeTrackingEntity() when $default != null:
return $default(_that.difficulty,_that.timestamp);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DifficultyEnum difficulty,  String timestamp)  $default,) {final _that = this;
switch (_that) {
case _ChallengeTrackingEntity():
return $default(_that.difficulty,_that.timestamp);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DifficultyEnum difficulty,  String timestamp)?  $default,) {final _that = this;
switch (_that) {
case _ChallengeTrackingEntity() when $default != null:
return $default(_that.difficulty,_that.timestamp);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChallengeTrackingEntity implements ChallengeTrackingEntity {
  const _ChallengeTrackingEntity({required this.difficulty, required this.timestamp});
  factory _ChallengeTrackingEntity.fromJson(Map<String, dynamic> json) => _$ChallengeTrackingEntityFromJson(json);

@override final  DifficultyEnum difficulty;
@override final  String timestamp;

/// Create a copy of ChallengeTrackingEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChallengeTrackingEntityCopyWith<_ChallengeTrackingEntity> get copyWith => __$ChallengeTrackingEntityCopyWithImpl<_ChallengeTrackingEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChallengeTrackingEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChallengeTrackingEntity&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,difficulty,timestamp);

@override
String toString() {
  return 'ChallengeTrackingEntity(difficulty: $difficulty, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class _$ChallengeTrackingEntityCopyWith<$Res> implements $ChallengeTrackingEntityCopyWith<$Res> {
  factory _$ChallengeTrackingEntityCopyWith(_ChallengeTrackingEntity value, $Res Function(_ChallengeTrackingEntity) _then) = __$ChallengeTrackingEntityCopyWithImpl;
@override @useResult
$Res call({
 DifficultyEnum difficulty, String timestamp
});




}
/// @nodoc
class __$ChallengeTrackingEntityCopyWithImpl<$Res>
    implements _$ChallengeTrackingEntityCopyWith<$Res> {
  __$ChallengeTrackingEntityCopyWithImpl(this._self, this._then);

  final _ChallengeTrackingEntity _self;
  final $Res Function(_ChallengeTrackingEntity) _then;

/// Create a copy of ChallengeTrackingEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? difficulty = null,Object? timestamp = null,}) {
  return _then(_ChallengeTrackingEntity(
difficulty: null == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as DifficultyEnum,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
