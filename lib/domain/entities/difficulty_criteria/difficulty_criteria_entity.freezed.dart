// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'difficulty_criteria_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DifficultyCriteriaEntity {

 String get type; int get accuracy; int get wpm; String get timelimit; double get xpMultiplier; double get difficultyMultiplier;
/// Create a copy of DifficultyCriteriaEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DifficultyCriteriaEntityCopyWith<DifficultyCriteriaEntity> get copyWith => _$DifficultyCriteriaEntityCopyWithImpl<DifficultyCriteriaEntity>(this as DifficultyCriteriaEntity, _$identity);

  /// Serializes this DifficultyCriteriaEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DifficultyCriteriaEntity&&(identical(other.type, type) || other.type == type)&&(identical(other.accuracy, accuracy) || other.accuracy == accuracy)&&(identical(other.wpm, wpm) || other.wpm == wpm)&&(identical(other.timelimit, timelimit) || other.timelimit == timelimit)&&(identical(other.xpMultiplier, xpMultiplier) || other.xpMultiplier == xpMultiplier)&&(identical(other.difficultyMultiplier, difficultyMultiplier) || other.difficultyMultiplier == difficultyMultiplier));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,accuracy,wpm,timelimit,xpMultiplier,difficultyMultiplier);

@override
String toString() {
  return 'DifficultyCriteriaEntity(type: $type, accuracy: $accuracy, wpm: $wpm, timelimit: $timelimit, xpMultiplier: $xpMultiplier, difficultyMultiplier: $difficultyMultiplier)';
}


}

