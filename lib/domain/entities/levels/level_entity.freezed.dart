// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'level_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LevelEntity {

 String get level;// e.g., 1, 2, 3, ...
 int get totalXp;
/// Create a copy of LevelEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LevelEntityCopyWith<LevelEntity> get copyWith => _$LevelEntityCopyWithImpl<LevelEntity>(this as LevelEntity, _$identity);

  /// Serializes this LevelEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LevelEntity&&(identical(other.level, level) || other.level == level)&&(identical(other.totalXp, totalXp) || other.totalXp == totalXp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,level,totalXp);

@override
String toString() {
  return 'LevelEntity(level: $level, totalXp: $totalXp)';
}


}

/// @nodoc
abstract mixin class $LevelEntityCopyWith<$Res>  {
  factory $LevelEntityCopyWith(LevelEntity value, $Res Function(LevelEntity) _then) = _$LevelEntityCopyWithImpl;
@useResult
$Res call({
 String level, int totalXp
});




}
/// @nodoc
class _$LevelEntityCopyWithImpl<$Res>
    implements $LevelEntityCopyWith<$Res> {
  _$LevelEntityCopyWithImpl(this._self, this._then);

  final LevelEntity _self;
  final $Res Function(LevelEntity) _then;

/// Create a copy of LevelEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? level = null,Object? totalXp = null,}) {
  return _then(_self.copyWith(
level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as String,totalXp: null == totalXp ? _self.totalXp : totalXp // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [LevelEntity].
extension LevelEntityPatterns on LevelEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LevelEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LevelEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LevelEntity value)  $default,){
final _that = this;
switch (_that) {
case _LevelEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LevelEntity value)?  $default,){
final _that = this;
switch (_that) {
case _LevelEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String level,  int totalXp)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LevelEntity() when $default != null:
return $default(_that.level,_that.totalXp);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String level,  int totalXp)  $default,) {final _that = this;
switch (_that) {
case _LevelEntity():
return $default(_that.level,_that.totalXp);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String level,  int totalXp)?  $default,) {final _that = this;
switch (_that) {
case _LevelEntity() when $default != null:
return $default(_that.level,_that.totalXp);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LevelEntity implements LevelEntity {
  const _LevelEntity({required this.level, required this.totalXp});
  factory _LevelEntity.fromJson(Map<String, dynamic> json) => _$LevelEntityFromJson(json);

@override final  String level;
// e.g., 1, 2, 3, ...
@override final  int totalXp;

/// Create a copy of LevelEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LevelEntityCopyWith<_LevelEntity> get copyWith => __$LevelEntityCopyWithImpl<_LevelEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LevelEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LevelEntity&&(identical(other.level, level) || other.level == level)&&(identical(other.totalXp, totalXp) || other.totalXp == totalXp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,level,totalXp);

@override
String toString() {
  return 'LevelEntity(level: $level, totalXp: $totalXp)';
}


}

/// @nodoc
abstract mixin class _$LevelEntityCopyWith<$Res> implements $LevelEntityCopyWith<$Res> {
  factory _$LevelEntityCopyWith(_LevelEntity value, $Res Function(_LevelEntity) _then) = __$LevelEntityCopyWithImpl;
@override @useResult
$Res call({
 String level, int totalXp
});




}
/// @nodoc
class __$LevelEntityCopyWithImpl<$Res>
    implements _$LevelEntityCopyWith<$Res> {
  __$LevelEntityCopyWithImpl(this._self, this._then);

  final _LevelEntity _self;
  final $Res Function(_LevelEntity) _then;

/// Create a copy of LevelEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? level = null,Object? totalXp = null,}) {
  return _then(_LevelEntity(
level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as String,totalXp: null == totalXp ? _self.totalXp : totalXp // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