/// @nodoc
abstract mixin class $DifficultyCriteriaEntityCopyWith<$Res>  {
  factory $DifficultyCriteriaEntityCopyWith(DifficultyCriteriaEntity value, $Res Function(DifficultyCriteriaEntity) _then) = _$DifficultyCriteriaEntityCopyWithImpl;
@useResult
$Res call({
 String type, int accuracy, int wpm, String timelimit, double xpMultiplier, double difficultyMultiplier
});




}
/// @nodoc
class _$DifficultyCriteriaEntityCopyWithImpl<$Res>
    implements $DifficultyCriteriaEntityCopyWith<$Res> {
  _$DifficultyCriteriaEntityCopyWithImpl(this._self, this._then);

  final DifficultyCriteriaEntity _self;
  final $Res Function(DifficultyCriteriaEntity) _then;

/// Create a copy of DifficultyCriteriaEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? accuracy = null,Object? wpm = null,Object? timelimit = null,Object? xpMultiplier = null,Object? difficultyMultiplier = null,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,accuracy: null == accuracy ? _self.accuracy : accuracy // ignore: cast_nullable_to_non_nullable
as int,wpm: null == wpm ? _self.wpm : wpm // ignore: cast_nullable_to_non_nullable
as int,timelimit: null == timelimit ? _self.timelimit : timelimit // ignore: cast_nullable_to_non_nullable
as String,xpMultiplier: null == xpMultiplier ? _self.xpMultiplier : xpMultiplier // ignore: cast_nullable_to_non_nullable
as double,difficultyMultiplier: null == difficultyMultiplier ? _self.difficultyMultiplier : difficultyMultiplier // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [DifficultyCriteriaEntity].
extension DifficultyCriteriaEntityPatterns on DifficultyCriteriaEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DifficultyCriteriaEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DifficultyCriteriaEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DifficultyCriteriaEntity value)  $default,){
final _that = this;
switch (_that) {
case _DifficultyCriteriaEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DifficultyCriteriaEntity value)?  $default,){
final _that = this;
switch (_that) {
case _DifficultyCriteriaEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String type,  int accuracy,  int wpm,  String timelimit,  double xpMultiplier,  double difficultyMultiplier)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DifficultyCriteriaEntity() when $default != null:
return $default(_that.type,_that.accuracy,_that.wpm,_that.timelimit,_that.xpMultiplier,_that.difficultyMultiplier);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String type,  int accuracy,  int wpm,  String timelimit,  double xpMultiplier,  double difficultyMultiplier)  $default,) {final _that = this;
switch (_that) {
case _DifficultyCriteriaEntity():
return $default(_that.type,_that.accuracy,_that.wpm,_that.timelimit,_that.xpMultiplier,_that.difficultyMultiplier);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String type,  int accuracy,  int wpm,  String timelimit,  double xpMultiplier,  double difficultyMultiplier)?  $default,) {final _that = this;
switch (_that) {
case _DifficultyCriteriaEntity() when $default != null:
return $default(_that.type,_that.accuracy,_that.wpm,_that.timelimit,_that.xpMultiplier,_that.difficultyMultiplier);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DifficultyCriteriaEntity implements DifficultyCriteriaEntity {
  const _DifficultyCriteriaEntity({required this.type, required this.accuracy, required this.wpm, required this.timelimit, required this.xpMultiplier, required this.difficultyMultiplier});
  factory _DifficultyCriteriaEntity.fromJson(Map<String, dynamic> json) => _$DifficultyCriteriaEntityFromJson(json);

@override final  String type;
@override final  int accuracy;
@override final  int wpm;
@override final  String timelimit;
@override final  double xpMultiplier;
@override final  double difficultyMultiplier;

/// Create a copy of DifficultyCriteriaEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DifficultyCriteriaEntityCopyWith<_DifficultyCriteriaEntity> get copyWith => __$DifficultyCriteriaEntityCopyWithImpl<_DifficultyCriteriaEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DifficultyCriteriaEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DifficultyCriteriaEntity&&(identical(other.type, type) || other.type == type)&&(identical(other.accuracy, accuracy) || other.accuracy == accuracy)&&(identical(other.wpm, wpm) || other.wpm == wpm)&&(identical(other.timelimit, timelimit) || other.timelimit == timelimit)&&(identical(other.xpMultiplier, xpMultiplier) || other.xpMultiplier == xpMultiplier)&&(identical(other.difficultyMultiplier, difficultyMultiplier) || other.difficultyMultiplier == difficultyMultiplier));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,accuracy,wpm,timelimit,xpMultiplier,difficultyMultiplier);

@override
String toString() {
  return 'DifficultyCriteriaEntity(type: $type, accuracy: $accuracy, wpm: $wpm, timelimit: $timelimit, xpMultiplier: $xpMultiplier, difficultyMultiplier: $difficultyMultiplier)';
}


}

/// @nodoc
abstract mixin class _$DifficultyCriteriaEntityCopyWith<$Res> implements $DifficultyCriteriaEntityCopyWith<$Res> {
  factory _$DifficultyCriteriaEntityCopyWith(_DifficultyCriteriaEntity value, $Res Function(_DifficultyCriteriaEntity) _then) = __$DifficultyCriteriaEntityCopyWithImpl;
@override @useResult
$Res call({
 String type, int accuracy, int wpm, String timelimit, double xpMultiplier, double difficultyMultiplier
});




}
/// @nodoc
class __$DifficultyCriteriaEntityCopyWithImpl<$Res>
    implements _$DifficultyCriteriaEntityCopyWith<$Res> {
  __$DifficultyCriteriaEntityCopyWithImpl(this._self, this._then);

  final _DifficultyCriteriaEntity _self;
  final $Res Function(_DifficultyCriteriaEntity) _then;

/// Create a copy of DifficultyCriteriaEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? accuracy = null,Object? wpm = null,Object? timelimit = null,Object? xpMultiplier = null,Object? difficultyMultiplier = null,}) {
  return _then(_DifficultyCriteriaEntity(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,accuracy: null == accuracy ? _self.accuracy : accuracy // ignore: cast_nullable_to_non_nullable
as int,wpm: null == wpm ? _self.wpm : wpm // ignore: cast_nullable_to_non_nullable
as int,timelimit: null == timelimit ? _self.timelimit : timelimit // ignore: cast_nullable_to_non_nullable
as String,xpMultiplier: null == xpMultiplier ? _self.xpMultiplier : xpMultiplier // ignore: cast_nullable_to_non_nullable
as double,difficultyMultiplier: null == difficultyMultiplier ? _self.difficultyMultiplier : difficultyMultiplier // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
